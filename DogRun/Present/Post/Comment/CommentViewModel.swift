//
//  CommentViewModel.swift
//  DogRun
//
//  Created by 이재희 on 5/2/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CommentViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    var comments = PublishRelay<[Comment]>()
    
    struct Input {
        
    }
    
    struct Output {
        let comments: Driver<[Comment]>
    }
    
    func transform(input: Input) -> Output {
        
        Output(comments: comments.asDriver(onErrorJustReturn: []))
    }
}
