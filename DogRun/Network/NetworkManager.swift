//
//  NetworkManager.swift
//  DogRun
//
//  Created by 이재희 on 4/20/24.
//

import Foundation
import RxSwift
import Alamofire

struct NetworkManager {
    
    static func request<T: Decodable>(type: T.Type, router: TargetType) -> Single<T> {
        return Single<T>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                
                AF.request(urlRequest, interceptor: TokenRefreshInterceptor.shared)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let model):
                            dump(model)
                            single(.success(model))
                        case .failure(let error):
                            print("요청 실패: \(error.localizedDescription)")
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                print("서버로부터의 에러 메시지: \(utf8Text)")
                            }
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func requestMultipart<T: Decodable>(type: T.Type, router: TargetType) -> Single<T> {
        return Single<T>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                
                AF.upload(multipartFormData: router.multipartBody!, with: urlRequest, interceptor: TokenRefreshInterceptor.shared)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let model):
                        dump(model)
                        single(.success(model))
                    case .failure(let error):
                        print("요청 실패: \(error.localizedDescription)")
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("서버로부터의 에러 메시지: \(utf8Text)")
                        }
                        single(.failure(error))
                    }
                }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
}
