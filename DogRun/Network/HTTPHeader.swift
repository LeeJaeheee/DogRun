//
//  HTTPHeader.swift
//  DogRun
//
//  Created by 이재희 on 4/20/24.
//

import Foundation
import Alamofire

enum HeaderLiteral: String {
    case authorization = "Authorization"
    case sesacKey = "SesacKey"
    case refresh = "Refresh"
    case contentType = "Content-Type"
}

enum ContentType: String {
    case json = "application/json"
    case multipart = "multipart/form-data"
}

enum HeaderFieldType {
    case contentType(type: ContentType)
    case sesacKey
    case authorization
    case refresh
    
    var header: HTTPHeader {
        switch self {
        case .contentType(let type):
                .init(name: HeaderLiteral.contentType.rawValue, value: type.rawValue)
        case .sesacKey:
                .init(name: HeaderLiteral.sesacKey.rawValue, value: APIKey.sesacKey.rawValue)
        case .authorization:
                .init(name: HeaderLiteral.authorization.rawValue, value: UserDefaultsManager.accessToken)
        case .refresh:
                .init(name: HeaderLiteral.refresh.rawValue, value: UserDefaultsManager.refreshToken)
        }
    }
}

enum HeaderType {
    case onlyKey
    case onlyKeyWithContent(contentType: ContentType)
    case auth
    case authWithContent(contentType: ContentType)
    case refresh
    
    var headers: HTTPHeaders {
        switch self {
        case .onlyKey:
            createHeaders([])
        case .onlyKeyWithContent(let contentType):
            createHeaders([.contentType(type: contentType)])
        case .auth:
            createHeaders([.authorization])
        case .authWithContent(let contentType):
            createHeaders([.authorization, .contentType(type: contentType)])
        case .refresh:
            createHeaders([.authorization, .refresh])
        }
    }
    
    private func createHeaders(_ types: [HeaderFieldType]) -> HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(HeaderFieldType.sesacKey.header)
        
        types.forEach { type in
            headers.add(type.header)
        }
        return headers
    }
}
