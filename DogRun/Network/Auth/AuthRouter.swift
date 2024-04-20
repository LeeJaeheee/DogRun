//
//  AuthRouter.swift
//  DogRun
//
//  Created by 이재희 on 4/20/24.
//

import Foundation
import Alamofire

enum AuthRouter {
    case refresh
}

extension AuthRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue + "/auth"
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .refresh:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .refresh:
            "refresh"
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .refresh:
            HeaderType.refresh.headers
        }
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
    
    var multipartBody: MultipartFormData? {
        nil
    }
    
}
