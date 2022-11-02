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
    var setLabelContents: (() -> Void)?
    var showErrorAlert: ((OpenMarketError) -> Void)?
    var reloadCollectionView: (() -> Void)?
    let dispatchGroup = DispatchGroup()
    var currentImageCollectionIndex: CGFloat = 0

    init(productId: Int) {
        self.productId = productId
    }

    func fetchData() {
        fetchProductData()
        dispatchGroup.notify(queue: DispatchQueue.global()) { [weak self] in
            guard let self = self else { return }
            self.fetchImageData()
        }
    }

    func fetchProductData() {
        dispatchGroup.enter()
        productDetailAPI.getProductDetail(id: productId) { [weak self] result in
            guard let self = self,
                  let setLabelContents = self.setLabelContents,
                  let showErrorAlert = self.showErrorAlert else { return }
            switch result {
            case .success(let product):
                DispatchQueue.main.async {
                    self.detailProduct = product
                    setLabelContents()
                    self.dispatchGroup.leave()
                }
            case .failure(let error):
                showErrorAlert(error)
            }
        }
    }

    func fetchImageData() {
        guard let product = detailProduct else { return }
        var images = [UIImage]()
        let imageFetchDispatchGroup = DispatchGroup()

        imageFetchDispatchGroup.enter()
        for imageIndex in 0..<product.images.count {
            productDetailAPI.getProductImage(url: product.images[imageIndex].url) { result in
                switch result {
                case .success(let image):
                    images.append(image)
                    if imageIndex == product.images.count - 1 {
                        imageFetchDispatchGroup.leave()
                    }
                case .failure:
                    break
                }
            }
        }

        imageFetchDispatchGroup.notify(queue: DispatchQueue.global()) {
            self.productImages = images
            DispatchQueue.main.async { [weak self] in
                guard let self = self,
                let reloadCollectionView = self.reloadCollectionView else { return }
                reloadCollectionView()
            }
        }
    }

    func deleteProduct(secret: String) {
        productDetailAPI.deleteProduct(productId: productId, secret: secret) { [weak self] result in
            switch result {
            case .success:
                break
            case .failure(let error):
                guard let self = self,
                      let showErrorAlert = self.showErrorAlert else { return }
                showErrorAlert(error)
            }
        }
    }
}
