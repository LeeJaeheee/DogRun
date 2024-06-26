//
//  TokenRefreshInterceptor.swift
//  DogRun
//
//  Created by 이재희 on 4/20/24.
//

import Foundation
import Alamofire
import RxSwift

final class TokenRefreshInterceptor: RequestInterceptor {
    
    private var isTokenRefreshed = false

    static let shared = TokenRefreshInterceptor()
    
    let disposeBag = DisposeBag()

    private init() {}

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        // accessToken 필요없는 경우 바로 success
        guard let authorization = urlRequest.value(forHTTPHeaderField: HeaderLiteral.authorization.rawValue) else {
            print("authorization 헤더 필요 없음")
            completion(.success(urlRequest))
            return
        }
        
        print("adapt 진입")

        print(urlRequest.headers)
        
        if isTokenRefreshed {
            print("재발급된 토큰으로 URLRequset 변경")
            var modifiedRequest = urlRequest
            modifiedRequest.setValue(UserDefaultsManager.accessToken, forHTTPHeaderField: HeaderLiteral.authorization.rawValue)

            isTokenRefreshed = false
            completion(.success(modifiedRequest))
        } else {
            print("재발급 안됨?")
            completion(.success(urlRequest))
        }
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        guard let response = request.response, response.statusCode == 419 else {
            completion(.doNotRetryWithError(error))
            return
        }

        print("retry 코드:", response.statusCode)
        // 토큰 갱신 API 호출
        NetworkManager.requestTokenRefresh(type: AuthResponse.self, router: AuthRouter.refresh)
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let success):
                    UserDefaultsManager.accessToken = success.accessToken
                    owner.isTokenRefreshed = true
                    completion(.retryWithDelay(0.5))
                    return
                case .failure(_):
                    print("에러에러", error)
                    completion(.doNotRetry)
                }
            }
            .disposed(by: disposeBag)
    }
}
