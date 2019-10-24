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
    // MARK: - view properties
    private var mainView: MainView { return self.view as! MainView }
    
    // MARK: - properties
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - lifecycle
    override func loadView() {
        view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - bind
    func bind(reactor: MainViewReactor) {
        // MARK: action
        
        // MARK: state
    }
}

