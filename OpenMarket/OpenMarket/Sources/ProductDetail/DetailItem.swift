//
//  DetailItem.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/10/27.
//

import Foundation

struct DetailItem: Decodable {
    let id: Int
    let vendorId: Int
    let name: String
    let description: String
    let thumbnail: String
    let currency: String
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let images: [Image]
    let vendors: Vendor
    let stock: Int
    let createdAt: String
    let issuedAt: String

    private enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail, currency, price, stock, images, vendors
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }

    struct Image: Decodable {
        let id: Int
        let url: String
        let thumbnailURL: String
        let issuedAt: String
        private enum CodingKeys: String, CodingKey {
            case id, url
            case thumbnailURL = "thumbnail_url"
            case issuedAt = "issued_at"
        }
    }

    struct Vendor: Decodable {
        let id: Int
        let name: String
    }
}
