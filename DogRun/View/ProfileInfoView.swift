//
//  ProfileInfoView.swift
//  DogRun
//
//  Created by 이재희 on 5/4/24.
//

import UIKit

class ProfileInfoView: UIView {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubview(profileImageView)
        addSubview(nicknameLabel)
        addSubview(dateLabel)
    }
    
    private func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(20)
            make.size.equalTo(60)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.top.equalTo(profileImageView.snp.top).offset(4)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(26)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.height.equalTo(20)
        }
    }
    
    func configureData(data: PostResponse) {
        if let profileImage = data.creator.profileImage {
            profileImageView.kf.setImage(with: URL(string: APIKey.baseURL.rawValue+"/"+profileImage))
        } else {
            profileImageView.image = nil
        }
        nicknameLabel.text = data.creator.nick
        dateLabel.text = data.createdAt
    }
}
