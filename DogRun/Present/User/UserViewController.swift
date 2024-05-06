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
    
    let loadTrigger = BehaviorRelay<Void>(value: ())
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        // FIXME: viewWillAppear 말고 변경 시에만 load하기
        loadTrigger.accept(())
    }

    override func bind() {
        let input = UserViewModel.Input(
            loadTrigger: loadTrigger,
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
        output.followSuccess
            .bind(with: self) { owner, response in
                owner.loadTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        output.followFailure
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
            }
            .disposed(by: disposeBag)
        
        output.followers
            .drive(with: self) { owner, followers in
                let vc = FollowerViewController()
                vc.users.accept(followers)
                vc.title = "팔로워"
                let nav = UINavigationController(rootViewController: vc)
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.followings
            .drive(with: self) { owner, followings in
                let vc = FollowerViewController()
                vc.users.accept(followings)
                vc.title = "팔로잉"
                let nav = UINavigationController(rootViewController: vc)
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
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
