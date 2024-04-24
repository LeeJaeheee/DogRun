//
//  SectionModel.swift
//  DogRun
//
//  Created by 이재희 on 4/24/24.
//

import Foundation
import RxDataSources

struct SectionModel<T> {
    var header: String?
    var items: [T]
}

extension SectionModel: SectionModelType {
    typealias Item = T

    init(original: SectionModel<Item>, items: [Item]) {
        self = original
        self.items = items
    }
}
