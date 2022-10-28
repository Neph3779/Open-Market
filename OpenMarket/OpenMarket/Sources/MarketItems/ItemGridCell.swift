//
//  ItemGridCell.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/23.
//

import UIKit

class ItemGridCell: UICollectionViewCell {
    static let reuseIdentifier = "ItemGridCell"

    private var fetchImageDataTask: URLSessionDataTask?

    private let imageView = ItemCellImageView(systemName: "photo")
    private let titleLabel = ItemCellLabel(textStyle: .headline)
    private let priceLabel = PriceLabel(textColor: .lightGray)
    private let discountedPriceLabel = ItemCellLabel(textColor: .lightGray)

    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    private let stockLabel = StockLabel(textColor: .lightGray)

    private let gridStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()

    var item: MarketItem? {
        didSet {
            SessionManager.shared.fetchImage(urlString: item?.thumbnail) { result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                case .failure:
                    break
                }
            }

            titleLabel.text = item?.name

            if let currency = item?.currency,
               let price = item?.price {
                if let discountedPrice = item?.discountedPrice {
                    priceLabel.setText(by: .discounted, currency, price)
                    discountedPriceLabel.text = "\(currency) \(discountedPrice)"
                } else {
                    priceLabel.setText(by: .normal, currency, price)
                }
            }

            if let stock = item?.stock {
                stockLabel.setText(stock)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBorder()
        addSubviews()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        fetchImageDataTask?.cancel()
        imageView.reset()
        titleLabel.reset()
        priceLabel.reset()
        discountedPriceLabel.reset()
        stockLabel.reset()
        configureBorder()
    }

    func configureBorder() {
        layer.cornerRadius = 20
        layer.borderColor = UIColor.systemGray3.cgColor
        layer.borderWidth = 1
    }

    func addSubviews() {
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(discountedPriceLabel)

        gridStackView.addArrangedSubview(titleLabel)
        gridStackView.addArrangedSubview(priceStackView)
        gridStackView.addArrangedSubview(stockLabel)

        addSubview(imageView)
        addSubview(gridStackView)
    }

    func activateConstraints() {
        var constraints = [NSLayoutConstraint]()

        let imageViewConstraints = [
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        ]

        let gridStackViewConstraints = [
            gridStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            gridStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            gridStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            gridStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ]

        constraints.append(contentsOf: imageViewConstraints)
        constraints.append(contentsOf: gridStackViewConstraints)

        NSLayoutConstraint.activate(constraints)
    }
}
