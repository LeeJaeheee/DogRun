//
//  CommentTableViewCell.swift
//  DogRun
//
//  Created by 이재희 on 5/2/24.
//

import UIKit

final class CommentTableViewCell: BaseTableViewCell {
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let commentLabel = UILabel()
    let deleteButton = UIButton()
    
    override func configureHierarchy() {
        [profileImageView, nicknameLabel, commentLabel, deleteButton].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.size.equalTo(48)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.centerY.equalTo(profileImageView).offset(-12)
            make.height.equalTo(20)
        }
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(nicknameLabel)
            make.height.greaterThanOrEqualTo(20)
            make.bottom.equalToSuperview().inset(16)
        }
        deleteButton.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(nicknameLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(nicknameLabel)
            make.size.equalTo(24)
        }
    }
    
    override func configureView() {
        selectionStyle = .none
        
        profileImageView.layer.cornerRadius = 16
        profileImageView.clipsToBounds = true
        
        nicknameLabel.font = .systemFont(ofSize: 13)
        nicknameLabel.textColor = .lightGray
        
        commentLabel.font = .systemFont(ofSize: 14)
        commentLabel.numberOfLines = 0
        
        deleteButton.setImage(UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14)), for: .normal)
        deleteButton.tintColor = .systemRed
    }
    
    func configureData(data: Comment) {
        if let image = data.creator.profileImage {
            profileImageView.kf.setImage(with: URL(string: APIKey.baseURL.rawValue+"/"+image))
        } else {
            profileImageView.backgroundColor = .systemGray6
        }
        
        nicknameLabel.text = "\(data.creator.nick) • \(data.createdAt)"
        
        commentLabel.text = data.content
        
        deleteButton.isHidden = !(data.creator.user_id == UserDefaultsManager.userId)
        print(data.creator.user_id)
        print(UserDefaultsManager.userId)
    }
}
