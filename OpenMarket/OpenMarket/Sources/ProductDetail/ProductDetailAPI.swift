//
//  ProductDetailAPI.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/10/27.
//

import Foundation

final class ProductDetailAPI {
    private let sessionManager: SessionManagerProtocol

    init(sessionManager: SessionManagerProtocol = SessionManager.shared) {
        self.sessionManager = sessionManager
    }

    func getProductDetail(id: Int, completionHandler: @escaping (Result<DetailItem, OpenMarketError>) -> Void) {
        sessionManager.getProductDetail(productId: id) { result in
            switch result {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(DetailItem.self, from: data) else {
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
