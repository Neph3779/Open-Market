//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/10/27.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    private let viewModel: ProductDetailViewModel
    private let outerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private let imageCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private let imageNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(productId: Int) {
        self.viewModel = ProductDetailViewModel(productId: productId)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = ProductDetailViewModel(productId: 1)
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setProductFetchCompletion()
        fetchDetailProductData()
        setImageFetchCompletion()
        fetchImageData()
        setUpOuterScrollView()
        setUpCollectionView()
        addLabelConstraints()
    }

    private func fetchDetailProductData() {
        viewModel.dispatchGroup.enter()
        viewModel.fetchProductData()
    }

    private func setProductFetchCompletion() {
        viewModel.productFetchCompletion = { result in
            switch result {
            case .success(let product):
                DispatchQueue.main.async {
                    self.viewModel.detailProduct = product
                    self.setLabelContents()
                    self.viewModel.dispatchGroup.leave()
                }
            case .failure(let error):
                self.showErrorAlert(error: error)
            }
        }
    }

    private func fetchImageData() {
        viewModel.dispatchGroup.notify(queue: DispatchQueue.main) {
            self.viewModel.fetchImageData()
        }
    }

    private func setImageFetchCompletion() {
        viewModel.imageFetchCompletion = {
            DispatchQueue.main.async {
                self.imageCollectionView.reloadData()
            }
        }
    }

    private func setUpOuterScrollView() {
        view.addSubview(outerScrollView)
        NSLayoutConstraint.activate([
            outerScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            outerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            outerScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            outerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setUpCollectionView() {
        imageCollectionView.isPagingEnabled = true
        imageCollectionView.contentInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        imageCollectionView.showsVerticalScrollIndicator = false
        imageCollectionView.showsHorizontalScrollIndicator = false
        imageCollectionView.register(ProductImageCollectionViewCell.self,
                                     forCellWithReuseIdentifier: ProductImageCollectionViewCell.reuseIdentifier)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        outerScrollView.addSubview(imageCollectionView)
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: outerScrollView.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }

    private func addLabelConstraints() {
        [imageNumberLabel, productNameLabel, stockLabel, priceLabel, discountedPriceLabel, descriptionLabel].forEach {
            outerScrollView.addSubview($0)
            $0.numberOfLines = 0
        }
        NSLayoutConstraint.activate([
            imageNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageNumberLabel.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 10),
            productNameLabel.leadingAnchor.constraint(equalTo: outerScrollView.leadingAnchor),
            productNameLabel.topAnchor.constraint(equalTo: imageNumberLabel.bottomAnchor, constant: 10),
            stockLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stockLabel.topAnchor.constraint(equalTo: imageNumberLabel.bottomAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: stockLabel.bottomAnchor, constant: 10),
            discountedPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            discountedPriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: outerScrollView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: outerScrollView.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: discountedPriceLabel.bottomAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: outerScrollView.bottomAnchor)
        ])
    }

    private func setLabelContents() {
        guard let product = viewModel.detailProduct else { return }
        imageNumberLabel.text = String(product.images.count)
        productNameLabel.text = product.name
        stockLabel.text = String(product.stock)
        priceLabel.text = String(product.price)
        discountedPriceLabel.text = String(product.discountedPrice)
        descriptionLabel.text = product.description
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductImageCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ProductImageCollectionViewCell else { return UICollectionViewCell() }
        cell.setContents(image: viewModel.productImages[indexPath.row])
        return cell
    }
}

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}
