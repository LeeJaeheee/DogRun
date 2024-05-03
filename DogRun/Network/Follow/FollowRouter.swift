//
//  FollowRouter.swift
//  DogRun
//
//  Created by 이재희 on 5/3/24.
//

import Foundation
import Alamofire

enum FollowRouter {
    case follow(userId: String)
    case unfollow(userId: String)
}

extension FollowRouter: TargetType {
    var baseURL: String {
        APIKey.baseURL.rawValue + "/follow"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .follow:
                .post
        case .unfollow:
                .delete
        }
    }
    
    var path: String {
        switch self {
        case .follow(let userId):
            userId
        case .unfollow(let userId):
            userId
        }
    }
    
    var header: Alamofire.HTTPHeaders {
        HeaderType.auth.headers
    }
    
    var parameters: String? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var body: Data? {
        nil
    }
    
    var multipartBody: Alamofire.MultipartFormData? {
        nil
    }
    
    
}
