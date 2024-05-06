//
//  BannerCollectionViewCell.swift
//  DogRun
//
//  Created by 이재희 on 5/6/24.
//

import UIKit

final class BannerCollectionViewCell: BaseCollectionViewCell {
    
    private let titleLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        titleLabel.numberOfLines = 2
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        
        backgroundColor = .init(
            red: 0.5 + CGFloat.random(in: 0...0.5),
            green: 0.5 + CGFloat.random(in: 0...0.5),
            blue: 0.5 + CGFloat.random(in: 0...0.5),
            alpha: 0.8
        )
    }
    
    func configureData(title: String) {
        titleLabel.text = title
    }
    
}
