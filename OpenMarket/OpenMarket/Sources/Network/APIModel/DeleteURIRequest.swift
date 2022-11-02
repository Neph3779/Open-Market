//
//  DeleteURIRequest.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/11/02.
//

import Foundation

struct DeleteURIRequest: Encodable {
    let productId: String
    let identifier: String
    let secret: String

    private enum Codingkeys: String, CodingKey {
        case productId = "product_id"
        case identifier, secret
    }
}
