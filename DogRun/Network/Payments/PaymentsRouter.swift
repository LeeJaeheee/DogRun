//
//  PaymentsRouter.swift
//  DogRun
//
//  Created by 이재희 on 5/7/24.
//

import Foundation
import Alamofire

enum PaymentsRouter {
    case validation(model: PaymentsModel)
    case myPayments
}

extension PaymentsRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue + "/payments"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .validation:
                .post
        case .myPayments:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .validation:
            "validation"
        case .myPayments:
            "me"
        }
    }
    
    var header: Alamofire.HTTPHeaders {
        switch self {
        case .validation:
            HeaderType.authWithContent(contentType: .json).headers
        case .myPayments:
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
        
        switch self {
        case .validation(let model):
            return try? encoder.encode(model)
        case .myPayments:
            return nil
        }
    }
    
    var multipartBody: Alamofire.MultipartFormData? {
        nil
    }
    
}
