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
    private let flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    private lazy var imageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private let imageNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
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
        bind()
        fetchData()
        setUpOuterScrollView()
        setUpCollectionView()
        addLabelConstraints()
    }

    private func bind() {
        viewModel.setLabelContents = setLabelContents
        viewModel.showErrorAlert = showErrorAlert(error:)
        viewModel.reloadCollectionView = imageCollectionView.reloadData
    }

    private func fetchData() {
        viewModel.fetchData()
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
        imageCollectionView.contentInsetAdjustmentBehavior = .never
        imageCollectionView.decelerationRate = .fast
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
            productNameLabel.leadingAnchor.constraint(equalTo: outerScrollView.leadingAnchor, constant: 10),
            productNameLabel.topAnchor.constraint(equalTo: imageNumberLabel.bottomAnchor, constant: 20),
            stockLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stockLabel.topAnchor.constraint(equalTo: imageNumberLabel.bottomAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            priceLabel.topAnchor.constraint(equalTo: stockLabel.bottomAnchor, constant: 10),
            discountedPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            discountedPriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: outerScrollView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            descriptionLabel.topAnchor.constraint(equalTo: discountedPriceLabel.bottomAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: outerScrollView.bottomAnchor)
        ])
    }

    private func setLabelContents() {
        guard let product = viewModel.detailProduct else { return }
        imageNumberLabel.text = "1 / \(product.images.count)"
        productNameLabel.text = product.name
        stockLabel.text = String(product.stock)
        priceLabel.attributedText = NSAttributedString(
            string: "\(product.currency) \(Int(product.price))",
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        discountedPriceLabel.text = "\(product.currency) \(Int(product.discountedPrice))"
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

extension ProductDetailViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludeSpacing = imageCollectionView.frame.width

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludeSpacing
        var roundedIndex: CGFloat = round(index)

        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }

        if viewModel.currentImageCollectionIndex > roundedIndex {
            viewModel.currentImageCollectionIndex -= 1
            roundedIndex = viewModel.currentImageCollectionIndex
        } else if viewModel.currentImageCollectionIndex < roundedIndex {
            viewModel.currentImageCollectionIndex += 1
            roundedIndex = viewModel.currentImageCollectionIndex
        }

        imageNumberLabel.text = "\(Int(viewModel.currentImageCollectionIndex + 1)) / \(viewModel.productImages.count)"

        offset = CGPoint(x: roundedIndex * cellWidthIncludeSpacing
                         + flowLayout.minimumInteritemSpacing * viewModel.currentImageCollectionIndex + 1,
                         y: scrollView.contentInset.top)

        targetContentOffset.pointee = offset
    }
}
