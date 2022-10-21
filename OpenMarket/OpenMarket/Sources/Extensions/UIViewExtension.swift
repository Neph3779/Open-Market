//
//  UIViewExtension.swift
//  OpenMarket
//
//  Created by 천수현 on 2021/05/28.
//

import UIKit

extension UIView {
    static var divisionLine: UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
}
