//
//  HTTPMethod.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/10/21.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"

    var mimeType: String? {
        switch self {
        case .get:
            return nil
        case .post, .patch:
            return "multipart/form-data; boundary=\"\(RequestBodyEncoder.boundary)\""
        case .delete:
            return "application/json"
        }
    }
}
