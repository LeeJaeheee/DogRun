//
//  UserViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/25/24.
//

import UIKit
import SnapKit

final class UserViewController: BaseViewController<UserView> {
    var userTabmanViewController: UserTabmanViewController!
    
    override func configureView() {
        userTabmanViewController = UserTabmanViewController()
        addChild(userTabmanViewController)
        mainView.containerView.addSubview(userTabmanViewController.view)
        userTabmanViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        userTabmanViewController.didMove(toParent: self)

    }
}
