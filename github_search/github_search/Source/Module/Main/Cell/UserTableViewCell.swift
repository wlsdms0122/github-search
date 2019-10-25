//
//  UserTableViewCell.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import Kingfisher

class UserTableViewCell: UITableViewCell, ReactorKit.View {
    // MARK: - view properties
    let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        return view
    }()
    
    let userIdLabel: UILabel = {
        let view = UILabel()
        view.font = Constants.Font.regular.withSize(17.adjust())
        return view
    }()
    
    let publicRepositoryLabel: UILabel = {
        let view = UILabel()
        view.font = Constants.Font.regular.withSize(12.adjust())
        view.textColor = Constants.Color.gray
        return view
    }()
    
    private lazy var infoStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [userIdLabel, publicRepositoryLabel])
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var profileStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [avatarImageView, infoStackView])
        view.axis = .horizontal
        view.spacing = 10.adjust()
        
        // Autolayout 제약조건 설정
        avatarImageView.snp.makeConstraints { make in
            make.width.equalTo(avatarImageView.snp.height)
        }
        
        return view
    }()
    
    // MARK: - properties
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - constructor
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        // Autolayout 제약조건 설정
        contentView.addAutolayoutSubview(profileStackView)
        profileStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10.adjust())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycle
    override func draw(_ rect: CGRect) {
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }
    
    // MARK: - bind
    func bind(reactor: UserTableViewCellReactor) {
        // MARK: action
        // MARK: state
        // 사용자 아바타
        reactor.state
            .map { $0.avatarUrl }
            .distinctUntilChanged()
            .compactMap { URL(string: $0) }
            .subscribe(onNext: { [weak self] in self?.avatarImageView.kf.setImage(with: $0) })
            .disposed(by: disposeBag)
        
        // 사용자 ID
        reactor.state
            .map { $0.userId }
            .distinctUntilChanged()
            .bind(to: userIdLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 사용자 Public repositoy 갯수
        reactor.state
            .map { $0.publicRepositoryCount }
            .distinctUntilChanged()
            .map { String(format: "user_public_repository_format".localized, $0) }
            .bind(to: publicRepositoryLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        // 이미지 다운로드가 진행중인 경우 재사용되기 전에 Task 취소
        avatarImageView.kf.cancelDownloadTask()
    }
}
