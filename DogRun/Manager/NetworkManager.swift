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
    
    static func request2<T: Decodable>(type: T.Type, router: TargetType) -> Single<Result<T, DRError>> {
        return Single<Result<T, DRError>>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                
                print("--리퀘스트--")
                print(urlRequest)
                
                AF.request(urlRequest, interceptor: TokenRefreshInterceptor.shared)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let model):
                            dump(model)
                            single(.success(.success(model)))
                        case .failure(let error):
                            print("요청 실패: \(error.localizedDescription)")
                            let statusCode = response.response?.statusCode ?? 0
                            var errorMessage = "알 수 없는 오류가 발생했습니다."
                            
                            if let data = response.data {
                                if let decodedError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                                    errorMessage = decodedError.message
                                } else if let utf8Text = String(data: data, encoding: .utf8) {
                                    print("서버로부터의 에러 메시지: \(utf8Text)")
                                }
                            }
                            print("최종", errorMessage)
                            single(.success(.failure(.init(statusCode: statusCode, errorMessage: errorMessage))))
                        }
                    }
            } catch {
                single(.success(.failure(.init(statusCode: 0)))) //수정하기
            }
            
            return Disposables.create()
        }
    }
    
    static func requestVoid(router: TargetType) -> Single<Result<Void, DRError>> {
        return Single<Result<Void, DRError>>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                
                print("--리퀘스트--")
                print(urlRequest)
                
                AF.request(urlRequest, interceptor: TokenRefreshInterceptor.shared)
                    .validate(statusCode: 200..<300)
                    .response { response in
                        switch response.result {
                        case .success:
                            single(.success(.success(())))
                        case .failure(let error):
                            print("요청 실패: \(error.localizedDescription)")
                            let statusCode = response.response?.statusCode ?? 0
                            var errorMessage = "알 수 없는 오류가 발생했습니다."
                            
                            if let data = response.data {
                                if let decodedError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                                    errorMessage = decodedError.message
                                } else if let utf8Text = String(data: data, encoding: .utf8) {
                                    print("서버로부터의 에러 메시지: \(utf8Text)")
                                }
                            }
                            print("최종", errorMessage)
                            single(.success(.failure(.init(statusCode: statusCode, errorMessage: errorMessage))))
                        }
                    }
            } catch {
                single(.success(.failure(.init(statusCode: 0)))) // 수정하기
            }
            
            return Disposables.create()
        }
    }
    
    
    static func requestMultipart<T: Decodable>(type: T.Type, router: TargetType) -> Single<Result<T, DRError>> {
        return Single<Result<T, DRError>>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                
                AF.upload(multipartFormData: router.multipartBody!, with: urlRequest, interceptor: TokenRefreshInterceptor.shared)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let model):
                        dump(model)
                        single(.success(.success(model)))
                    case .failure(let error):
                        print("요청 실패: \(error.localizedDescription)")
                        let statusCode = response.response?.statusCode ?? 0
                        var errorMessage = "알 수 없는 오류가 발생했습니다."
                        
                        if let data = response.data {
                            if let decodedError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                                errorMessage = decodedError.message
                            } else if let utf8Text = String(data: data, encoding: .utf8) {
                                print("서버로부터의 에러 메시지: \(utf8Text)")
                            }
                        }
                        print("최종", errorMessage)
                        single(.success(.failure(.init(statusCode: statusCode, errorMessage: errorMessage))))
                    }
                }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func requestTokenRefresh<T: Decodable>(type: T.Type, router: TargetType) -> Single<Result<T, DRError>> {
        return Single<Result<T, DRError>>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let model):
                            dump(model)
                            single(.success(.success(model)))
                        case .failure(let error):
                            print("요청 실패: \(error.localizedDescription)")
                            let statusCode = response.response?.statusCode ?? 0
                            var errorMessage = "알 수 없는 오류가 발생했습니다."
                            
                            if let data = response.data {
                                if let decodedError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                                    errorMessage = decodedError.message
                                } else if let utf8Text = String(data: data, encoding: .utf8) {
                                    print("서버로부터의 에러 메시지: \(utf8Text)")
                                }
                            }
                            print("최종", errorMessage)
                            single(.success(.failure(.init(statusCode: statusCode, errorMessage: errorMessage))))
                        }
                    }
            } catch {
                single(.success(.failure(.init(statusCode: 0)))) //수정하기
            }
            
            return Disposables.create()
        }
    }
    
}
