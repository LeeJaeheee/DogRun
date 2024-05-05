//
//  UserProfileViewModel.swift
//  DogRun
//
//  Created by 이재희 on 4/24/24.
//

import Foundation
import RxSwift
import RxCocoa

struct ProfileItem {
    let title: String
    let content: String?
}

enum ProfileTitle: String, CaseIterable {
    case nickname = "닉네임"
    case phoneNumber = "휴대폰번호"
    case birthdate = "생년월일"
    
    func getProfileItem(data: ProfileResponse) -> ProfileItem {
        switch self {
        case .nickname:
                .init(title: self.rawValue, content: data.nick)
        case .phoneNumber:
                .init(title: self.rawValue, content: data.phoneNum ?? "")
        case .birthdate:
                .init(title: self.rawValue, content: data.birthDay ?? "")
        }
    }
}

enum ProfileSection: CaseIterable {
    case firstSection
    case secondSection
    
    var titles: [ProfileTitle] {
        switch self {
        case .firstSection:
            return [.nickname]
        case .secondSection:
            return [.phoneNumber, .birthdate]
        }
    }
}

final class UserProfileViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()

    struct Input {
        let loadTrigger: BehaviorRelay<Void>
        let updateTrigger: PublishRelay<ProfileResponse>
        let itemSelected: Observable<IndexPath>
        let profileUpdated: PublishRelay<Data>
        let withdrawButtonTap: ControlEvent<Void>
        let withdraw: PublishRelay<Void>
    }

    struct Output {
        let sections: BehaviorRelay<[SectionModel<ProfileItem>]>
        let navigateToDetail: Observable<ProfileItem>
        let fetchSuccess: PublishRelay<ProfileResponse>
        let fetchFailure: PublishRelay<DRError>
        let profileUpdateSuccess: PublishRelay<ProfileResponse>
        let profileUpdateFailure: PublishRelay<DRError>
        let confirmWithdraw: Driver<Void>
        let withdrawSuccess: PublishRelay<Void>
        let withdrawFailure: PublishRelay<DRError>
    }

    func transform(input: Input) -> Output {
        var sectionRelay = BehaviorRelay<[SectionModel<ProfileItem>]>(value: [])
        let fetchSuccessRelay = PublishRelay<ProfileResponse>()
        let fetchFailureRelay = PublishRelay<DRError>()
        
        let profileUpdateSuccess = PublishRelay<ProfileResponse>()
        let profileUpdateFailure = PublishRelay<DRError>()
        
        let withdrawSuccess = PublishRelay<Void>()
        let withdrawFailure = PublishRelay<DRError>()
        
        input.loadTrigger
            .flatMap { _ in
                return NetworkManager.request2(type: ProfileResponse.self, router: UserRouter.getMyProfile)
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    let sectionModels = owner.createSectionModels(success)
                    sectionRelay.accept(sectionModels)
                    fetchSuccessRelay.accept(success)
                case .failure(let failure):
                    fetchFailureRelay.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        let navigateToDetail = input.itemSelected
            .withLatestFrom(sectionRelay) { indexPath, sections in
                return sections[indexPath.section].items[indexPath.row]
            }
        
        input.updateTrigger
            .bind(with: self) { owner, response in
                let sectionModels = owner.createSectionModels(response)
                sectionRelay.accept(sectionModels)
            }
            .disposed(by: disposeBag)
        
        input.profileUpdated
            .flatMap { data in
                return NetworkManager.requestMultipart(type: ProfileResponse.self, router: UserRouter.editMyProfile(model: .init(nick: nil, phoneNum: nil, birthDay: nil, profile: data)))
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let success):
                    profileUpdateSuccess.accept((success))
                case .failure(let failure):
                    profileUpdateFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        input.withdraw
            .flatMap { _ in
                NetworkManager.request2(type: WithdrawResponse.self, router: UserRouter.withdraw)
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(_):
                    UserDefaultsManager.accessToken = ""
                    UserDefaultsManager.refreshToken = ""
                    UserDefaultsManager.userId = ""
                    withdrawSuccess.accept(())
                case .failure(let failure):
                    withdrawFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(sections: sectionRelay,
                      navigateToDetail: navigateToDetail,
                      fetchSuccess: fetchSuccessRelay,
                      fetchFailure: fetchFailureRelay,
                      profileUpdateSuccess: profileUpdateSuccess,
                      profileUpdateFailure: profileUpdateFailure, 
                      confirmWithdraw: input.withdrawButtonTap.asDriver(),
                      withdrawSuccess: withdrawSuccess,
                      withdrawFailure: withdrawFailure
        )
    }
    
    private func createSectionModels(_ profileResponse: ProfileResponse) -> [SectionModel<ProfileItem>] {
            var sectionModels: [SectionModel<ProfileItem>] = []
            
            for section in ProfileSection.allCases {
                var items: [ProfileItem] = []
                
                for title in section.titles {
                    items.append(title.getProfileItem(data: profileResponse))
                }
                
                let sectionModel = SectionModel<ProfileItem>(items: items)
                sectionModels.append(sectionModel)
            }
            
            return sectionModels
        }
    

}
