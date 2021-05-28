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

    private let itemCurrencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Locale.current.currencyCode ?? "KRW"
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let itemPriceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        textField.placeholder = "가격"
        return textField
    }()

    private let itemDiscountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        textField.placeholder = "할인가격 (Optional)"
        return textField
    }()

    private let priceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var itemStockTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.placeholder = "재고수량"
        return textField
    }()

    private lazy var itemDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = "상품의 상세한 내용을 작성해주세요."
        textView.textColor = .lightGray
        return textView
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        textField.placeholder = "비밀번호"
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(outerScrollView)
        setItemManagingView()
        setOuterScrollView()
        setOuterStackView()
        setImageSelectStackView()
        setPriceView()
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
        outerStackView.addArrangedSubview(priceView)
        outerStackView.addArrangedSubview(itemStockTextField)
        outerStackView.addArrangedSubview(passwordTextField)
        outerStackView.addArrangedSubview(itemDescriptionTextView)
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

    private func setPriceView() {
        itemPriceTextField.delegate = self
        itemDiscountedPriceTextField.delegate = self

        priceView.addSubview(itemCurrencyLabel)
        priceView.addSubview(itemPriceTextField)
        priceView.addSubview(itemDiscountedPriceTextField)
        NSLayoutConstraint.activate([
            priceView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            itemCurrencyLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor),
            itemCurrencyLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
            itemPriceTextField.leadingAnchor.constraint(equalTo: itemCurrencyLabel.trailingAnchor, constant: 20),
            itemPriceTextField.topAnchor.constraint(equalTo: priceView.topAnchor),
            itemPriceTextField.heightAnchor.constraint(equalTo: priceView.heightAnchor, multiplier: 0.5),
            itemPriceTextField.trailingAnchor.constraint(equalTo: priceView.trailingAnchor),
            itemDiscountedPriceTextField.leadingAnchor.constraint(equalTo: itemPriceTextField.leadingAnchor),
            itemDiscountedPriceTextField.topAnchor.constraint(equalTo: itemPriceTextField.bottomAnchor),
            itemDiscountedPriceTextField.heightAnchor.constraint(equalTo: priceView.heightAnchor, multiplier: 0.5),
            itemDiscountedPriceTextField.trailingAnchor.constraint(equalTo: itemPriceTextField.trailingAnchor)
        ])
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

extension ItemManagingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

extension ItemManagingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = nil
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "상품의 상세한 내용을 작성해주세요."
            textView.textColor = .lightGray
        }
    }
}
