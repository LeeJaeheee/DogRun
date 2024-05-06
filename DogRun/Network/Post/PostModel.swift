//
//  PostModel.swift
//  DogRun
//
//  Created by 이재희 on 4/22/24.
//

import Foundation

// MARK: - UploadFiles

struct UploadFilesRequest: MultipartFormEncodable {
    let files: [Data]
}

struct UploadFilesResponse: Decodable {
    let files: [String]
}

// MARK: - Post

struct PostRequest: Encodable {
    let title: String?
    let content: String?
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let product_id: String?
    let files: [String]?
}

struct PostResponse: Decodable, Hashable {
    let post_id: String
    let product_id: String?
    let title: String?
    let content: String?
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let createdAt: String
    let creator: Creator
    let files: [String]?
    let likes: [String]
    let likes2: [String]
    let hashTags: [String]
    let comments: [Comment]
}
extension PostResponse {
    var createdAtDescription: String {
        return DateFormatterManager.shared.timeAgo(from: createdAt)
    }
    var hashTagsString: String {
        hashTags.hashtagsString()
    }
}

struct Creator: Decodable, Hashable {
    let user_id: String
    let nick: String
    let profileImage: String?
}

struct Comment: Decodable, Hashable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: Creator
}
extension Comment {
    var createdAtDescription: String {
        return DateFormatterManager.shared.timeAgo(from: createdAt)
    }
}

// MARK: - FetchPosts

struct PostQuery {
    let next: String?
    let limit: String?
    let product_id: String?
    let hashTag: String?
    
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        if let next = next {
            items.append(URLQueryItem(name: "next", value: next))
        }
        if let limit = limit {
            items.append(URLQueryItem(name: "limit", value: limit))
        }
        if let product_id = product_id {
            items.append(URLQueryItem(name: "product_id", value: product_id))
        }
        if let hashTag = hashTag {
            items.append(URLQueryItem(name: "hashTag", value: hashTag))
        }
        return items
    }
}

struct PostsResponse: Decodable {
    let data: [PostResponse]
    let next_cursor: String
}
