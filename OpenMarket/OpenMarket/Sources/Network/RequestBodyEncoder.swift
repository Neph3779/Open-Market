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
    private let crlf = "\r\n"

    func encodePostRequest(postRequest: PostRequest) throws -> Data {
        var requestData = Data()
        let lastBoundary = "--\(Self.boundary)--\(crlf)"

        requestData.append(crlf)

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

        requestData.append(lastBoundary)
        return requestData
    }

    private func convertFileField(key: String, fileName: String, data: Data) -> Data {
        var dataField = Data()
        let divisionBoundary = "--\(Self.boundary)\(crlf)"
        dataField.append(divisionBoundary)
        dataField.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName).png\"\(crlf)")
        dataField.append("Content-Type: image/png\r\n\r\n")
        dataField.append(data)
        dataField.append("\(crlf)")
        return dataField
    }

    private func convertTextField(key: String, value: String) -> Data {
        var textField = Data()
        let divisionBoundary = "--\(Self.boundary)\(crlf)"
        textField.append("--\(Self.boundary)\(crlf)")
        textField.append("Content-Disposition: form-data; name=\"\(key)\"\(crlf)\(crlf)")
        textField.append("\(value)\(crlf)")
        textField.append("\(crlf)")
        return textField
    }
}
