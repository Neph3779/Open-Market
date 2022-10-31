//
//  MarketPage.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/12.
//

import Foundation

struct MarketPage: Decodable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let pages: [MarketItem]

    private enum CodingKeys: String, CodingKey {
        case pageNo, itemsPerPage, totalCount, offset, limit, lastPage, hasNext, hasPrev, pages
    }
}
