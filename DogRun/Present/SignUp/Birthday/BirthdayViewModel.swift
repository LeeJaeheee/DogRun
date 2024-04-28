//
//  BirthdayViewModel.swift
//  DogRun
//
//  Created by 이재희 on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let birthday: ControlProperty<String?>
        let dateChanged: ControlProperty<Date>
        let doneButtonTap: ControlEvent<Void>
        let nextButtonTap: ControlEvent<Void>
    }

    struct Output {
        let formattedDate: Driver<String>
        let doneButtonTap: Driver<Void>
        let isNextButtonEnabled: Driver<Bool>
        let nextButtonTap: Driver<Void>
    }

    func transform(input: Input) -> Output {
        let formattedDate = input.dateChanged
            .skip(1)
            .map { DateFormatterManager.shared.string(from: $0) }
            .asDriver(onErrorJustReturn: "")

        let isNextButtonEnabled = input.birthday.orEmpty
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            formattedDate: formattedDate,
            doneButtonTap: input.doneButtonTap.asDriver(),
            isNextButtonEnabled: isNextButtonEnabled,
            nextButtonTap: input.nextButtonTap.asDriver())
    }
}
