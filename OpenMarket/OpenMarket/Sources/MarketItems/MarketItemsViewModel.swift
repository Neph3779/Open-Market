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

    var reloadData: (() -> Void)?
    var showErrorAlert: ((OpenMarketError) -> Void)?
    var insertItems: (([IndexPath]) -> Void)?
    var stopLoadingIndicator: (() -> Void)?

    func refreshPageData() {
        marketItemsAPI.getPage(id: 1) { [weak self] result in
            guard let self = self,
                  let reloadData = self.reloadData,
                  let showErrorAlert = self.showErrorAlert,
                  let stopLoadingIndicator = self.stopLoadingIndicator else { return }
            switch result {
            case .success(let page):
                DispatchQueue.main.async {
                    self.lastPageId = page.lastPage
                    self.hasNextPage = page.hasNext
                    self.marketItems = page.pages
                    stopLoadingIndicator()
                    reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    showErrorAlert(error)
                }
            }
        }
    }

    func fetchNextPageData() {
        marketItemsAPI.getPage(id: lastPageId + 1) { [weak self] result in
            guard let self = self,
                  let insertItems = self.insertItems,
                  let showErrorAlert = self.showErrorAlert else { return }

            switch result {
            case .success(let page):
                if page.pages.isEmpty { return }
                let rangeToInsert = self.marketItems.count ..< self.marketItems.count + page.pages.count
                self.marketItems.append(contentsOf: page.pages)
                self.lastPageId = page.pageNo
                self.hasNextPage = page.hasNext

                DispatchQueue.main.async {
                    insertItems(rangeToInsert.map { IndexPath(item: $0, section: 0) })
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    showErrorAlert(error)
                }
            }
        }
    }
}

extension MarketItemsViewModel {
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
