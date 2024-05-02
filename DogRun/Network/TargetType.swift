//
//  TargetType.swift
//  DogRun
//
//  Created by 이재희 on 4/20/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var header: HTTPHeaders { get }
    var parameters: String? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    var multipartBody: MultipartFormData? { get }
    
}

extension TargetType {
    
    func asURLRequest() throws -> URLRequest {

        let url = try baseURL.asURL()
        var urlComponents = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        
        guard let composedURL = urlComponents?.url else {
            throw DRError(statusCode: 0, errorMessage: "url 실패")
        }
        
        var urlRequest = URLRequest(url: composedURL)
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = header
        urlRequest.httpBody = parameters?.data(using: .utf8)
        urlRequest.httpBody = body
        
        return urlRequest
    }
    
}
