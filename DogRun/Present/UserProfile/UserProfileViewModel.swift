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
    }

    struct Output {
        let sections: BehaviorRelay<[SectionModel<ProfileItem>]>
        let navigateToDetail: Observable<ProfileItem>
        let fetchSuccess: PublishRelay<ProfileResponse>
        let fetchFailure: PublishRelay<DRError>
    }

    func transform(input: Input) -> Output {
        var sectionRelay = BehaviorRelay<[SectionModel<ProfileItem>]>(value: [])
        let fetchSuccessRelay = PublishRelay<ProfileResponse>()
        let fetchFailureRelay = PublishRelay<DRError>()
        
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
        
        return Output(sections: sectionRelay,
                      navigateToDetail: navigateToDetail,
                      fetchSuccess: fetchSuccessRelay,
                      fetchFailure: fetchFailureRelay)
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
