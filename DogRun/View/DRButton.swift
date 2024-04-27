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
    
    var basicHeight: Int { 52 }
    
    init(title: String) {
        super.init(frame: .zero)
        
        isEnabled = true
        
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        clipsToBounds = true
        layer.cornerRadius = 12

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
