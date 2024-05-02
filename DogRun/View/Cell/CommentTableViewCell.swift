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
    
    override func configureHierarchy() {
        [profileImageView, nicknameLabel, commentLabel].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.size.equalTo(48)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(profileImageView).offset(-8)
            make.height.equalTo(20)
        }
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.horizontalEdges.equalTo(nicknameLabel)
            make.height.greaterThanOrEqualTo(20)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureView() {
        profileImageView.layer.cornerRadius = 16
        profileImageView.clipsToBounds = true
        
        nicknameLabel.font = .systemFont(ofSize: 13)
        nicknameLabel.textColor = .lightGray
        
        commentLabel.font = .systemFont(ofSize: 14)
        commentLabel.numberOfLines = 0
    }
    
    func configureData(data: Comment) {
        if let image = data.creator.profileImage {
            profileImageView.kf.setImage(with: URL(string: APIKey.baseURL.rawValue+"/"+image))
        } else {
            profileImageView.backgroundColor = .systemGray6
        }
        
        nicknameLabel.text = "\(data.creator.nick) • \(data.createdAt)"
        
        commentLabel.text = data.content
    }
}
