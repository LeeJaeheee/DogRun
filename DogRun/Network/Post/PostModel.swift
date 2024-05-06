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

// “dr_banner”
struct BannerResponse: Decodable, Hashable {
    let post_id: String
    let product_id: String
    let title: String
    let content: String
}

// “dr_challenge”
struct ChallengeResponse: Decodable, Hashable {
    let post_id: String
    let product_id: String
    let title: String
    let content: String
    let region: String
    let price: String
    let createdAt: String
    let creator: Creator
    let files: [String]
    let likes2: [String]
    let hashTags: [String]
    let buyers: [String]
    
    enum CodingKeys: String, CodingKey {
        case post_id
        case product_id
        case title
        case content
        case region = "content1"
        case price = "content2"
        case createdAt
        case creator
        case files
        case likes2
        case hashTags
        case buyers
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.post_id = try container.decode(String.self, forKey: .post_id)
        self.product_id = try container.decode(String.self, forKey: .product_id)
        self.title = try container.decode(String.self, forKey: .title)
        self.content = try container.decode(String.self, forKey: .content)
        self.region = try container.decode(String.self, forKey: .region)
        self.price = try container.decode(String.self, forKey: .price)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.creator = try container.decode(Creator.self, forKey: .creator)
        self.files = try container.decodeIfPresent([String].self, forKey: .files) ?? []
        self.likes2 = try container.decode([String].self, forKey: .likes2)
        self.hashTags = try container.decode([String].self, forKey: .hashTags)
        self.buyers = try container.decode([String].self, forKey: .buyers)
    }
}
extension ChallengeResponse {
    var isLiked: Bool {
        likes2.contains(UserDefaultsManager.userId)
    }
    var isBought: Bool {
        get { buyers.contains(UserDefaultsManager.userId) }
        set { self.isBought = newValue }
    }
    var imageStrings: [String] {
        files.map { APIKey.baseURL.rawValue+"/"+$0 }
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

struct BannersResponse: Decodable {
    let data: [BannerResponse]
    let next_cursor: String
}

struct ChallengesResponse: Decodable {
    let data: [ChallengeResponse]
    let next_cursor: String
}
