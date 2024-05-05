//
//  LaunchScreenView.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import UIKit
import Lottie
import SnapKit

final class LaunchScreenView: BaseView {
    
    private let animationView = LottieAnimationView()
    
    override func configureHierarchy() {
        addSubview(animationView)
    }
    
    override func configureLayout() {
        animationView.snp.makeConstraints { make in
            make.size.equalTo(240)
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        animationView.animation = LottieAnimation.named("launchPAW")
        animationView.play()
    }
    
}
