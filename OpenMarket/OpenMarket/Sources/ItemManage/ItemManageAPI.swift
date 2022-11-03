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

    func postItem(data: PostRequest, completionHandler: @escaping (Result<Void, OpenMarketError>) -> Void) {
        sessionManager.postProduct(data: data) { result in
            switch result {
            case .success:
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func patchItem(productId: Int, data: PatchingItem, completionHandler: @escaping (Result<Void, OpenMarketError>) -> Void) {
        sessionManager.modifyProduct(productId: productId, patchingItem: data) { result in
            switch result {
            case .success:
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
