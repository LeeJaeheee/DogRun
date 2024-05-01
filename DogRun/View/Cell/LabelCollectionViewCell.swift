//
//  LabelCollectionViewCell.swift
//  DogRun
//
//  Created by 이재희 on 5/1/24.
//

import UIKit
import SnapKit

final class LabelCollectionViewCell: BaseCollectionViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        //label.font = Constant.Font.bold(size: 26).font
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(label)
    }
    
    override func configureLayout() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(text: String?) {
        label.text = text
    }
    
}
