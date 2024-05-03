//
//  UserHeaderView.swift
//  DogRun
//
//  Created by 이재희 on 5/3/24.
//

import UIKit
import Kingfisher

final class UserHeaderView: BaseView {
    
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let button = DRVariableButton(title: "설정", style: .outlined)
    
    let followerButton = UIButton()
    let separatorView = UIView()
    let followingButton = UIButton()
    
    lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [followerButton, separatorView, followingButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        //stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    override func configureHierarchy() {
        [profileImageView, nicknameLabel, button, buttonsStackView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        button.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(64)
            make.height.equalTo(28)
        }
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(16)
            make.size.equalTo(100)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.height.equalTo(20)
        }
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            //make.width.equalTo(200)
            //make.bottom.equalToSuperview().inset(20)
        }
        separatorView.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        followerButton.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        followingButton.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
    }
    
    override func configureView() {
        //profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.cornerRadius = 20
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .systemGray5
        
        nicknameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
 
        separatorView.backgroundColor = .systemGray6
        
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 14
    }
    
    func configureData(data: ProfileResponse) {
        
        if let profileImage = data.profileImage {
            profileImageView.kf.setImage(with: URL(string: APIKey.baseURL.rawValue+"/"+profileImage))
        } else {
            profileImageView.backgroundColor = .systemGray5
        }
        
        nicknameLabel.text = data.nick
        
        followerButton.setFollowerButtonTitle(title: "팔로워", count: data.followers.count)
        followingButton.setFollowerButtonTitle(title: "팔로잉", count: data.following.count)
        
        if data.user_id == UserDefaultsManager.userId {
            button.setTitle("설정", for: .normal)
        } else if data.followers.map({ $0.user_id }).contains(UserDefaultsManager.userId) {
            button.setTitle("언팔로우", for: .normal)
        } else {
            button.setTitle("팔로우", for: .normal)
        }
        
        layoutIfNeeded()
    }
}
