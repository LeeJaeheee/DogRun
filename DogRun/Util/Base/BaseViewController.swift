//
//  BaseViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/20/24.
//

import UIKit
import RxSwift
import Toast

class BaseViewController<T: BaseView>: UIViewController {
    
    let mainView: T = T()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        bind()
        configureNavigation()
        configureView()
    }
    
    func bind() { }
    func configureNavigation() { }
    func configureView() { }
    
    func showToast(_ message: String) {
        self.view.hideAllToasts()
        self.view.makeToast(message)
    }

}
