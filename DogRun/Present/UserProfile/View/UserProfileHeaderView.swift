//
//  UserProfileHeaderView.swift
//  DogRun
//
//  Created by 이재희 on 4/24/24.
//

import UIKit
import SnapKit

final class UserProfileHeaderView: BaseView {

    let profileImageView = UIImageView()
    let emailLabel = UILabel()
    let sinceBirthDateLabel = UILabel()
    
    override func configureHierarchy() {
        [profileImageView, emailLabel, sinceBirthDateLabel].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
            make.size.equalTo(100)
        }
        emailLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.height.equalTo(20)
        }
        sinceBirthDateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
    }
    
    override func configureView() {
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.cornerRadius = 50
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .systemGray5
        
        emailLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        sinceBirthDateLabel.font = .systemFont(ofSize: 15)
    }
    
    func configureData(image: UIImage, email: String, sinceBirthDate: String) {
        profileImageView.image = image
        emailLabel.text = email
        sinceBirthDateLabel.text = sinceBirthDate
        
        layoutIfNeeded()
    }

}
