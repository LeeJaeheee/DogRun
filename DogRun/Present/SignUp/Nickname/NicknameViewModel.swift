//
//  NicknameViewModel.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let nickname: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let isNicknameValid: Driver<Bool>
        let nicknameCountLabel: Driver<String>
        let nickname: Driver<String>
        let nextButtonTap: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let maxNicknameLength = 10
        
        let nickname = input.nickname.orEmpty.share()
        
        let trimmedNickname = nickname
            .map {
                if $0.count > maxNicknameLength {
                    String($0.dropLast($0.count-maxNicknameLength))
                } else {
                    $0
                }
            }
            .asDriver(onErrorJustReturn: "")
        
        let nicknameCount = trimmedNickname
            .map { $0.count }
        
        let isNicknameValid = trimmedNickname
            .map { !$0.isEmpty }
            .asDriver()
        
        let nicknameCountLabel = nicknameCount
            .map { "\($0)/\(maxNicknameLength)" }
            .asDriver(onErrorJustReturn: "")
        
        return Output(
            isNicknameValid: isNicknameValid,
            nicknameCountLabel: nicknameCountLabel,
            nickname: trimmedNickname,
            nextButtonTap: input.nextButtonTap.asDriver()
        )
    }
    
}
