//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/10/27.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    private let viewModel = ProductDetailViewModel()
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpOuterScrollView()
        setUpCollectionView()
        addLabelConstraints()
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
        imageCollectionView.register(ProductImageCollectionViewCell.self,
                                     forCellWithReuseIdentifier: ProductImageCollectionViewCell.reuseIdentifier)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        outerScrollView.addSubview(imageCollectionView)
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: outerScrollView.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: outerScrollView.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: outerScrollView.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }

    private func addLabelConstraints() {
        [imageNumberLabel, productNameLabel, stockLabel, priceLabel, discountedPriceLabel, descriptionLabel].forEach {
            outerScrollView.addSubview($0)
            $0.text = "test text\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
            $0.numberOfLines = 0
        }
        NSLayoutConstraint.activate([
            imageNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageNumberLabel.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 10),
            productNameLabel.leadingAnchor.constraint(equalTo: outerScrollView.leadingAnchor),
            productNameLabel.topAnchor.constraint(equalTo: imageNumberLabel.bottomAnchor, constant: 10),
            stockLabel.trailingAnchor.constraint(equalTo: outerScrollView.trailingAnchor),
            stockLabel.topAnchor.constraint(equalTo: imageNumberLabel.bottomAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: outerScrollView.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: stockLabel.bottomAnchor, constant: 10),
            discountedPriceLabel.trailingAnchor.constraint(equalTo: outerScrollView.trailingAnchor),
            discountedPriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: outerScrollView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: outerScrollView.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: discountedPriceLabel.bottomAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: outerScrollView.bottomAnchor)
        ])
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductImageCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ProductImageCollectionViewCell else { return UICollectionViewCell() }

        return cell
    }
}

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {

}
