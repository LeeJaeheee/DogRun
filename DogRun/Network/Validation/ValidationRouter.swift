//
//  ValidationRouter.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import Foundation
import Alamofire

enum ValidationRouter {
    case email(model: EmailValidationRequest)
}

extension ValidationRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue + "/validation"
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .email:
                .post
        }
    }
    
    var path: String {
        switch self {
        case .email:
            "email"
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .email:
            HeaderType.onlyKeyWithContent(contentType: .json).headers
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
        case .email(let model):
            return try? encoder.encode(model)
        }
    }
    
    var multipartBody: MultipartFormData? {
        nil
    }
    
}
