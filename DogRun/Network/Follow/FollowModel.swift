//
//  FollowModel.swift
//  DogRun
//
//  Created by 이재희 on 5/3/24.
//

import Foundation

struct FollowResponse: Decodable {
    let nick: String
    let opponent_nick: String
    let following_status: Bool
}
