//
//  SessionManager.swift
//  OpenMarket
//
//  Created by 천수현 on 2021/05/13.
//

import Foundation

class SessionManager: SessionManagerProtocol {
    static let shared = SessionManager(requestBodyEncoder: RequestBodyEncoder(),
                                       session: URLSession(configuration: .default))
    private let requestBodyEncoder: RequestBodyEncoderProtocol
    private let session: URLSession
    private let identifier = "262da16e-50e9-11ed-acb7-dfcdeb599683"

    init(requestBodyEncoder: RequestBodyEncoderProtocol, session: URLSession) {
        self.requestBodyEncoder = requestBodyEncoder
        self.session = session
    }

    func healthCheck(completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        let task = { [weak self] in
            guard let self = self else { return }
            
            let url = try RequestURLPath.healthCheck()
            let request = self.request(method: .get, url: url)

            self.dataTask(request: request, completionHandler: completionHandler).resume()
        }

        handleRequestTask(requestTask: task, completionHandler: completionHandler)
    }

    func getProductList(pageNumber: Int,
                        itemsPerPage: Int = 100,
                        completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        let task = { [weak self] in
            guard let self = self else { return }

            let url = try RequestURLPath.getProductList(pageNumber: pageNumber, itemsPerPage: itemsPerPage)
            let request = self.request(method: .get, url: url)

            self.dataTask(request: request, completionHandler: completionHandler).resume()
        }

        handleRequestTask(requestTask: task, completionHandler: completionHandler)
    }

    func getProductDetail(productId: Int,
                          completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        let task = { [weak self] in
            guard let self = self else { return }

            let url = try RequestURLPath.getProductDetail(productId: productId)
            let request = self.request(method: .get, url: url)

            self.dataTask(request: request, completionHandler: completionHandler).resume()
        }

        handleRequestTask(requestTask: task, completionHandler: completionHandler)
    }

    func postProduct(data: PostRequest,
                     completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        let task = { [weak self] in
            guard let self = self else { return }

            let url = try RequestURLPath.postProduct()
            var request = self.request(method: .post, url: url)
            request.setValue(self.identifier, forHTTPHeaderField: "identifier")
            request.setValue("multipart/form-data; boundary=\"\(RequestBodyEncoder.boundary)\"",
                             forHTTPHeaderField: "Content-Type")
            request = try self.requestWithBody(request: request, method: .post, data: data)

            self.dataTask(request: request, completionHandler: completionHandler).resume()
        }

        handleRequestTask(requestTask: task, completionHandler: completionHandler)
    }

    func checkDeleteURI(productId: Int,
                        secret: String,
                        completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        let task = { [weak self] in
            guard let self = self else { return }

            let url = try RequestURLPath.checkDeleteURI(productId: productId)
            let deleteURIRequest = DeleteURIRequest(secret: secret)
            var request = self.request(method: .post, url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(self.identifier, forHTTPHeaderField: "identifier")
            request = try self.requestWithBody(request: request, method: .post, data: deleteURIRequest)

            self.dataTask(request: request, completionHandler: completionHandler).resume()
        }

        handleRequestTask(requestTask: task, completionHandler: completionHandler)
    }

    func modifyProduct(productId: Int,
                       completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        let task = { [weak self] in
            guard let self = self else { return }
            let url = try RequestURLPath.modifyProduct(productId: productId)
            let request = self.request(method: .patch, url: url)
            /* http body 구성 작업*/
            self.dataTask(request: request, completionHandler: completionHandler).resume()
        }

        handleRequestTask(requestTask: task, completionHandler: completionHandler)
    }

    func deleteProduct(deleteURI: String,
                       completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        let task = { [weak self] in
            guard let self = self else { return }
            let url = try RequestURLPath.deleteProduct(deleteURI: deleteURI)
            var request = self.request(method: .delete, url: url)
            request.addValue(self.identifier, forHTTPHeaderField: "identifier")
            self.dataTask(request: request, completionHandler: completionHandler).resume()
        }

        handleRequestTask(requestTask: task, completionHandler: completionHandler)
    }

    private func handleRequestTask(requestTask: () throws -> Void,
                                   completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        do {
            try requestTask()
        } catch let error as OpenMarketError {
            completionHandler(.failure(error))
        } catch {
            completionHandler(.failure(.unknownError))
        }
    }

    func fetchImage(urlString: String?, completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            completionHandler(.failure(.invalidURL))
            return
        }

        dataTask(request: URLRequest(url: url), completionHandler: completionHandler).resume()
    }

    private func requestWithBody<APIModel: RequestData>(request: URLRequest,
                                                        method: HTTPMethod,
                                                        data: APIModel) throws -> URLRequest {
        // TODO: 이 부분 리팩토링 필요
        var request = request
        switch method {
        case .get:
            throw OpenMarketError.requestGETWithData
        case .post:
            if let postRequest = data as? PostRequest {
                request.httpBody = try requestBodyEncoder.encodePostRequest(postRequest: postRequest)
                break
            }
            if let deleteURIRequest = data as? DeleteURIRequest {
                request.httpBody = try requestBodyEncoder.encodeDeleteURIRequest(deleteURIRequest: deleteURIRequest)
                break
            }
            throw OpenMarketError.requestDataTypeNotMatch
        case .patch:
            if data is PatchingItem { break }
            throw OpenMarketError.requestDataTypeNotMatch
        case .delete:
            throw OpenMarketError.requestDataTypeNotMatch
        }

        return request
    }

    private func request(method: HTTPMethod, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }

    private func dataTask(request: URLRequest,
                          completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
            if error != nil {
                return completionHandler(.failure(.sessionError))
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                return completionHandler(.failure(.canNotConvertResponse))
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                return completionHandler(.failure(.wrongResponse(httpResponse.statusCode)))
            }

            guard let data = data,
                  data.count != 0 else {
                return completionHandler(.failure(.didNotReceivedData))
            }

            completionHandler(.success(data))
        }
    }
}
