//
//  DROpaqueView.swift
//  DogRun
//
//  Created by 이재희 on 5/1/24.
//

import UIKit

class DROpaqueView: BaseView {
    
    override func configureView() {
        backgroundColor = .systemBackground.withAlphaComponent(0.4)
        layer.cornerRadius = 18
    }
    
    func setBorder(width: CGFloat) {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = width
    }
    
}
