//
//  SNSPostViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/23/24.
//

import UIKit
import SwiftUI
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher
import Alamofire

final class SNSPostViewController: BaseViewController<SNSPostView> {
    
    var postVC: UserFeedViewController!
    
    override func bind() {

    }
    
    override func configureView() {
        
        postVC = UserFeedViewController()
        addChild(postVC)
        mainView.containerView.addSubview(postVC.view)
        postVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        postVC.didMove(toParent: self)

    }
}

