//
//  RequestBodyEncoder.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/18.
//

import Foundation

struct RequestBodyEncoder: RequestBodyEncoderProtocol {
    static let boundary: String = "Boundary-\(UUID().uuidString)"
    /*
     ----------------------------451158422278730710610368
     Content-Disposition: form-data; name="images"; filename="logoFace.png"
     <logoFace.png>
     ----------------------------451158422278730710610368
     Content-Disposition: form-data; name="images"; filename="logoOriginal.png"
     <logoOriginal.png>
     ----------------------------451158422278730710610368
     Content-Disposition: form-data; name="params"
     { "name": "multiple Image test", "descriptions": "세기의 명작", "price": 1000000, "currency": "KRW", "discounted_price": 500000, "stock": 1234567, "secret": "n62jxcvawe1ji3p3" }
     ----------------------------451158422278730710610368--
     */

    func encodePostRequest(postRequest: PostRequest) throws -> Data {
        var requestData = Data()
        postRequest.images.forEach { postingImage in
            let data = convertFileField(key: "images", fileName: postingImage.fileName, data: postingImage.imageData)
            requestData.append(data)
        }

        if let data = try? JSONEncoder().encode(postRequest.parameters),
           let jsonData = String(data: data, encoding: .utf8) {
            requestData.append(jsonData)
        } else {
            throw OpenMarketError.bodyEncodingError
        }

        requestData.append(RequestBodyEncoder.boundary)

        return requestData
    }

    private func convertFileField(key: String, fileName: String, data: Data) -> Data {
        var dataField = Data()

        dataField.append("--\(Self.boundary)\r\n")
        dataField.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
        dataField.append(data)
        dataField.append("\r\n")

        return dataField
    }

    private func convertTextField(key: String, value: String) -> String {
        var textField: String = "--\(Self.boundary)\r\n"

        textField.append("Content-Disposition: form-data; name=\"\(key)\"\r\n")
        textField.append("\r\n")
        textField.append("\(value)\r\n")

        return textField
    }
}
