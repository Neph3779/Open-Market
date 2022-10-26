//
//  OpenMarketService.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/25.
//

import Foundation

class OpenMarketService {
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

    func getItem(id: Int, completionHandler: @escaping (Result<MarketItem, OpenMarketError>) -> Void) {
        sessionManager.getProductDetail(productId: id) { result in
            switch result {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(MarketItem.self, from: data) else {
                    return completionHandler(.failure(.invalidData))
                }
                completionHandler(.success(decodedData))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func postItem(data: PostRequest, completionHandler: @escaping (Result<MarketItem, OpenMarketError>) -> Void) {
        sessionManager.postProduct(data: data) { result in
            switch result {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(MarketItem.self, from: data) else {
                    return completionHandler(.failure(.invalidData))
                }
                completionHandler(.success(decodedData))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func patchItem(id: Int, data: PatchingItem, completionHandler: @escaping (Result<MarketItem, OpenMarketError>) -> Void) {
        sessionManager.modifyProduct(productId: id) { result in
            switch result {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(MarketItem.self, from: data) else {
                    return completionHandler(.failure(.invalidData))
                }
                completionHandler(.success(decodedData))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func deleteItem(deleteURI: String, completionHandler: @escaping (Result<MarketItem, OpenMarketError>) -> Void) {
        sessionManager.deleteProduct(deleteURI: deleteURI) { result in
            switch result {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(MarketItem.self, from: data) else {
                    return completionHandler(.failure(.invalidData))
                }
                completionHandler(.success(decodedData))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
