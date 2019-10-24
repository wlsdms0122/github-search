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
    
    let usersTableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    // MARK: - properties
    
    // MARK: - constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.Color.white
        
        addAutolayoutSubviews([usernameSearchTextField, usersTableView])
        usernameSearchTextField.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(safeAreaLayoutGuide).inset(10.adjust())
            } else {
                make.top.equalToSuperview().inset(64).inset(10.adjust())
            }
            make.leading.equalToSuperview().inset(10.adjust())
            make.trailing.equalToSuperview().inset(10.adjust())
        }
        
        usersTableView.snp.makeConstraints { make in
            make.top.equalTo(usernameSearchTextField.snp.bottom).offset(10.adjust())
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
}
