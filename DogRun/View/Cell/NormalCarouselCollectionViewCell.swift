//
//  NormalCarouselCollectionViewCell.swift
//  DogRun
//
//  Created by 이재희 on 5/6/24.
//

import UIKit
import SnapKit
import Kingfisher

class NormalCarouselCollectionViewCell: BaseCollectionViewCell {

    private let mainImage = UIImageView()
    private let containerView = UIView()
    private let titleLabel = DRLabel(text: "", style: .title)
    private let subLabel = DRLabel(text: "", style: .subtitle)
    private let bookmarkButton = UIButton()
    private let registerButton = DRButton(title: "참여하기")
    
    
    override func configureHierarchy() {
        [mainImage, containerView, bookmarkButton, registerButton].forEach { contentView.addSubview($0) }
        [titleLabel, subLabel].forEach { containerView.addSubview($0) }
    }
    
    override func configureLayout() {
        mainImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview().inset(16)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().multipliedBy(0.8)
            make.size.equalTo(70)
        }
        
        registerButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    override func configureView() {
        backgroundColor = .accent
    }

}
