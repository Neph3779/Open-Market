//
//  APIModelTests.swift
//  OpenMarketTests
//
//  Created by duckbok on 2021/05/13.
//

import XCTest
@testable import OpenMarket

class RequestBodyEncoderTests: XCTestCase {
    var sut: RequestBodyEncoder!
    var dummyPostRequest = PostRequest(parameter: .init(name: "name",
                                                    description: "description",
                                                    price: 100.0,
                                                    currency: "KRW",
                                                    stock: 10,
                                                    discountedPrice: 10.0,
                                                    secret: "secret"),
                                       images: [.init(fileName: "imageName",
                                                      imageData: "image data".data(using: .utf8)!)])


    override func setUpWithError() throws {
        sut = RequestBodyEncoder()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_postingItem을_multipart_form_data로_변환할_수_있다() {
        // given
        let postingItem = dummyPostRequest

        var data = Data()
        do {
            // when
            data = try sut.encodePostRequest(postRequest: postingItem)
            let result = String(decoding: data, as: UTF8.self)

            // then
            let expectedResult = "\r\n--\(RequestBodyEncoder.boundary)\r\nContent-Disposition: form-data; name=\"params\"\r\n\r\n{\"secret\":\"secret\",\"discounted_price\":10,\"price\":100,\"stock\":10,\"description\":\"description\",\"currency\":\"KRW\",\"name\":\"name\"}\r\n\r\n--\(RequestBodyEncoder.boundary)\r\nContent-Disposition: form-data; name=\"images\"; filename=\"imageName.png\"\r\nContent-Type: image/png\r\n\r\nimage data\r\n--\(RequestBodyEncoder.boundary)--\r\n"
            XCTAssertEqual(result, expectedResult)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
}
