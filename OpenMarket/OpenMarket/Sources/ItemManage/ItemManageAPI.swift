//
//  ItemManageAPI.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/10/26.
//

import Foundation

final class ItemManageAPI {
    private let sessionManager: SessionManagerProtocol

    init(sessionManager: SessionManagerProtocol = SessionManager.shared) {
        self.sessionManager = sessionManager
    }

    func postItem(data: PostRequest, completionHandler: @escaping (Result<MarketItem, OpenMarketError>) -> Void) {
        sessionManager.postProduct(data: data) { result in
            switch result {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(MarketItem.self, from: data) else {
                    completionHandler(.failure(.invalidData))
                    return
                }
                completionHandler(.success(decodedData))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
