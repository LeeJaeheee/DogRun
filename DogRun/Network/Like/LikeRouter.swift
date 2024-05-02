//
//  LikeRouter.swift
//  DogRun
//
//  Created by 이재희 on 5/2/24.
//

import Foundation
import Alamofire

enum LikeRouter {
    case like(postId: String, model: LikeModel)
    case fetchLike(query: BasicQuery)
    case like2(postId: String, model: LikeModel)
    case fetchLike2(query: BasicQuery)
}

extension LikeRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue + "/posts"
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .like, .like2:
                .post
        case .fetchLike, .fetchLike2:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .like(let postId, _):
            "\(postId)/like"
        case .fetchLike:
            "likes/me"
        case .like2(let postId, _):
            "\(postId)/like-2"
        case .fetchLike2:
            "likes-2/me"
        }
    }
    
    var header: Alamofire.HTTPHeaders {
        switch self {
        case .like, .like2:
            HeaderType.authWithContent(contentType: .json).headers
        case .fetchLike, .fetchLike2:
            HeaderType.auth.headers
        }
    }
    
    var parameters: String? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchLike(let query):
            query.queryItems
        case .fetchLike2(let query):
            query.queryItems
        default:
            nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        //encoder.keyEncodingStrategy = .convertToSnakeCase
        
        switch self {
        case .like(_, let model), .like2(_, let model):
            return try? encoder.encode(model)
        default:
            return nil
        }
    }
    
    var multipartBody: Alamofire.MultipartFormData? {
        nil
    }

    
    
}
