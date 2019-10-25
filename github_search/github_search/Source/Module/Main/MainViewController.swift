//
//  MainViewController.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class MainViewController: UIViewController, View {
    // MARK: - constants
    private let LOAD_MORE_THRESHOLD: CGFloat = 100
    
    // MARK: - view properties
    private var mainView: MainView { return self.view as! MainView }
    
    private var usernameSearchTextField: UISearchTextField { return mainView.usernameSearchTextField }
    private var userTableView: UITableView { return mainView.userTableView }
    
    private var loadingIndicatorView: UIActivityIndicatorView { return mainView.loadingIndicatorView }
    private var emptyLabel: UILabel { return mainView.emptyLabel }
    private var errorDescriptionLabel: UILabel { return mainView.errorDescriptionLabel }
    private var errorView: UIView { return mainView.errorView }
    
    // MARK: - properties
    var disposeBag: DisposeBag = DisposeBag()
    
    private let state: BehaviorRelay<UserTableViewState> = BehaviorRelay(value: .empty)
    
    private let dataSource = RxTableViewSectionedReloadDataSource<UserSectionModel>(configureCell: {
        dataSource, tableView, indexPath, reactor in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.name) as? UserTableViewCell else { fatalError() }
        
        // DI
        cell.reactor = reactor
        
        return cell
    })
    
    // MARK: - lifecycle
    override func loadView() {
        view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "main_navigation_title".localized
        
        // User table view cell 등록
        userTableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.name)
        
        // User table view delegate 설정
        userTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // Search text field delegate 설정
        usernameSearchTextField.delegate = self
    }
    
    // MARK: - bind
    func bind(reactor: MainViewReactor) {
        // MARK: action
        usernameSearchTextField.rx.text
            .orEmpty
            .filter { !$0.isEmpty }
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { Reactor.Action.updateQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        userTableView.rx.contentOffset
            .filter { [weak self] _ in
                guard let self = self else { return false }
                return self.userTableView.contentSize.height > self.userTableView.bounds.height
            }
            .filter { [weak self] _ in
                guard let self = self else { return false }
                return self.isReachEnd(of: self.userTableView)
            }
            .map { _ in Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: state
        // 사용자 리스트
        let sections = reactor.state
            .filter { $0.shouldSectionReload }
            .map { $0.sections }
            .share(replay: 1)
            
        sections.bind(to: userTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        sections.filter { $0.count > 0 }
            .map { $0[0].items.count > 0 }
            .map { $0 ? .regular : .empty }
            .bind(to: state)
            .disposed(by: disposeBag)
        
        // 로딩
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in .loading }
            .bind(to: state)
            .disposed(by: disposeBag)
        
        // 에러
        reactor.state
            .map { $0.error }
            .compactMap { $0 }
            .map { .error($0) }
            .bind(to: state)
            .disposed(by: disposeBag)
        
        // 푸터 뷰 설정
        state.subscribe(onNext: { [weak self] in self?.setFooterView(state: $0) })
            .disposed(by: disposeBag)
    }
    
    // MARK: - action method
    /// Table view의 content가 끝에 도달햇는지 확인
    private func isReachEnd(of tableView: UITableView) -> Bool {
        let contentOffsetY = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let height = tableView.bounds.height
        
        return contentOffsetY + height > contentHeight - LOAD_MORE_THRESHOLD
    }
    
    // MARK: - state method
    /// Table view 상태에 따라서 footer view 설정
    private func setFooterView(state: UserTableViewState) {
        userTableView.tableFooterView = nil
        
        switch state {
        case .loading:
            userTableView.tableFooterView = loadingIndicatorView
            
        case .empty:
            userTableView.tableFooterView = emptyLabel
            
        case let .error(message):
            errorDescriptionLabel.text = message
            userTableView.tableFooterView = errorView
            
        default:
            break
        }
        
        view.layoutIfNeeded()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.adjust()
    }
}

extension MainViewController: UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Return 선택시 포커스 잃음
        textField.resignFirstResponder()
        return true
    }
}

enum UserTableViewState {
    case regular
    case empty
    case loading
    case error(String)
}
