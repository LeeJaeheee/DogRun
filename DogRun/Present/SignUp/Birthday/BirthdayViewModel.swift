//
//  BirthdayViewModel.swift
//  DogRun
//
//  Created by 이재희 on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

// TODO: 생일 초기값 있으면 datepicker에서 해당 날짜 선택해주기
final class BirthdayViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    var email: String = ""
    var password: String = ""
    var nickname: String = ""
    var phoneNumber: String = ""
    var birthday: String = ""
    
    struct Input {
        let birthday: ControlProperty<String?>
        let dateChanged: ControlProperty<Date>
        let doneButtonTap: ControlEvent<Void>
        let nextButtonTap: ControlEvent<Void>
        let barDoneButtonTap: ControlEvent<Void>
    }

    struct Output {
        let formattedDate: Driver<String>
        let doneButtonTap: Driver<Void>
        let isNextButtonEnabled: Driver<Bool>
        let nextButtonTap: Driver<Void>
        let signUpSuccess: PublishRelay<LoginRequest>
        let signUpFailure: PublishRelay<DRError>
        let updateSuccess: PublishRelay<ProfileResponse>
        let updateFailure: PublishRelay<DRError>
    }

    func transform(input: Input) -> Output {
        let signUpSuccess = PublishRelay<LoginRequest>()
        let signUpFailure = PublishRelay<DRError>()
        
        let updateSuccess = PublishRelay<ProfileResponse>()
        let updateFailure = PublishRelay<DRError>()
        
        let formattedDate = input.dateChanged
            .skip(1)
            .map { DateFormatterManager.shared.string(from: $0) }
            .asDriver(onErrorJustReturn: "")
        
        formattedDate
            .drive(with: self) { owner, value in
                owner.birthday = value
            }
            .disposed(by: disposeBag)

        let isNextButtonEnabled = input.birthday.orEmpty
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        input.nextButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map {
                JoinRequest(email: self.email, password: self.password, nick: self.nickname, phoneNum: self.phoneNumber, birthDay: self.birthday)
            }
            .flatMap { joinRequest in
                return NetworkManager.request2(type: JoinResponse.self, router: UserRouter.join(model: joinRequest))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    dump(success)
                    UserDefaultsManager.userId = success.user_id
                    signUpSuccess.accept((.init(email: owner.email, password: owner.password)))
                case .failure(let failure):
                    print(failure)
                    signUpFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        input.barDoneButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .withLatestFrom(formattedDate)
            .flatMap { value in
                return NetworkManager.requestMultipart(type: ProfileResponse.self, router: UserRouter.editMyProfile(model: .init(nick: nil, phoneNum: nil, birthDay: value, profile: nil)))
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let success):
                    updateSuccess.accept((success))
                case .failure(let failure):
                    updateFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            formattedDate: formattedDate,
            doneButtonTap: input.doneButtonTap.asDriver(),
            isNextButtonEnabled: isNextButtonEnabled,
            nextButtonTap: input.nextButtonTap.asDriver(),
            signUpSuccess: signUpSuccess,
            signUpFailure: signUpFailure,
            updateSuccess: updateSuccess,
            updateFailure: updateFailure
        )
    }
    
}

