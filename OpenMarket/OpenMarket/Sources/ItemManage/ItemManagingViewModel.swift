//
//  ItemManagingViewModel.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/10/22.
//

import UIKit

final class ItemManagingViewModel {
    struct PickedImage {
        let name: String
        let image: UIImage
        let data: Data
    }
    let itemManageAPI = ItemManageAPI()
    var pickedImages = [PickedImage]()
    var manageMode: ManageMode = .register
}

// MARK: Enums
extension ItemManagingViewModel {
    enum Style {
        static let currencyTrailingMargin: CGFloat = 20
        static let defaultCurrencyCode: String = "KRW"
        static let descriptionViewProportion: CGFloat = 0.5
        static let imageSize: (multiplier: CGFloat, constant: CGFloat) = (1/6, -10)
        static let imageSpacing: CGFloat = 10
        static let itemDescriptionPlaceholder: String = "상품의 상세한 내용을 작성해주세요."
        static let itemDiscountedPricePlaceholder: String = "할인가격 (Optional)"
        static let itemPricePlaceholder: String = "가격"
        static let itemStockPlaceholder: String = "재고수량"
        static let itemTitlePlaceholder: String = "상품명"
        static let numberOfImages: Int = 5
        static let passwordPlaceholder: String = "비밀번호"
        static let priceViewHeightProportion: CGFloat = 0.1
        static let stackViewMargin: CGFloat = 15
    }

    enum ManageMode {
        case register
        case modify

        var navigationbarTitle: String {
            switch self {
            case .register:
                return "상품등록"
            case .modify:
                return "상품수정"
            }
        }
        var buttonTitle: String {
            switch self {
            case .register:
                return "등록"
            case .modify:
                return "수정"
            }
        }
    }
}
