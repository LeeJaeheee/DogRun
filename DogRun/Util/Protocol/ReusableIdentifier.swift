//
//  ReusableIdentifier.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import UIKit

protocol ReusableIdentifier { }

extension ReusableIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView: ReusableIdentifier { }
