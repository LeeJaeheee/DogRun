//
//  UserModel.swift
//  DogRun
//
//  Created by 이재희 on 4/22/24.
//

import Foundation

// MARK: - Join

struct JoinRequest: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String
    let birthDay: String
}

struct JoinResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
}

// MARK: - Login

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
}

// MARK: - Withdraw

// JoinResponse랑 같음
struct WithdrawResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
}

// MARK: - Profile

struct ProfileResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    let profileImage: String?
    let followers: [String]
    let following: [String]
    let posts: [String]
}

// MARK: - EditProfile

struct EditProfileRequest: MultipartFormEncodable {
    let nick: String?
    let phoneNum: String?
    let birthDay: String?
    let profile: Data?
}
