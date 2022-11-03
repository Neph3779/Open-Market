//
//  RequestBodyEncoderProtocol.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/18.
//

import Foundation

protocol RequestBodyEncoderProtocol {
    static var boundary: String { get }
    func encodePostRequest(postRequest: PostRequest) throws -> Data
    func encodeDeleteURIRequest(deleteURIRequest: DeleteURIRequest) throws -> Data
}
