//
//  ProductDetailAPI.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/10/27.
//

import UIKit

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

    func getProductImage(url: String, completionHandler: @escaping (Result<UIImage, OpenMarketError>) -> Void) {
        sessionManager.fetchImage(urlString: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completionHandler(.failure(.canNotConvertDataToImage))
                    return
                }
                completionHandler(.success(image))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func deleteProduct(productId: Int, secret: String, completionHandler: @escaping (Result<Void, OpenMarketError>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var deleteUri = ""

        dispatchGroup.enter()
        askDeleteURI(productId: productId, secret: secret) { result in
            switch result {
            case .success(let uri):
                deleteUri = uri
                dispatchGroup.leave()
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.global()) {
            self.sessionManager.deleteProduct(deleteURI: deleteUri) { result in
                switch result {
                case .success:
                    completionHandler(.success(()))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }

    private func askDeleteURI(productId: Int, secret: String, completionHandler: @escaping (Result<String, OpenMarketError>) -> Void) {
        sessionManager.checkDeleteURI(productId: productId, secret: secret) { result in
            switch result {
            case .success(let data):
                if let uri = String(data: data, encoding: .utf8)?.split(separator: "/").last {
                    print(uri)
                    completionHandler(.success(String(uri)))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
