//
//  RequestURLPath.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/10/21.
//

import Foundation

enum RequestURLPath {
    static var urlComponents: URLComponents = {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "openmarket.yagom-academy.kr"
        return urlComponents
    }()

    static func healthCheck() throws -> URL {
        var urlComponents = urlComponents
        urlComponents.path = "/healthChecker"
        guard let url = urlComponents.url else { throw OpenMarketError.invalidURL }
        return url
    }
    static func getProductList(pageNumber: Int, itemsPerPage: Int = 100) throws -> URL {
        var urlComponents = urlComponents
        urlComponents.path = "/api/products"
        urlComponents.queryItems = [
            .init(name: "page_no", value: String(pageNumber)),
            .init(name: "items_per_page", value: String(itemsPerPage))
        ]
        guard let url = urlComponents.url else { throw OpenMarketError.invalidURL }
        return url
    }
    static func getProductDetail(productId: Int) throws -> URL {
        var urlComponents = urlComponents
        urlComponents.path = "/api/products/\(productId)"
        guard let url = urlComponents.url else { throw OpenMarketError.invalidURL }
        return url
    }
    static func postProduct() throws -> URL {
        var urlComponents = urlComponents
        urlComponents.path = "/api/products"
        guard let url = urlComponents.url else { throw OpenMarketError.invalidURL }
        return url
    }
    static func checkDeleteURI(productId: Int) throws -> URL {
        var urlComponents = urlComponents
        urlComponents.path = "/api/products/\(productId)/archived"
        guard let url = urlComponents.url else { throw OpenMarketError.invalidURL }
        return url
    }
    static func modifyProduct(productId: Int) throws -> URL {
        var urlComponents = urlComponents
        urlComponents.path = "/api/products/\(productId)"
        guard let url = urlComponents.url else { throw OpenMarketError.invalidURL }
        return url
    }
    static func deleteProduct(deleteURI: String) throws -> URL {
        var urlComponents = urlComponents
        urlComponents.path = "/api/products/\(deleteURI)"
        guard let url = urlComponents.url else { throw OpenMarketError.invalidURL }
        return url
    }
}
