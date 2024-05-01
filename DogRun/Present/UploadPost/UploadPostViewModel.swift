//
//  UploadPostViewModel.swift
//  DogRun
//
//  Created by 이재희 on 5/1/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class UploadPostViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let cancelButtonTapped: ControlEvent<Void>
        //let addImageButtonTapped: ControlEvent<Void>
        let imagePickerResults: PublishRelay<[UIImage]>
    }
    
    struct Output {
        let images: Driver<[UploadItem]>
        let content: Driver<UploadItem>
        let showAlert: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let imagesRelay = BehaviorRelay<[UploadItem]>(value: [.init(type: .image(UIImage(systemName: "plus.square.fill.on.square.fill")))])
         let contentRelay = BehaviorRelay<UploadItem>(value: .init(type: .text("")))
         
         input.imagePickerResults
             .map { images in
                 return images.map { UploadItem(type: .image($0)) }
             }
             .bind(to: imagesRelay)
             .disposed(by: disposeBag)
         
         let cancelAlert = input.cancelButtonTapped
             .map { "취소 버튼 탭" }
             .asSignal(onErrorJustReturn: "")
         
         return Output(images: imagesRelay.asDriver(),
                       content: contentRelay.asDriver(),
                       showAlert: cancelAlert)
    }
}
