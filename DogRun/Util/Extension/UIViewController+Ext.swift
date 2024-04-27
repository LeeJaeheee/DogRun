//
//  UIViewController+Ext.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import UIKit

extension UIViewController {
    
    func changeRootView(to viewController: UIViewController, isNav: Bool = false) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let sceneDelegate = windowScene.delegate as? SceneDelegate
        let vc = isNav ? UINavigationController(rootViewController: viewController) : viewController
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKey()
    }

}
