//
//  Product.swift
//  Backpacr
//
//  Created by joon-ho kil on 2019/12/09.
//  Copyright © 2019 joon-ho kil. All rights reserved.
//

import Foundation

struct ProductList: Codable {
    let statusCode: Int
    let body: [Body]
}

// MARK: - Body
struct Body: Codable {
    let thumbnail520: String
    let id: Int
    let seller, title: String

    enum CodingKeys: String, CodingKey {
        case thumbnail520 = "thumbnail_520"
        case id, seller, title
    }
}
