//
//  UserProfileHeaderView.swift
//  DogRun
//
//  Created by 이재희 on 4/24/24.
//

import UIKit
import SnapKit
import Kingfisher

final class UserProfileHeaderView: BaseView {

    let profileImageButton = UIButton()
    let emailLabel = UILabel()
    
    override func configureHierarchy() {
        [profileImageButton, emailLabel].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        profileImageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(160)
        }
        emailLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageButton.snp.bottom).offset(12)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(32)
        }
    }
    
    override func configureView() {
        profileImageButton.layer.cornerRadius = 20
        profileImageButton.clipsToBounds = true
        profileImageButton.backgroundColor = .systemGray5
        
        emailLabel.font = .systemFont(ofSize: 16, weight: .medium)
        emailLabel.textColor = .gray
    }
    
    func configureData(data: ProfileResponse) {
        if let profileImage = data.profileImage {
            profileImageButton.kf.setBackgroundImage(with: URL(string: APIKey.baseURL.rawValue+"/"+profileImage), for: .normal)
        }
        
        emailLabel.text = data.email
    }

}
