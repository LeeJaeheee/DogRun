//
//  BasePopUpViewController.swift
//  DogRun
//
//  Created by 이재희 on 5/1/24.
//

import UIKit
import RxSwift

class BasePopUpViewController<T: BasePopUpView>: UIViewController {
    
    let mainView: T = T()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.mainView.containerView.transform = .identity
            self?.mainView.containerView.isHidden = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.mainView.containerView.transform = .identity
            self?.mainView.containerView.isHidden = true
        }
    }
    
    func configureView() { }
    func bind() { }

}
