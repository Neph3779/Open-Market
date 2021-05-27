//
//  ItemManagingViewController.swift
//  OpenMarket
//
//  Created by 천수현 on 2021/05/23.
//

import UIKit
import PhotosUI

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
        stackView.spacing = 15
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        return stackView
    }()

    private let imageSelectStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 10
        return stackView
    }()

    private let imageAddButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
        button.addTarget(self, action: #selector(presentPicker), for: .touchUpInside)
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.layer.borderWidth = 1
        return button
    }()

    private let itemTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(outerScrollView)
        setItemManagingView()
        setOuterScrollView()
        setOuterStackView()
        setImageSelectStackView()
    }

    private func setItemManagingView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "상품등록"
        navigationItem.rightBarButtonItem = registerItemButton
    }

    private func setOuterScrollView() {
        outerScrollView.addSubview(outerStackView)
        NSLayoutConstraint.activate([
            outerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            outerScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            outerScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            outerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setOuterStackView() {
        outerStackView.addArrangedSubview(imageSelectStackView)
        outerStackView.addArrangedSubview(itemTitleTextField)
        NSLayoutConstraint.activate([
            outerStackView.topAnchor.constraint(equalTo: outerScrollView.topAnchor),
            outerStackView.leadingAnchor.constraint(equalTo: outerScrollView.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: outerScrollView.trailingAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: outerScrollView.bottomAnchor),
            outerStackView.widthAnchor.constraint(equalTo: outerScrollView.widthAnchor)
        ])
    }

    private func setImageSelectStackView() {
        imageSelectStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        imageSelectStackView.addArrangedSubview(imageAddButton)
        NSLayoutConstraint.activate([
            imageAddButton.heightAnchor.constraint(equalTo: imageSelectStackView.heightAnchor, multiplier: 0.6),
            imageAddButton.widthAnchor.constraint(equalTo: imageAddButton.heightAnchor)
        ])
        for _ in 1...5 {
            let imageView = UIImageView()
            imageView.backgroundColor = .systemGray
            imageSelectStackView.addArrangedSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalTo: imageAddButton.heightAnchor),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
        }
    }

    @objc func registerItem() {
        navigationController?.popViewController(animated: true)
    }

    @objc func presentPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 5
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true, completion: nil)
    }
}

extension ItemManagingViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
    }
}
