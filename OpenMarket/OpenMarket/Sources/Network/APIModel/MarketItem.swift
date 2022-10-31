//
//  MarketItem.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/12.
//

import Foundation

struct MarketItem: Codable {
    let id: Int
    let vendorId: Int
    let vendorName: String
    let name: String
    let description: String
    let thumbnail: String
    let currency: String
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String

    private enum CodingKeys: String, CodingKey {
        case id, vendorName, name, description, thumbnail, currency, price, stock
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
