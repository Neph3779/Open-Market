//
//  ProductViewModel.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/10/27.
//

import UIKit

final class ProductDetailViewModel {
    let productDetailAPI = ProductDetailAPI()
    var images: [UIImage] = [
        UIImage(systemName: "zzz")!,
        UIImage(systemName: "person")!,
        UIImage(systemName: "circle")!
    ]
    let productId: Int
    var detailProduct: DetailItem?
    var fetchProductDataCompletion: ((Result<DetailItem, OpenMarketError>) -> Void)?

    init(productId: Int) {
        self.productId = productId
    }

    func fetchProductData() {
        guard let completion = fetchProductDataCompletion else { return }
        ProductDetailAPI().getProductDetail(id: productId, completionHandler: completion)
    }
}
