//
//  PinterestCollectionViewCell.swift
//  DogRun
//
//  Created by 이재희 on 5/4/24.
//

import UIKit

final class PinterestCollectionViewCell: BaseCollectionViewCell {
    let containerView = UIView()
    let imageView = UIImageView()
    let profileView = ProfileInfoView(imageSize: 36, cornerRadius: 12, nicknameFontSize: 13, dateFontSize: 12, spacing: 8)
    let hashtagLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(containerView)
        [imageView, profileView, hashtagLabel].forEach { containerView.addSubview($0) }
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        hashtagLabel.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(20)
        }
        
        profileView.snp.makeConstraints { make in
            make.bottom.equalTo(hashtagLabel.snp.top).offset(-16)
            make.horizontalEdges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(profileView.snp.top)
        }
    }
    
    override func configureView() {
        containerView.layer.cornerRadius = 16
        containerView.layer.borderColor = UIColor.systemGray6.cgColor
        containerView.layer.borderWidth = 1
        containerView.clipsToBounds = true
        
        hashtagLabel.textColor = .accent
        hashtagLabel.font = .systemFont(ofSize: 13)
    }
}
