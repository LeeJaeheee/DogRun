//
//  DRError.swift
//  DogRun
//
//  Created by 이재희 on 4/29/24.
//

import Foundation

// TODO: 네트워크 연결 문제 대응
enum DRError: Error {
    
    // 공통 응답코드
    case sesacKey(message: String)
    case overCall(message: String)
    case url(message: String)
    case unknown(message: String)
    
    case missingRequired(message: String)
    case inValidToken(message: String)
    case forbidden(message: String)
    case alreadyExist(message: String)
    case serverError(message: String)
    case refreshTokenExpired(message: String)
    case accessTokenExpired(message: String)
    case unauthorized(message: String)
    
    init(statusCode: Int, errorMessage: String = "알 수 없는 에러가 발생했습니다.") {
        switch statusCode {
        case 420:
            self = .sesacKey(message: errorMessage)
        case 429:
            self = .overCall(message: errorMessage)
        case 444:
            self = .url(message: errorMessage)
        case 500:
            self = .unknown(message: errorMessage)
        case 400:
            self = .missingRequired(message: errorMessage)
        case 401:
            self = .inValidToken(message: errorMessage)
        case 403:
            self = .forbidden(message: errorMessage)
        case 409:
            self = .alreadyExist(message: errorMessage)
        case 410:
            self = .serverError(message: errorMessage)
        case 418:
            self = .refreshTokenExpired(message: errorMessage)
        case 419:
            self = .accessTokenExpired(message: errorMessage)
        case 445:
            self = .unauthorized(message: errorMessage)
        default:
            self = .unknown(message: errorMessage)
        }
    }
    
    var errorMessage: String {
        switch self {
        case .sesacKey(let message), .overCall(let message), .url(let message), .unknown(let message),
                .missingRequired(let message), .inValidToken(let message), .forbidden(let message), .alreadyExist(let message),
                .serverError(let message), .refreshTokenExpired(let message), .accessTokenExpired(let message), .unauthorized(let message):
            return message
        }
    }
    
    var isCommon: Bool {
        switch self {
        case .sesacKey, .overCall, .url, .unknown:
            true
        default:
            false
        }
    }
    
    enum HandlingRule {
        case showToast
        case showLogin
        case developerFaultSorry
    }
    
    var handlingRule: HandlingRule {
        switch self {
        case .sesacKey, .overCall, .url, .unknown:
                .developerFaultSorry
        case .missingRequired, .alreadyExist, .serverError, .unauthorized, .forbidden: // forbidden은 뭐지..?
                .showToast
        case .inValidToken, .refreshTokenExpired, .accessTokenExpired: // TODO: 인터셉터 실패하면 419와서..다시 체크하기!
                .showLogin
        }
    }

}
