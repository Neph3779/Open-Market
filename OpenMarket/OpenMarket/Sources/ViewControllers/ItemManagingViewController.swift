//
//  ItemManagingViewController.swift
//  OpenMarket
//
//  Created by 천수현 on 2021/05/23.
//

import UIKit
import PhotosUI

class ItemManagingViewController: UIViewController {
    private let manageMode: ManageMode

    private lazy var registerItemButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: manageMode.buttonTitle, style: .done, target: self, action: #selector(registerItem))
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
        stackView.spacing = Style.stackViewMargin
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: Style.stackViewMargin,
                                                                     leading: Style.stackViewMargin,
                                                                     bottom: 0,
                                                                     trailing: Style.stackViewMargin)
        return stackView
    }()

    private let itemImageViews: [UIImageView] = (1...Style.numberOfImages).map { _ in UIImageView() }

    private let imageSelectStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = Style.imageSpacing
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
        textField.placeholder = Style.itemTitlePlaceholder
        return textField
    }()

    private let itemCurrencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Locale.current.currencyCode ?? Style.defaultCurrencyCode
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let itemPriceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        textField.placeholder = Style.itemPricePlaceholder
        return textField
    }()

    private let itemDiscountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        textField.placeholder = Style.itemDiscountedPricePlaceholder
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
        textField.placeholder = Style.itemStockPlaceholder
        return textField
    }()

    private lazy var itemDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = Style.itemDescriptionPlaceholder
        textView.textColor = .lightGray
        return textView
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        textField.placeholder = Style.passwordPlaceholder
        return textField
    }()

    init(mode: ManageMode) {
        manageMode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        manageMode = .register
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(outerScrollView)
        setItemManagingView()
        setOuterScrollView()
        setOuterStackView()
        setImageSelectStackView()
        setPriceView()
        setItemDescriptionTextView()
        setDivisionLine()
    }

    private func setItemManagingView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = manageMode.navigationbarTitle
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
        imageSelectStackView.addArrangedSubview(imageAddButton)

        NSLayoutConstraint.activate([
            imageAddButton.widthAnchor.constraint(equalTo: imageSelectStackView.widthAnchor,
                                                  multiplier: Style.imageSize.multiplier,
                                                  constant: Style.imageSize.constant),
            imageAddButton.heightAnchor.constraint(equalTo: imageAddButton.widthAnchor)
        ])

        itemImageViews.forEach { itemImageView in
            itemImageView.translatesAutoresizingMaskIntoConstraints = false
            imageSelectStackView.addArrangedSubview(itemImageView)
            NSLayoutConstraint.activate([
                itemImageView.heightAnchor.constraint(equalTo: imageAddButton.heightAnchor),
                itemImageView.widthAnchor.constraint(equalTo: imageAddButton.widthAnchor)
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
            priceView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Style.priceViewHeightProportion),
            itemCurrencyLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor),
            itemCurrencyLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
            itemPriceTextField.leadingAnchor.constraint(equalTo: itemCurrencyLabel.trailingAnchor, constant: Style.currencyTrailingMargin),
            itemPriceTextField.topAnchor.constraint(equalTo: priceView.topAnchor),
            itemPriceTextField.heightAnchor.constraint(equalTo: priceView.heightAnchor, multiplier: 1/2),
            itemPriceTextField.trailingAnchor.constraint(equalTo: priceView.trailingAnchor),
            itemDiscountedPriceTextField.leadingAnchor.constraint(equalTo: itemPriceTextField.leadingAnchor),
            itemDiscountedPriceTextField.topAnchor.constraint(equalTo: itemPriceTextField.bottomAnchor),
            itemDiscountedPriceTextField.heightAnchor.constraint(equalTo: priceView.heightAnchor, multiplier: 1/2),
            itemDiscountedPriceTextField.trailingAnchor.constraint(equalTo: itemPriceTextField.trailingAnchor)
        ])
    }

    private func setItemDescriptionTextView() {
        itemDescriptionTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Style.descriptionViewProportion).isActive = true
    }

    private func setDivisionLine() {
        let outerStackViewElements = outerStackView.arrangedSubviews.enumerated().dropLast()

        for (index, _) in outerStackViewElements {
            outerStackView.insertArrangedSubview(UIView.divisionLine, at: 2 * index  + 1)
        }
    }

    @objc func registerItem() {
        guard let title = itemTitleTextField.text,
              let descriptions = itemDescriptionTextView.text,
              let priceText = itemPriceTextField.text,
              let price = Int(priceText),
              let currency = itemCurrencyLabel.text,
              let stockText = itemStockTextField.text,
              let stock = Int(stockText),
              let password = passwordTextField.text else {
            return
        }

        let itemImageData = getItemImageData()

        let postingItem = PostingItem(title: title, descriptions: descriptions, price: price,
                                      currency: currency, stock: stock, discountedPrice: nil,
                                      images: itemImageData, password: password)

        OpenMarketService().postItem(data: postingItem, completionHandler: postCompletionHandler(result:))

        navigationController?.popViewController(animated: true)
    }

    func getItemImageData() -> [Data] {
        var itemImageData: [Data] = []

        for imageView in itemImageViews {
            guard let itemImage = imageView.image,
                  let imageData = itemImage.jpegData(compressionQuality: 0) else { continue }
            let imageKBSize = Double(imageData.count) / 1000.0
            if imageKBSize > 300 { continue }
            itemImageData.append(imageData)
        }

        return itemImageData
    }

    func postCompletionHandler(result: Result<MarketItem, OpenMarketError>) {
        switch result {
        case .success(let item):
            print(item.id)
        case .failure(let error):
            DispatchQueue.main.async {
                self.present(UIAlertController(title: error.name, message: error.description,
                                          preferredStyle: .alert), animated: true,
                        completion: { self.dismiss(animated: true, completion: nil) })
            }
        }
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
        let items = results.map(\.itemProvider)
        var pickedImages: [UIImage] = []

        if items.isEmpty {
            dismiss(animated: true, completion: nil)
        }

        for index in 0..<items.count {
            items[index].loadObject(ofClass: UIImage.self) { [self] image, _ in
                guard let itemImage = image as? UIImage else { return }
                pickedImages.append(itemImage)

                DispatchQueue.main.async {
                    itemImageViews[index].image = itemImage
                    if index == items.count - 1 {
                        dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
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

extension ItemManagingViewController {
    private enum Style {
        static let currencyTrailingMargin: CGFloat = 20
        static let defaultCurrencyCode: String = "KRW"
        static let descriptionViewProportion: CGFloat = 0.5
        static let imageSize: (multiplier: CGFloat, constant: CGFloat) = (1/6, -10)
        static let imageSpacing: CGFloat = 10
        static let itemDescriptionPlaceholder: String = "상품의 상세한 내용을 작성해주세요."
        static let itemDiscountedPricePlaceholder: String = "할인가격 (Optional)"
        static let itemPricePlaceholder: String = "가격"
        static let itemStockPlaceholder: String = "재고수량"
        static let itemTitlePlaceholder: String = "상품명"
        static let numberOfImages: Int = 5
        static let passwordPlaceholder: String = "비밀번호"
        static let priceViewHeightProportion: CGFloat = 0.1
        static let stackViewMargin: CGFloat = 15
    }

    enum ManageMode {
        case register
        case modify

        var navigationbarTitle: String {
            switch self {
            case .register:
                return "상품등록"
            case .modify:
                return "상품수정"
            }
        }
        var buttonTitle: String {
            switch self {
            case .register:
                return "등록"
            case .modify:
                return "수정"
            }
        }
    }
}
