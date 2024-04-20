//
//  MultipartEncoder.swift
//  DogRun
//
//  Created by 이재희 on 4/20/24.
//

import Foundation
import Alamofire

protocol MultipartFormEncodable {
    func encode(to formData: MultipartFormData, name: String)
}

extension MultipartFormEncodable {
    func encode(to formData: MultipartFormData, name: String = "") {
        print(#function)
        let mirror = Mirror(reflecting: self)

        for case let (label?, value) in mirror.children {
            if let encodableValue = value as? MultipartFormEncodable {
                encodableValue.encode(to: formData, name: label)
            }
            if let encodableValue = value as? [MultipartFormEncodable] {
                for (index, element) in encodableValue.enumerated() {
                    element.encode(to: formData, name: label)
                }
            }
        }
    }
}

extension String: MultipartFormEncodable {
    func encode(to formData: MultipartFormData, name: String) {
        if let data = self.data(using: .utf8) {
            formData.append(data, withName: name)
        }
    }
}

extension Data: MultipartFormEncodable {
    func encode(to formData: MultipartFormData, name: String) {
        formData.append(self, withName: name, fileName: "\(name).png", mimeType: "image/png")
    }
}
