//
//  DRRoundImageButton.swift
//  DogRun
//
//  Created by 이재희 on 4/29/24.
//

import UIKit

class DRRoundImageButton: UIButton {
    
    init(imageName: String, tintColor: UIColor = .accent, backgroundWhite: CGFloat = 0) {
        super.init(frame: .zero)
        
        setImage(UIImage(systemName: imageName), for: .normal)
        self.tintColor = tintColor
        backgroundColor = UIColor(white: backgroundWhite, alpha: 0.4)
    }
    
    init(buttonImage: ButtonImages) {
        super.init(frame: .zero)
        
        setImage(UIImage(systemName: buttonImage.imageName), for: .normal)
        self.tintColor = buttonImage.tintColor
        backgroundColor = UIColor(white: buttonImage.backgroundWhite, alpha: 0.4)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        clipsToBounds = true
        layer.cornerRadius = self.frame.width/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
