//
//  ModeBaseView.swift
//  DogRun
//
//  Created by 이재희 on 4/28/24.
//

import UIKit

class ModeBaseView: UIView {
    
    var mode: Mode
    
    required init(mode: Mode = .basic) {
        self.mode = mode
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureView()
        configureMode()
        configureData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() { }
    func configureMode() { }
    func configureData() { }
    
}
