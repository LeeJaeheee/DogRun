//
//  PostRouter.swift
//  DogRun
//
//  Created by 이재희 on 4/22/24.
//

import Foundation
import Alamofire

enum PostRouter {
    case uploadFiles(model: UploadFilesRequest)
    case uploadPost(model: PostRequest)
    case fetchPost(query: PostQuery)
    case fetchPostByPostId(id: String)
    case fetchUserPost(id: String, query: PostQuery)
    case editPost(id: String, model: PostRequest)
    case deletePost(id: String)
    case searchHashTag(query: PostQuery)
}

extension PostRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue + "/posts"
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .uploadFiles, .uploadPost:
                .post
        case .fetchPost, .fetchPostByPostId, .fetchUserPost, .searchHashTag:
                .get
        case .editPost:
                .put
        case .deletePost:
                .delete
        }
    }
    
    var path: String {
        switch self {
        case .uploadFiles:
            "files"
        case .fetchPostByPostId(let id):
            "\(id)"
        case .fetchUserPost(let id, _):
            "users/\(id)"
        case .editPost(let id, _):
            "\(id)"
        case .deletePost(let id):
            "\(id)"
        case .searchHashTag:
            "hashtags"
        default:
            ""
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .uploadFiles:
            HeaderType.authWithContent(contentType: .multipart).headers
        case .uploadPost, .editPost:
            HeaderType.authWithContent(contentType: .json).headers
        case .fetchPost, .fetchPostByPostId, .fetchUserPost, .deletePost, .searchHashTag:
            HeaderType.auth.headers
        }
    }
    
    var parameters: String? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchPost(let query):
            query.queryItems
        case .fetchUserPost(_, let query):
            query.queryItems
        case .searchHashTag(let query):
            query.queryItems
        default:
            nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        //encoder.keyEncodingStrategy = .convertToSnakeCase
        
        switch self {
        case .uploadPost(let model):
            return try? encoder.encode(model)
        case .editPost(_, let model):
            return try? encoder.encode(model)
        default:
            return nil
        }
    }
    
    var multipartBody: MultipartFormData? {
        let multipartFormData = MultipartFormData()
        switch self {
        case .uploadFiles(let model):
            model.encode(to: multipartFormData)
            return multipartFormData
        default:
            return nil
        }
    }
    
}
