//
//  PatchingItem.swift
//  OpenMarket
//
//  Created by Neph on 2021/05/12.
//

import Foundation

struct PatchingItem: Encodable {
    let identifier: String
    let productId: Int
    let name: String?
    let descriptions: String?
    let thumbnailId: Int?
    let price: Double?
    let currency: String?
    let discountedPrice: Double?
    let stock: Int?
    let secret: String

    private enum CodingKeys: String, CodingKey {
        case identifier
        case productId = "product_id"
        case name
        case descriptions
        case thumbnailId = "thumbnail_id"
        case price
        case currency
        case discountedPrice = "discounted_price"
        case stock
        case secret
    }
}
