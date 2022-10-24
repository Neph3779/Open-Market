//
//  RequestBodyEncoder.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/18.
//

import Foundation
import UIKit

struct RequestBodyEncoder: RequestBodyEncoderProtocol {
    static let boundary: String = "boundary-\(UUID().uuidString)"

    func encodePostRequest(postRequest: PostRequest) throws -> Data {
        var requestData = Data()

        requestData.append("\r\n")

        if let data = try? JSONEncoder().encode(postRequest.parameter),
           let jsonDataString = String(data: data, encoding: .utf8) {
            requestData.append(convertTextField(key: "params", value: jsonDataString))
        } else {
            throw OpenMarketError.bodyEncodingError
        }

        postRequest.images.forEach { postingImage in
            let data = convertFileField(key: "images", fileName: postingImage.fileName, data: postingImage.imageData)
            requestData.append(data)
        }

        requestData.append("--\(Self.boundary)--\r\n")
        return requestData
    }

    private func convertFileField(key: String, fileName: String, data: Data) -> Data {
        var dataField = Data()
        dataField.append("--\(Self.boundary)\r\n")
        dataField.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName).png\"\r\n")
        dataField.append("Content-Type: image/png\r\n\r\n")
        dataField.append(data)
        dataField.append("\r\n")
        return dataField
    }

    private func convertTextField(key: String, value: String) -> Data {
        var textField = Data()
        textField.append("--\(Self.boundary)\r\n")
        textField.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        textField.append("\(value)\r\n")
        return textField
    }
}
