//
//  DRButton.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import UIKit

final class DRButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .accent : .lightGray
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = isEnabled ? .accent : .lightGray
        
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        clipsToBounds = true
        layer.cornerRadius = 12

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
