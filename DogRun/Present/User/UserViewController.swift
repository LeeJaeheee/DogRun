//
//  UserViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class UserViewController: BaseViewController<UserView> {
    var userTabmanViewController: UserTabmanViewController!
    
    let viewModel = UserViewModel()

    override func bind() {
        let input = UserViewModel.Input(
            loadTrigger: BehaviorRelay<Void>(value: ()),
            buttonTap: mainView.profileView.button.rx.tap,
            followerButtonTap: mainView.profileView.followerButton.rx.tap,
            followingButtonTap: mainView.profileView.followingButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.settingButtonTap
            .drive(with: self) { owner, _ in
                let vc = UserProfileViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.userFetchSuccess
            .bind(with: self) { owner, response in
                owner.mainView.profileView.configureData(data: response)
            }
            .disposed(by: disposeBag)
        
        output.userFetchFailure
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
            }
            .disposed(by: disposeBag)
        
        // TODO: 팔로우 기능 연결하기
//        output.followSuccess
//            .bind(with: self) { owner, response in
//                owner.mainView.profileView.button.
//            }
    }
    
    override func configureView() {
        userTabmanViewController = UserTabmanViewController()
        userTabmanViewController.userId = viewModel.userId
        
        addChild(userTabmanViewController)
        mainView.containerView.addSubview(userTabmanViewController.view)
        userTabmanViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        userTabmanViewController.didMove(toParent: self)
    }
}
