//
//  CommentRouter.swift
//  DogRun
//
//  Created by 이재희 on 5/2/24.
//

import Foundation
import Alamofire

enum CommentRouter {
    case uploadComment(postId: String, model: CommentRequest)
    case editComment(postId: String, commentId: String, model: CommentRequest)
    case deleteComment(postId: String, commentId: String)
}

extension CommentRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue + "/posts"
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .uploadComment:
                .post
        case .editComment:
                .put
        case .deleteComment:
                .delete
        }
    }
    
    var path: String {
        switch self {
        case .uploadComment(let postId, _):
            "\(postId)/comments"
        case .editComment(let postId, let commentId, _):
            "\(postId)/comments/\(commentId)"
        case .deleteComment(let postId, let commentId):
            "\(postId)/comments/\(commentId)"
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .uploadComment, .editComment:
            HeaderType.authWithContent(contentType: .json).headers
        case .deleteComment:
            HeaderType.auth.headers
        }
    }
    
    var parameters: String? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        //encoder.keyEncodingStrategy = .convertToSnakeCase
        
        switch self {
        case .uploadComment(_, let model):
            return try? encoder.encode(model)
        case .editComment(_, _, let model):
            return try? encoder.encode(model)
        default:
            return nil
        }
    }
    
    var multipartBody: MultipartFormData? {
        nil
    }
    
}
