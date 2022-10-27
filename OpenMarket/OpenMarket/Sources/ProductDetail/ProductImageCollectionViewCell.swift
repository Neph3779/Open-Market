//
//  ProductImageCollectionViewCell.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/10/27.
//

import UIKit

final class ProductImageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "productImageCollectionViewCell"
    private let imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpImageView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setContents(image: UIImage) {
        imageView.image = image
    }

    private func setUpImageView() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
