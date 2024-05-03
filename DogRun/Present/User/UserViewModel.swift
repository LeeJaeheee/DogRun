//
//  UserViewModel.swift
//  DogRun
//
//  Created by 이재희 on 5/3/24.
//

import Foundation
import RxSwift
import RxCocoa

final class UserViewModel: ViewModelType {
    enum UserType {
        case me
        case other
    }
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    var userId = UserDefaultsManager.userId
    var usertype: UserType {
        userId == UserDefaultsManager.userId ? .me : .other
    }
    
    struct Input {
        let loadTrigger: BehaviorRelay<Void>
        let buttonTap: ControlEvent<Void>
        let followerButtonTap: ControlEvent<Void>
        let followingButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let settingButtonTap: Driver<Void>
        let userFetchSuccess: PublishRelay<ProfileResponse>
        let userFetchFailure: PublishRelay<DRError>
        let followSuccess: PublishRelay<FollowResponse>
        let followFailure: PublishRelay<DRError>
        let followerButtonTap: Driver<Void>
        let followingButtonTap: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let userFetchSuccess = PublishRelay<ProfileResponse>()
        let userFetchFailure = PublishRelay<DRError>()
        let followSuccess = PublishRelay<FollowResponse>()
        let followFailure = PublishRelay<DRError>()
        let settingButtonTap = PublishRelay<Void>()
        
        input.loadTrigger
            .flatMapLatest { _ in
                return NetworkManager.request2(type: ProfileResponse.self, router: UserRouter.userProfile(id: self.userId))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    userFetchSuccess.accept(success)
                case .failure(let failure):
                    userFetchFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        switch usertype {
        case .me:
            input.buttonTap
                .bind(to: settingButtonTap)
                .disposed(by: disposeBag)
        case .other:
            input.buttonTap
                .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
                .withLatestFrom(userFetchSuccess.asObservable())
                .flatMap { user -> Single<Result<FollowResponse, DRError>> in
                    if user.followers.map({ $0.user_id }).contains(UserDefaultsManager.userId) {
                        return NetworkManager.request2(type: FollowResponse.self, router: FollowRouter.unfollow(userId: self.userId))
                    } else {
                        return NetworkManager.request2(type: FollowResponse.self, router: FollowRouter.follow(userId: self.userId))
                    }
                }
                .bind(with: self) { owner, response in
                    switch response {
                    case .success(let success):
                        followSuccess.accept(success)
                    case .failure(let failure):
                        followFailure.accept(failure)
                    }
                }
                .disposed(by: disposeBag)
        }
        
        return Output(
            settingButtonTap: settingButtonTap.asDriver(onErrorJustReturn: ()),
            userFetchSuccess: userFetchSuccess,
            userFetchFailure: userFetchFailure,
            followSuccess: followSuccess,
            followFailure: followFailure,
            followerButtonTap: input.followerButtonTap.asDriver(),
            followingButtonTap: input.followingButtonTap.asDriver()
        )
    }
}
