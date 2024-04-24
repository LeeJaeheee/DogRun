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
                .init(title: self.rawValue, content: data.phoneNum)
        case .birthdate:
                .init(title: self.rawValue, content: data.birthDay)
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
        let itemSelected: Observable<IndexPath>
    }

    struct Output {
        let sections: Observable<[SectionModel<ProfileItem>]>
        let navigateToDetail: Observable<ProfileItem>
    }

    func transform(input: Input) -> Output {
        var sectionModels: [SectionModel<ProfileItem>] = []
        
        for section in ProfileSection.allCases {
            var items: [ProfileItem] = []
            
            for title in section.titles {
                items.append(title.getProfileItem(data: .init(user_id: "1", email: "test@test.com", nick: "닉네임", phoneNum: "010-0000-0000", birthDay: "2024년 1월 1일", profileImage: nil, followers: [], following: [], posts: [])))
            }
            
            let sectionModel = SectionModel<ProfileItem>(items: items)
            sectionModels.append(sectionModel)
        }
        
        let sections = Observable.just(sectionModels)
        
        let navigateToDetail = input.itemSelected
            .withLatestFrom(sections) { indexPath, sections in
                return sections[indexPath.section].items[indexPath.row]
            }
        
        return Output(sections: sections, navigateToDetail: navigateToDetail)
    }
}
