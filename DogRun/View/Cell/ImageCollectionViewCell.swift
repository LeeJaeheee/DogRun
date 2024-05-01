//
//  ImageCollectionViewCell.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import UIKit
import SnapKit

class ImageCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImageCell() {
        backgroundColor = .init(white: 1.0, alpha: 0.5)
        clipsToBounds = true
        layer.cornerRadius = 12
        
        imageView.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
    }
    
    func configure(imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
}
