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
    func postProduct(identifier: String,
                     completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void)
    func checkDeleteURI(productId: Int,
                        identifier: String,
                        completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void)
    func modifyProduct(productId: Int,
                       identifier: String,
                       completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void)
    func deleteProduct(deleteURI: String,
                       identifier: String,
                       completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void)
    func fetchImageDataTask(urlString: String?, completionHandler: @escaping (Data) -> Void) -> URLSessionDataTask?
}
