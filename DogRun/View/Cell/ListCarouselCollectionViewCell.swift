//
//  ListCarouselCollectionViewCell.swift
//  DogRun
//
//  Created by 이재희 on 5/6/24.
//

import UIKit
import SnapKit

final class ListCarouselCollectionViewCell: BaseCollectionViewCell {
    
    private let containerView = UIView()
    private let mainImage = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let regionLabel = UILabel()
    private let priceLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(containerView)
        [mainImage, regionLabel, priceLabel, titleLabel, subTitleLabel].forEach { containerView.addSubview($0) }
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainImage.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.width.equalTo(mainImage.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.height.equalTo(20)
            make.leading.equalTo(mainImage.snp.trailing).offset(8)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(mainImage.snp.trailing).offset(8)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().inset(8)
        }
        
        regionLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(16)
            make.leading.equalTo(mainImage.snp.trailing).offset(8)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(12)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(regionLabel)
            make.leading.equalTo(regionLabel.snp.trailing).offset(8)
            make.height.equalTo(20)
        }
    }
    
    override func configureView() {
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.systemGray6.cgColor
        containerView.layer.borderWidth = 1
        containerView.clipsToBounds = true
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        subTitleLabel.font = .systemFont(ofSize: 15)
        subTitleLabel.textColor = .lightGray
        
        [regionLabel, priceLabel].forEach { label in
            label.backgroundColor = .init(white: 0.4, alpha: 0.6)
            label.font = .systemFont(ofSize: 14, weight: .bold)
            label.textColor = .white
            label.layer.cornerRadius = 4
            label.clipsToBounds = true
        }
    }
    
    func configureData(data: ChallengeResponse) {
        titleLabel.text = data.title
        subTitleLabel.text = data.content
        mainImage.kf.setImage(with: URL(string: data.imageStrings.first!))
        regionLabel.text = "  \(data.region)  "
        priceLabel.text = "  \(data.price)원  "
    }
}

