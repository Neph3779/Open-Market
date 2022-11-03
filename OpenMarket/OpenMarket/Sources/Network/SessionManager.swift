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
        do {
            let url = try RequestURLPath.healthCheck()
            let request = headerConfiguredRequest(method: .get, url: url)
            dataTask(request: request, completionHandler: completionHandler).resume()
        } catch let error as OpenMarketError {
            completionHandler(.failure(error))
        } catch {
            completionHandler(.failure(.unknownError))
        }
    }

    func getProductList(pageNumber: Int,
                        itemsPerPage: Int = 100,
                        completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        do {
            let url = try RequestURLPath.getProductList(pageNumber: pageNumber, itemsPerPage: itemsPerPage)
            let request = headerConfiguredRequest(method: .get, url: url)
            dataTask(request: request, completionHandler: completionHandler).resume()
        } catch let error as OpenMarketError {
            completionHandler(.failure(error))
        } catch {
            completionHandler(.failure(.unknownError))
        }
    }

    func getProductDetail(productId: Int,
                          completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        do {
            let url = try RequestURLPath.getProductDetail(productId: productId)
            let request = headerConfiguredRequest(method: .get, url: url)
            dataTask(request: request, completionHandler: completionHandler).resume()
        } catch let error as OpenMarketError {
            completionHandler(.failure(error))
        } catch {
            completionHandler(.failure(.unknownError))
        }
    }

    func postProduct(data: PostRequest,
                     completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        do {
            let url = try RequestURLPath.postProduct()
            var request = headerConfiguredRequest(method: .post, url: url)
            request.setValue(identifier, forHTTPHeaderField: "identifier")
            request = try requestWithBody(request: request, method: .post, data: data)
            dataTask(request: request, completionHandler: completionHandler).resume()
        } catch let error as OpenMarketError {
            completionHandler(.failure(error))
        } catch {
            completionHandler(.failure(.unknownError))
        }
    }

    func checkDeleteURI(productId: Int,
                        secret: String,
                        completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        do {
            let url = try RequestURLPath.checkDeleteURI(productId: productId)
            let deleteURIRequest = DeleteURIRequest(secret: secret)
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(identifier, forHTTPHeaderField: "identifier")
            request = try requestWithBody(request: request, method: .post, data: deleteURIRequest)

            dataTask(request: request, completionHandler: completionHandler).resume()
        } catch let error as OpenMarketError {
            completionHandler(.failure(error))
        } catch {
            completionHandler(.failure(.unknownError))
        }
    }

    func modifyProduct(productId: Int,
                       completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        do {
            let url = try RequestURLPath.modifyProduct(productId: productId)
            let request = headerConfiguredRequest(method: .patch, url: url)
            /* http body 구성 작업*/
            dataTask(request: request, completionHandler: completionHandler).resume()
        } catch let error as OpenMarketError {
            completionHandler(.failure(error))
        } catch {
            completionHandler(.failure(.unknownError))
        }
    }

    func deleteProduct(deleteURI: String,
                       completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        do {
            let url = try RequestURLPath.deleteProduct(deleteURI: deleteURI)
            var request = headerConfiguredRequest(method: .delete, url: url)
            request.httpMethod = HTTPMethod.delete.rawValue
            request.addValue(identifier, forHTTPHeaderField: "identifier")
            dataTask(request: request, completionHandler: completionHandler).resume()
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

    private func headerConfiguredRequest(method: HTTPMethod, url: URL) -> URLRequest {
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
