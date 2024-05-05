//
//  FollowerTableViewCell.swift
//  DogRun
//
//  Created by 이재희 on 5/5/24.
//

import UIKit
import SnapKit

final class FollowerTableViewCell: BaseTableViewCell {
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        [profileImageView, nicknameLabel].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(44)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.centerY.equalTo(profileImageView)
            make.height.equalTo(20)
        }
    }
    
    override func configureView() {
        selectionStyle = .none
        
        profileImageView.layer.cornerRadius = 16
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .systemGray6
        
        nicknameLabel.font = .systemFont(ofSize: 15, weight: .medium)
        nicknameLabel.textColor = .darkGray
 
    }
    
    func configureData(data: Follower) {
        if let image = data.profileImage {
            profileImageView.kf.setImage(with: URL(string: APIKey.baseURL.rawValue+"/"+image))
        } else {
            profileImageView.image = nil
        }
        
        nicknameLabel.text = data.nick
        
    }
}
