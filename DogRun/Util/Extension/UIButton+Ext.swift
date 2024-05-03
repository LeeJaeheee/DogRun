//
//  UIButton+Ext.swift
//  DogRun
//
//  Created by 이재희 on 5/3/24.
//

import UIKit

extension UIButton {
    
    func setFollowerButtonTitle(title: String, count: Int) {
        titleLabel?.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.gray,
            .paragraphStyle: paragraphStyle
        ]
        
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSMutableAttributedString(string: "\(title)\n", attributes: attributes)
        let numberAttributedString = NSAttributedString(string: "\(count)", attributes: numberAttributes)
        attributedString.append(numberAttributedString)
        
        setAttributedTitle(attributedString, for: .normal)
    }
    
}
