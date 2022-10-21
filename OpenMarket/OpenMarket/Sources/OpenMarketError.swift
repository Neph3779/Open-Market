//
//  OpenMarketError.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/18.
//

import Foundation

enum OpenMarketError: Error, Equatable {
    case invalidURL
    case invalidData
    case didNotReceivedResponse
    case wrongResponse(_ statusCode: Int)
    case didNotReceivedData
    case JSONEncodingError
    case sessionError
    case bodyEncodingError
    case requestDataTypeNotMatch
    case requestGETWithData

    var name: String {
        return String(describing: self)
    }

    var description: String {
        switch self {
        case .invalidData:
            return "유효하지 않은 데이터입니다."
        case .didNotReceivedResponse:
            return "서버로부터 응답이 없습니다."
        case .wrongResponse(let statusCode):
            return "[Status Code: \(statusCode)] 잘못된 응답입니다."
        case .didNotReceivedData:
            return "서버로부터 데이터 수신에 실패했습니다."
        case .sessionError:
            return "네트워크 연결이 불안정합니다."
        case .bodyEncodingError:
            return "송신 데이터 인코딩에 실패했습니다."
        default:
            return "Unknown Error"
        }
    }
}
