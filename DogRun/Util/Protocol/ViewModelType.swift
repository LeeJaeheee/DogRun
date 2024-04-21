//
//  ViewModelType.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
