//
//  MarketItemsAPI.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/10/26.
//

import Foundation

final class MarketItemsAPI {
    private let sessionManager: SessionManagerProtocol

    init(sessionManager: SessionManagerProtocol = SessionManager.shared) {
        self.sessionManager = sessionManager
    }

    func getPage(id: Int, itemsPerPage: Int = 100, completionHandler: @escaping (Result<MarketPage, OpenMarketError>) -> Void) {
        sessionManager.getProductList(pageNumber: id, itemsPerPage: itemsPerPage) { result in
            switch result {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(MarketPage.self, from: data) else {
                    return completionHandler(.failure(.invalidData))
                }
                completionHandler(.success(decodedData))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
