//
//  MarketItemsViewModel.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/10/26.
//

import Foundation

final class MarketItemsViewModel {
    let marketItemsAPI = MarketItemsAPI()
    var marketItems: [MarketItem] = []
    var lastPageId: Int = 0
    var hasNextPage: Bool = false
    var layoutMode: LayoutMode = .list

    enum LayoutMode: Int {
        case list = 0
        case grid = 1

        var name: String {
            switch self {
            case .list:
                return "LIST"
            case .grid:
                return "GRID"
            }
        }

        mutating func changeMode(into layoutMode: LayoutMode) {
            self = layoutMode
        }
    }
}
