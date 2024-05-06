//
//  ChallengeSectionModel.swift
//  DogRun
//
//  Created by 이재희 on 5/6/24.
//

import Foundation

struct Section: Hashable {
    let id: String
}

enum SectionType: String, CaseIterable {
    case banner
    case normalCarousel
    case listCarousel
}

enum Item: Hashable {
    case banner(PostResponse)
    case recommend(PostResponse)
    case post(PostResponse)
}

