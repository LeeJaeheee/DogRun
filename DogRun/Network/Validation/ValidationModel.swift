//
//  ValidationModel.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import Foundation

struct EmailValidationRequest: Encodable {
    let email: String
}

struct EmailValidationResponse: Decodable {
    let message: String
}
