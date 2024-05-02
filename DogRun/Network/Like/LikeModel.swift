//
//  LikeModel.swift
//  DogRun
//
//  Created by 이재희 on 5/2/24.
//

import Foundation

struct LikeModel: Codable {
    let like_status: Bool
}

struct BasicQuery {
    let next: String?
    let limit: String?
    
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        if let next = next {
            items.append(URLQueryItem(name: "next", value: next))
        }
        if let limit = limit {
            items.append(URLQueryItem(name: "limit", value: limit))
        }
        return items
    }
}
