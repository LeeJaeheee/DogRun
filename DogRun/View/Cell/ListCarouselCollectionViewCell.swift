//
//  ListCarouselCollectionViewCell.swift
//  DogRun
//
//  Created by 이재희 on 5/6/24.
//

import UIKit
import SnapKit

final class ListCarouselCollectionViewCell: BaseCollectionViewCell {
    
    private let mainImage = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    override func configureHierarchy() {
        [mainImage, titleLabel, subTitleLabel].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        mainImage.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.width.equalTo(mainImage.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
            make.height.equalTo(20)
            make.leading.equalTo(mainImage.snp.trailing).offset(8)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(mainImage.snp.trailing).offset(8)
            make.height.equalTo(20)
            make.bottom.trailing.equalToSuperview().inset(8)
        }
    }
    
    override func configureView() {
        backgroundColor = .blue
    }
}

