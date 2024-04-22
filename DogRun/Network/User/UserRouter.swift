//
//  UserRouter.swift
//  DogRun
//
//  Created by 이재희 on 4/22/24.
//

import Foundation
import Alamofire

enum UserRouter {
    case join(model: JoinRequest)
    case login(model: LoginRequest)
    case withdraw
    case getMyProfile
    case editMyProfile(model: EditProfileRequest)
    case userProfile(id: String)
}

extension UserRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue + "/users"
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .login, .join:
                .post
        case .withdraw, .getMyProfile, .userProfile:
                .get
        case .editMyProfile:
                .put
        }
    }
    
    var path: String {
        switch self {
        case .join:
            "join"
        case .login:
            "login"
        case .withdraw:
            "withdraw"
        case .getMyProfile, .editMyProfile:
            "me/profile"
        case .userProfile(let id):
            "\(id)/profile"
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .join, .login:
            return HeaderType.onlyKeyWithContent(contentType: .json).headers
        case .withdraw, .getMyProfile, .userProfile:
            return HeaderType.auth.headers
        case .editMyProfile:
            return HeaderType.authWithContent(contentType: .multipart).headers
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
        case .login(let model):
            print(model)
            return try? encoder.encode(model)
        case .join(let model):
            return try? encoder.encode(model)
        default:
            return nil
        }
    }
    
    var multipartBody: MultipartFormData? {
        let multipartFormData = MultipartFormData()
        switch self {
        case .editMyProfile(let model):
            model.encode(to: multipartFormData)
            return multipartFormData
        default:
            return nil
        }
    }
    
}
