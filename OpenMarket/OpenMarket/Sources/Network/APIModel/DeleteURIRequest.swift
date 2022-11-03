//
//  DeleteURIRequest.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/11/02.
//

import Foundation

struct DeleteURIRequest: Encodable, RequestData {
    let secret: String
}
