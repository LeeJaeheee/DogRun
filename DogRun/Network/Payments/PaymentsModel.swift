//
//  PaymentsModel.swift
//  DogRun
//
//  Created by 이재희 on 5/7/24.
//

import Foundation

struct PaymentsModel: Codable {
    let imp_uid: String
    let post_id: String
    let productName: String
    let price: Int
}

struct PaymentsResponse: Decodable {
    let data: [PaymentResponse]
}

struct PaymentResponse: Decodable {
    let payment_id: String
    let buyer_id: String
    let post_id: String
    let merchant_uid: String
    let productName: String
    let price: Int
    let paidAt: String
}
