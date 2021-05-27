//
//  ItemManagingViewController.swift
//  OpenMarket
//
//  Created by 천수현 on 2021/05/23.
//

import UIKit

class ItemManagingViewController: UIViewController {
    private lazy var registerItemButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "등록", style: .done, target: self, action: #selector(registerItem))
        return button
    }()

    private let outerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()

    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.backgroundColor = .systemBackground
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setItemManagingView()
        setOuterScrollView()
    }

    private func setItemManagingView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "상품등록"
        navigationItem.rightBarButtonItem = registerItemButton
    }

    private func setOuterScrollView() {
        view.addSubview(outerScrollView)
        NSLayoutConstraint.activate([
            outerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            outerScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            outerScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            outerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setStackView() {
        outerScrollView.addSubview(outerStackView)
        NSLayoutConstraint.activate([
            outerStackView.topAnchor.constraint(equalTo: outerScrollView.topAnchor),
            outerStackView.leadingAnchor.constraint(equalTo: outerScrollView.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: outerScrollView.trailingAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: outerScrollView.bottomAnchor),
            outerStackView.widthAnchor.constraint(equalTo: outerScrollView.widthAnchor)
        ])
    }

    @objc func registerItem() {
        navigationController?.popViewController(animated: true)
    }
}
