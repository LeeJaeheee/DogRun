//
//  validationCheckLabel.swift
//  DogRun
//
//  Created by 이재희 on 4/28/24.
//

import UIKit
import SnapKit

final class ValidationView: UIView {
    
    var imageView: UIImageView
    var label: DRLabel
    
    var isValid: Bool = false {
        didSet {
            imageView.tintColor = isValid ? .accent : .lightGray
        }
    }
    
    init(text: String, image: UIImage) {
        imageView = UIImageView(image: image)
        label = DRLabel(text: text, style: .body)
        
        super.init(frame: .zero)
        
        addSubview(imageView)
        addSubview(label)
        
        imageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.width.equalTo(imageView.snp.height)
        }
        
        label.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(8)
        }
        
        imageView.tintColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
