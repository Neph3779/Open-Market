//
//  PostingItem.swift
//  OpenMarket
//
//  Created by Neph on 2021/05/12.
//

import Foundation

struct PostRequest: RequestData {
    let parameters: Parameter
    let images: [PostingImage]

    struct Parameter: Encodable {
        let name: String
        let descriptions: String
        let price: Int
        let currency: String
        let stock: Int
        let discountedPrice: Int?
        let secret: String

        enum CodingKeys: String, CodingKey {
            case name
            case descriptions
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
