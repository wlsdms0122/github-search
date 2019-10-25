//
//  NetworkService.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum NetworkError: LocalizedError {
    case urlNotCorrect
    case emptyData
    case parseError
    
    var errorDescription: String? {
        switch self {
        case .urlNotCorrect:
            return "network_error_url_not_correct_title".localized
            
        case .emptyData:
            return "netrowk_error_empty_data_title".localized
            
        case .parseError:
            return "network_error_parse_error".localized
        }
    }
}

protocol NetworkServiceProtocol {
    /// Github 사용자 목록 요청
    func requestGithubUsers(name: String, page: Int) -> Single<ApiResponse<UserSearchReseponse>>
    
    /// Github 사용자 정보 요청
    func requestGithubUser(name: String) -> Single<ApiResponse<User>>
    
    /// 모든 API 요청 취소
    func cancleAllRequest()
}

class NetworkService: BaseService, NetworkServiceProtocol {
    func requestGithubUsers(name: String, page: Int) -> Single<ApiResponse<UserSearchReseponse>> {
        return ApiProvider<GithubApi>.request(.search(name, page))
    }
    
    func requestGithubUser(name: String) -> Single<ApiResponse<User>> {
        return ApiProvider<GithubApi>.request(.user(name))
    }
    
    func cancleAllRequest() {
        Alamofire.Session.default.cancelAllRequests()
    }
}

struct ApiProvider<API: ApiType> {
    static func request<Model: Codable>(_ api: API) -> Single<ApiResponse<Model>> {
        Logger.info("request api : \(api.url.absoluteString)", tag: "NETWORK")
        return Single.create { emitter in
            AF.request(api.url, method: api.method, parameters: api.parameters, headers: api.headers)
                .response { data in
                    if let error = data.error {
                        Logger.error(error.errorDescription ?? "network error occured!", tag: "NETWORK")
                        emitter(.error(error))
                    }
                    
                    // Unwrap response data
                    guard let jsonData = data.data, let response = data.response else {
                        emitter(.error(NetworkError.emptyData))
                        return
                    }
                    
                    // Parse json data to model object
                    guard let model = JSONCodec.decode(jsonData, type: Model.self) else {
                        emitter(.error(NetworkError.parseError))
                        return
                    }
                    
                    emitter(.success(ApiResponse(data: model, response: response)))
            }
            
            return Disposables.create()
        }
    }
}

struct ApiResponse<Model> {
    let data: Model
    let response: HTTPURLResponse
}

protocol ApiType {
    /// Base url of api
    var baseUrl: URL { get }
    
    /// Specific path of api
    var path: String { get }
    
    /// Request method of http api
    var method: HTTPMethod { get }
    
    /// Parameters of http api
    var parameters: Parameters? { get }
    
    /// Header of http api
    var headers: HTTPHeaders? { get }
}

extension ApiType {
    var url: URL { baseUrl.appendingPathComponent(path) }
}

enum GithubApi: ApiType {
    case search(String, Int)
    case user(String)
    
    var baseUrl: URL { return URL(string: "https://api.github.com")! }
    
    var path: String {
        switch self {
        case .search(_):
            return "/search/users"
            
        case let .user(username):
            return "/users/\(username)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        switch self {
        case let .search(username, page):
            return ["q": "\(username) in:login",
                    "page": page,
                    "per_page": 20]
            
        case .user(_):
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }
    
    
}
