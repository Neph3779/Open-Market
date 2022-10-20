//
//  SessionManager.swift
//  OpenMarket
//
//  Created by 천수현 on 2021/05/13.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"

    var mimeType: String? {
        switch self {
        case .get:
            return nil
        case .post, .patch:
            return "multipart/form-data; boundary=\(RequestBodyEncoder.boundary)"
        case .delete:
            return "application/json"
        }
    }
}

enum RequestURLPath {
    static let host = "https://openmarket.yagom-academy.kr"

    static func healthCheck() throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.path = "/healthChecker"
        guard let url = urlComponents.url else { throw OpenMarketError.invalidURL }
        return url
    }

    static func getProductList(pageNumber: Int, itemsPerPage: Int = 100) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.path = "/api/products"
        urlComponents.queryItems = [
            .init(name: "page_no", value: String(pageNumber )),
            .init(name: "items_per_page", value: String(itemsPerPage))
        ]
        guard let url = urlComponents.url else { throw OpenMarketError.invalidURL }
        return url
    }

    static func getProductDetail(productId: Int) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.path = "/api/products/\(productId)"
        guard let url = urlComponents.url else { throw OpenMarketError.invalidURL }
        return url
    }
    static func postProduct() throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.path = "/api/products"
        guard let url = urlComponents.url else { throw OpenMarketError.invalidURL }
        return url
    }
    static func checkDeleteURI(productId: Int) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.path = "/api/products/\(productId)/archived"
        guard let url = urlComponents.url else { throw OpenMarketError.invalidURL }
        return url
    }
    static func modifyProduct(productId: Int) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.path = "/api/products/\(productId)"
        guard let url = urlComponents.url else { throw OpenMarketError.invalidURL }
        return url
    }
    static func deleteProduct(deleteURI: String) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.path = "/api/products/\(deleteURI)"
        guard let url = urlComponents.url else { throw OpenMarketError.invalidURL }
        return url
    }
}

class SessionManager: SessionManagerProtocol {
    static let shared = SessionManager(requestBodyEncoder: RequestBodyEncoder(), session: URLSession.shared)
    private let requestBodyEncoder: RequestBodyEncoderProtocol
    private let session: URLSession

    init(requestBodyEncoder: RequestBodyEncoderProtocol, session: URLSession) {
        self.requestBodyEncoder = requestBodyEncoder
        self.session = session
    }

    func healthCheck(completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        do {
            let url = try RequestURLPath.healthCheck()
            let request = try headerConfiguredRequest(method: .get, url: url)

            dataTask(request: request, completionHandler: completionHandler).resume()
        } catch {

        }
    }

    func getProductList(pageNumber: Int,
                        itemsPerPage: Int = 100,
                        completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        do {
            let url = try RequestURLPath.getProductList(pageNumber: pageNumber, itemsPerPage: itemsPerPage)
            let request = try headerConfiguredRequest(method: .get, url: url)

            dataTask(request: request, completionHandler: completionHandler).resume()
        } catch {

        }
    }

    func getProductDetail(productId: Int,
                          completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        do {
            let url = try RequestURLPath.getProductDetail(productId: productId)
            let request = try headerConfiguredRequest(method: .get, url: url)

            dataTask(request: request, completionHandler: completionHandler).resume()
        } catch {

        }
    }

    func postProduct(identifier: String,
                     completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        do {
            let url = try RequestURLPath.postProduct()
            let request = try headerConfiguredRequest(method: .post, url: url)
            /* http body 구성 작업*/

            dataTask(request: request, completionHandler: completionHandler).resume()
        } catch {

        }
    }

    func checkDeleteURI(productId: Int,
                        identifier: String,
                        completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        do {
            let url = try RequestURLPath.checkDeleteURI(productId: productId)
            let request = try headerConfiguredRequest(method: .post, url: url)
            /* http body 구성 작업*/

            dataTask(request: request, completionHandler: completionHandler).resume()
        } catch {

        }
    }

    func modifyProduct(productId: Int,
                       identifier: String,
                       completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        do {
            let url = try RequestURLPath.modifyProduct(productId: productId)
            let request = try headerConfiguredRequest(method: .patch, url: url)
            /* http body 구성 작업*/

            dataTask(request: request, completionHandler: completionHandler).resume()
        } catch {

        }
    }

    func deleteProduct(deleteURI: String,
                       identifier: String,
                       completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        do {
            let url = try RequestURLPath.deleteProduct(deleteURI: deleteURI)
            let request = try headerConfiguredRequest(method: .delete, url: url)
            /* http body 구성 작업*/

            dataTask(request: request, completionHandler: completionHandler).resume()
        } catch {

        }
    }

    func fetchImageDataTask(urlString: String?, completionHandler: @escaping (Data) -> Void) -> URLSessionDataTask? {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return nil }

        return dataTask(request: URLRequest(url: url)) { result in
            guard let data = try? result.get() else { return }
            return completionHandler(data)
        }
    }

    private func requestWithBody<APIModel: RequestData>(request: URLRequest,
                                                        method: HTTPMethod,
                                                        data: APIModel) throws -> URLRequest {
        var request = request
        switch method {
        case .get:
            throw OpenMarketError.requestGETWithData
        case .post:
            if data is PostingItem { break }
            throw OpenMarketError.requestDataTypeNotMatch
        case .patch:
            if data is PatchingItem { break }
            throw OpenMarketError.requestDataTypeNotMatch
        case .delete:
            if data is DeletingItem { break }
            throw OpenMarketError.requestDataTypeNotMatch
        }

        do {
            request.httpBody = try requestBodyEncoder.encode(data)
        } catch let error as OpenMarketError {
            throw error
        }

        return request
    }


    private func headerConfiguredRequest(method: HTTPMethod, url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue
        request.setValue(method.mimeType, forHTTPHeaderField: "Content-Type")

        return request
    }

    private func dataTask(request: URLRequest,
                          completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
            if error != nil {
                return completionHandler(.failure(.sessionError))
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                return completionHandler(.failure(.didNotReceivedResponse))
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                return completionHandler(.failure(.wrongResponse(httpResponse.statusCode)))
            }

            guard let data = data else {
                return completionHandler(.failure(.didNotReceivedData))
            }

            completionHandler(.success(data))
        }
    }
}
