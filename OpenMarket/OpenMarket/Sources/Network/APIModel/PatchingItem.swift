//
//  PatchingItem.swift
//  OpenMarket
//
//  Created by Neph on 2021/05/12.
//

import Foundation

struct PatchingItem: Encodable {
    let name: String?
    let description: String?
    let thumbnailId: Int?
    let price: Double?
    let currency: String?
    let discountedPrice: Double?
    let stock: Int?
    let secret: String

    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case thumbnailId = "thumbnail_id"
        case price
        case currency
        case discountedPrice = "discounted_price"
        case stock
        case secret
    }
}
