//
//  UIImageView+Ext.swift
//  DogRun
//
//  Created by 이재희 on 5/4/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setkfImage(urlString: String, placeholder: UIImage? = nil) {
        
        let modifier = AnyModifier { request in
            var req = request
            req.addValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HeaderLiteral.sesacKey.rawValue)
            req.addValue(UserDefaultsManager.accessToken, forHTTPHeaderField: HeaderLiteral.authorization.rawValue)
            return req
        }
        
        var options: KingfisherOptionsInfo = [.requestModifier(modifier)]

        self.kf.setImage(with: URL(string: APIKey.baseURL.rawValue + "/" + urlString), placeholder: placeholder, options: options) { result in
            switch result {
            case .success(let value):
                print("이미지 로드 성공: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("이미지 로드 실패: \(error.localizedDescription)")
            }
        }
    }
    
}
