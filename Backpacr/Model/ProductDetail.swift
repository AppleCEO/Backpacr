//
//  ProductDetail.swift
//  Backpacr
//
//  Created by joon-ho kil on 2019/12/14.
//  Copyright © 2019 joon-ho kil. All rights reserved.
//

import Foundation

struct ProductDetail: Codable {
    let statusCode: Int
    let body: [DetailBody]
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case body
    }
}

// MARK: - Body
struct DetailBody: Codable {
    let discountCost: Int?
    let cost, seller, bodyDescription: String
    let discountRate: Double?
    let id: Int
    let thumbnail720, thumbnailList320: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case discountCost = "discount_cost"
        case cost, seller
        case bodyDescription = "description"
        case discountRate = "discount_rate"
        case id
        case thumbnail720 = "thumbnail_720"
        case thumbnailList320 = "thumbnail_list_320"
        case title
    }
}
