//
//  MarketItemsAPITests.swift
//  OpenMarketTests
//
//  Created by 천수현 on 2022/10/27.
//

import XCTest
@testable import OpenMarket

final class SessionManagerCommonPartsTest: XCTestCase {
    var sut: SessionManager!
    var requestBodyEncoder: RequestBodyEncoder!
    var mockURLSession: URLSession!

    override func setUpWithError() throws {
        requestBodyEncoder = RequestBodyEncoder()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        mockURLSession = URLSession(configuration: configuration)
        sut = SessionManager(requestBodyEncoder: requestBodyEncoder, session: mockURLSession)
    }

    override func tearDownWithError() throws {
        mockURLSession = nil
        sut = nil
        requestBodyEncoder = nil
    }

    func test_dataTask에서_에러가_nil이_아닐때_sessionError_에러를_전달하는지() {
        let expectation = expectation(description: "It throws sessionError")

        MockURLProtocol.requestHandler = { urlRequest in
            return (HTTPURLResponse(), Data(), OpenMarketError.unknownError)
        }

        sut.healthCheck { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, OpenMarketError.sessionError)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10)
    }

    func test_dataTask에서_response를_HTTPURLResponse로_변환할_수_없을때_canNotConvertResponse_에러를_전달하는지() {
        let expectation = expectation(description: "It throws canNotConvertResponse")

        MockURLProtocol.requestHandler = { urlRequest in
            return (URLResponse(), Data(), nil)
        }

        sut.healthCheck { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, OpenMarketError.canNotConvertResponse)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10)
    }

    func test_dataTask에서_statusCode가_200번대가_아닐시_wrongResponse_에러를_전달하는지() {
        let expectation = expectation(description: "It throws wrongResponse")
        let statusCode = 400

        MockURLProtocol.requestHandler = { urlRequest in
            let response = HTTPURLResponse(url: URL(string: "https://naver.com")!,
                                           statusCode: statusCode, httpVersion: nil, headerFields: nil)
            return (response, Data(), nil)
        }

        sut.healthCheck { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, OpenMarketError.wrongResponse(statusCode))
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10)
    }

    func test_dataTask에서_data가_nil일시_didNotReceivedData_에러를_전달하는지() {
        let expectation = expectation(description: "It throws didNotReceivedData")

        MockURLProtocol.requestHandler = { urlRequest in
            return (HTTPURLResponse(), nil, nil)
        }

        sut.healthCheck { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, OpenMarketError.didNotReceivedData)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10)
    }
}
