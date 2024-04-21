//
//  DRLabel.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import UIKit

enum TextStyle {
    case title
    case subtitle
    case body
}

final class DRLabel: UILabel {

    init(text: String, style: TextStyle) {
        super.init(frame: .zero)
        self.text = text
        configureStyle(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStyle(_ style: TextStyle) {
        
        switch style {
        case .title:
            font = UIFont.systemFont(ofSize: 28, weight: .heavy)
            textColor = .black
        case .subtitle:
            font = UIFont.systemFont(ofSize: 18)
            textColor = .darkGray
        case .body:
            font = UIFont.systemFont(ofSize: 14)
            textColor = .lightGray
        }
        
        numberOfLines = 0
    }

}
