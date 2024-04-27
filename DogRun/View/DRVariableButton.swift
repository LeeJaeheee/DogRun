//
//  DRVariableButton.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import UIKit

final class DRVariableButton: UIButton {
    
    enum ButtonStyle {
        case filled
        case outlined
    }
    
    var basicHeight: Int { 60 }
    
    init(title: String, style: ButtonStyle, image: UIImage? = nil) {
        super.init(frame: .zero)
        
        isEnabled = true
        
        setTitle(image == nil ? title : " " + title, for: .normal)
        setImage(image, for: .normal)
        
        switch style {
        case .filled:
            setTitleColor(.white, for: .normal)
            tintColor = .white
            backgroundColor = .accent
        case .outlined:
            setTitleColor(.accent, for: .normal)
            tintColor = .accent
            backgroundColor = .white
            layer.borderColor = UIColor.systemGray5.cgColor
            layer.borderWidth = 1
        }
        
        titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        
        clipsToBounds = true
        layer.cornerRadius = 12
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
