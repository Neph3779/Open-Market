//
//  PostingItem.swift
//  OpenMarket
//
//  Created by Neph on 2021/05/12.
//

import Foundation

struct PostRequest: RequestData {
    let parameter: Parameter
    let images: [PostingImage]

    struct Parameter: Encodable {
        let name: String
        let description: String
        let price: Double
        let currency: String
        let stock: Int
        let discountedPrice: Double
        let secret: String

        enum CodingKeys: String, CodingKey {
            case name
            case description
            case price
            case currency
            case stock
            case discountedPrice = "discounted_price"
            case secret
        }
    }

    struct PostingImage {
        let fileName: String
        let imageData: Data
    }
}
