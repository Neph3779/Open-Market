//
//  SessionManagerProtocol.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/25.
//

import Foundation

protocol SessionManagerProtocol {
    func healthCheck(completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void)

    func getProductList(pageNumber: Int,
                        itemsPerPage: Int,
                        completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void)
    func getProductDetail(productId: Int,
                          completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void)
    func postProduct(data: PostRequest,
                     completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void)
    func checkDeleteURI(productId: Int,
                        secret: String,
                        completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void)
    func modifyProduct(productId: Int,
                       completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void)
    func deleteProduct(deleteURI: String,
                       completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void)
    func fetchImage(urlString: String?, completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void)
}
