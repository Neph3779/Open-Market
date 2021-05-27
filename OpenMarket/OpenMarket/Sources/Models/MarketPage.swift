//
//  MarketPage.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/12.
//

import Foundation

struct MarketPage: Decodable {
    let id: Int
    let items: [MarketPage.Item]

    struct Item: Decodable {
        let id: Int
        let title: String
        let price: Int
        let currency: String
        let stock: Int
        let discountedPrice: Int?
        let thumbnails: [String]
        let registrationDate: TimeInterval

        private enum CodingKeys: String, CodingKey {
            case id, title, price, currency, stock, thumbnails
            case discountedPrice = "discounted_price"
            case registrationDate = "registration_date"
        }
    }

    private enum CodingKeys: String, CodingKey {
        case items
        case id = "page"
    }
}
