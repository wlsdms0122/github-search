//
//  MainViewReactor.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import ReactorKit
import RxSwift
import RxDataSources

class MainViewReactor: Reactor {
    enum Action {
        /// 사용자 이름 갱신
        case updateQuery(String)
        
        /// 다음 사용자 정보 요청
        case loadMore
    }
    
    enum Mutation {
        /// 검색할 사용자 이름 설정
        case setQuery(String)
        
        /// 사용자 목록 페이지 설정
        case setPage(Int)
        
        /// 요청 상태 설정
        case setLoading(Bool)
        
        /// 섹션 정보 갱신
        case sectionReload
        
        /// 오류 메시지 설정
        case setError(String)
    }
    
    struct State {
        /// 검색할 사용자 이름
        var query: String
        
        /// 사용자 목록 페이지
        var page: Int
        
        /// 요청 상태
        var isLoading: Bool
        
        /// 사용자 목록 데이터 소스
        private(set) var sectionDataSource: UserDataSource
        
        /// 사용자 목록 섹션
        var sections: [UserSectionModel] {
            return sectionDataSource.makeSections()
        }
        
        /// 섹셩 정보 갱신 필요 여부
        var shouldSectionReload: Bool
        
        /// 오류 메시지
        var error: String?
    }
    
    // MARK: - properties
    var initialState: State
    private let networkService: NetworkServiceProtocol
    
    private var isLastPage: Bool = false
    
    // MARK: - constructor
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        
        initialState = State(query: "",
                             page: 1,
                             isLoading: false,
                             sectionDataSource: UserDataSource(),
                             shouldSectionReload: true)
    }
    
    // MARK: - mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuery(query):
            return actionUpdateQuery(query)
            
        case .loadMore:
            return actionLoadMore()
        }
    }
    
    // MARK: - reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.shouldSectionReload = false
        state.error = nil
        
        switch mutation {
        case let .setQuery(query):
            state.query = query
            return state
            
        case let .setPage(page):
            state.page = page
            return state
            
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            return state
            
        case .sectionReload:
            state.shouldSectionReload = true
            return state
            
        case let .setError(error):
            state.error = error
            return state
        }
    }
    
    // MARK: - action method
    private func actionUpdateQuery(_ query: String) -> Observable<Mutation> {
        let state = currentState
        guard state.query != query else { return .empty() }
        
        networkService.cancleAllRequest() // 진행중인 네트워크 요청 전체 취소
        state.sectionDataSource.users.removeAll() // 사용자 목록 초기화
        
        // State 초기화
        let initializedState: Observable<Mutation> = .concat(
            .just(.sectionReload),
            .just(.setQuery(query)),
            .just(.setPage(1))
        )
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            // 공백 문자 검색 예외처리
            return .concat(
                initializedState,
                .just(.setError("search_error_whitespace_title".localized))
            )
        }
        
        // 첫번째 사용자 목록 요청
        let fetchedUsers: Observable<Mutation> = fetchUsers(query: query, page: 1)
            .do(onNext: { state.sectionDataSource.users = $0 })
            .map { _ in .sectionReload }
            .catchError { .just(.setError(($0 as? LocalizedError)?.errorDescription ?? "")) }
        
        return .concat(
            initializedState,
            .just(.setLoading(true)),
            fetchedUsers,
            .just(.setLoading(false))
        )
    }
    
    private func actionLoadMore() -> Observable<Mutation> {
        let state = currentState
        guard !state.isLoading && !state.sectionDataSource.users.isEmpty && !isLastPage else { return .empty() }
        
        // 다음 사용자 목록 요청
        let fetchedUsers: Observable<Mutation> = fetchUsers(query: state.query, page: state.page + 1)
            .do(onNext: { state.sectionDataSource.users.append(contentsOf: $0) },
                onError: { _ in state.sectionDataSource.users.removeAll() })
            .map { _ in .sectionReload }
            .catchError { .just(.setError(($0 as? LocalizedError)?.errorDescription ?? "")) }
        
        return .concat(
            .just(.setPage(state.page + 1)),
            .just(.setLoading(true)),
            fetchedUsers,
            .just(.setLoading(false))
        )
    }
    
    // MARK: - private method
    private func fetchUsers(query: String, page: Int) -> Observable<[User]> {
        return networkService.requestGithubUsers(name: query, page: page)
            .do(onSuccess: {
                // Header Link 값을 통해 마지막 페이지 인지 확인
                if let link = $0.response.allHeaderFields["Link"] as? String,
                    self.parseLinkHeader(link)["next"] != nil {
                    self.isLastPage = false
                } else {
                    self.isLastPage = true
                }
            })
            .flatMap {
                return Single.zip($0.data.items.compactMap {
                    guard let id = $0.id else { return nil }
                    return self.networkService.requestGithubUser(name: id).map { $0.data }
                })
            }
            .asObservable()
    }
    
    /// API header의 LINK 파싱
    private func parseLinkHeader(_ link: String) -> [String: String] {
        var linkDictionary: [String: String] = [:]
        
        link.components(separatedBy: ",").forEach {
            let links = $0.components(separatedBy: ";")
            
            guard let urlPart = links.first, let url = urlPart.substring(start: "<", last: ">"),
                let relPart = links.last, let rel = relPart.substring(start: "\"", last: "\"") else { return }
            
            linkDictionary[rel] = url
        }
        
        return linkDictionary
    }
}

typealias UserSectionModel = SectionModel<Void, UserTableViewCellReactor>

class UserDataSource {
    var users: [User] = []
    
    func makeSections() -> [UserSectionModel] {
        return [UserSectionModel(model: Void(), items: users.compactMap { UserTableViewCellReactor(user: $0) })]
    }
}
