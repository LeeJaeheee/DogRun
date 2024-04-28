//
//  ModeBaseViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/28/24.
//

import UIKit
import RxSwift

enum Mode {
    case basic
    case modify
}

class ModeBaseViewController<T: ModeBaseView>: UIViewController {
    
    var mainView: T
    let disposeBag = DisposeBag()
    
    init(mode: Mode = .basic) {
        self.mainView = T(mode: mode)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
    
}
