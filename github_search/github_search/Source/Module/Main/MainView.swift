//
//  MainView.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import UIKit
import SnapKit

class MainView: UIView {
    // MARK: - view properties
    let usernameSearchTextField: UISearchTextField = {
        let view = UISearchTextField()
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()
    
    let userTableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    let loadingIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 80)))
        view.startAnimating()
        return view
    }()
    
    let emptyLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = Constants.Font.regular.withSize(20.adjust())
        view.numberOfLines = 0
        view.text = "search_result_empty_title".localized
        return view
    }()
    
    private let errorTitleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = Constants.Font.regular.withSize(20.adjust())
        view.numberOfLines = 0
        view.text = "search_result_error_title".localized
        return view
    }()
    
    let errorDescriptionLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = Constants.Font.regular.withSize(17.adjust())
        view.textColor = Constants.Color.gray
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var errorStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [errorTitleLabel, errorDescriptionLabel])
        view.axis = .vertical
        view.spacing = 5.adjust()
        return view
    }()
    
    lazy var errorView: UIView = {
        let view = UIView()
        
        // Autolayout 제약조건 설정
        view.addAutolayoutSubview(errorStackView)
        errorStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return view
    }()
    
    // MARK: - properties
    
    // MARK: - constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.Color.white
        
        // Autolayout 제약조건 설정
        addAutolayoutSubviews([usernameSearchTextField, userTableView])
        usernameSearchTextField.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(safeAreaLayoutGuide).inset(10.adjust())
            } else {
                make.top.equalToSuperview().inset(64).inset(10.adjust())
            }
            make.leading.equalToSuperview().inset(10.adjust())
            make.trailing.equalToSuperview().inset(10.adjust()).priorityHigh()
        }
        
        userTableView.snp.makeConstraints { make in
            make.top.equalTo(usernameSearchTextField.snp.bottom).offset(10.adjust()).priorityHigh()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(safeAreaLayoutGuide)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        emptyLabel.frame = userTableView.bounds
        errorView.frame = userTableView.bounds
    }
}
