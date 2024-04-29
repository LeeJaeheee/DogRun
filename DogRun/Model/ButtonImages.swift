//
//  ButtonImages.swift
//  DogRun
//
//  Created by 이재희 on 4/29/24.
//

import UIKit

enum ButtonImages {
    case heart
    case numOne
    case numTwo
    
    var imageName: String {
        switch self {
        case .heart:
            "heart.fill"
        case .numOne:
            "drop.fill"
        case .numTwo:
            "hands.sparkles.fill"
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .heart:
                .systemRed
        case .numOne:
                .systemYellow
        case .numTwo:
                .systemOrange
        }
    }
    
    var backgroundWhite: CGFloat {
        0
    }
}
