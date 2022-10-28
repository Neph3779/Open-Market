//
//  ProductViewModel.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/10/27.
//

import UIKit

final class ProductDetailViewModel {
    let productDetailAPI = ProductDetailAPI()
    var productImages: [UIImage] = []
    let productId: Int
    var detailProduct: DetailItem?
    var productFetchCompletion: ((Result<DetailItem, OpenMarketError>) -> Void)?
    var imageFetchCompletion: (() -> Void)?
    let dispatchGroup = DispatchGroup()

    init(productId: Int) {
        self.productId = productId
    }

    func fetchProductData() {
        guard let completion = productFetchCompletion else { return }
        productDetailAPI.getProductDetail(id: productId, completionHandler: completion)
    }

    func fetchImageData() {
        guard let completion = imageFetchCompletion,
        let product = detailProduct else { return }
        var images = [UIImage]()

        for imageIndex in 0..<product.images.count {
            productDetailAPI.getProductImage(url: product.images[imageIndex].url) { result in
                switch result {
                case .success(let image):
                    images.append(image)
                    if imageIndex == product.images.count - 1 {
                        self.productImages = images
                        completion()
                    }
                case .failure:
                    break
                }
            }
        }
    }
}
