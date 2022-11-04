//
//  ItemManagingViewController.swift
//  OpenMarket
//
//  Created by 천수현 on 2021/05/23.
//

import UIKit
import PhotosUI

// TODO: ViewModel로 옮길 수 있는 로직들 옮기기
final class ItemManagingViewController: UIViewController {
    private let viewModel = ItemManagingViewModel()

    private lazy var registerItemButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: viewModel.manageMode.buttonTitle,
                                     style: .done, target: self, action: #selector(registerItem))
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
        stackView.spacing = ItemManagingViewModel.Style.stackViewMargin
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: ItemManagingViewModel.Style.stackViewMargin,
                                                                     leading: ItemManagingViewModel.Style.stackViewMargin,
                                                                     bottom: 0,
                                                                     trailing: ItemManagingViewModel.Style.stackViewMargin)
        return stackView
    }()

    private let itemImageViews: [UIImageView] = (1...ItemManagingViewModel.Style.numberOfImages).map { _ in UIImageView() }

    private let imageSelectStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = ItemManagingViewModel.Style.imageSpacing
        return stackView
    }()

    private lazy var imageAddButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
        button.addTarget(self, action: #selector(presentPicker), for: .touchUpInside)
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.layer.borderWidth = 1
        return button
    }()

    private let itemTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ItemManagingViewModel.Style.itemTitlePlaceholder
        return textField
    }()

    private let itemCurrencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Locale.current.currencyCode ?? ItemManagingViewModel.Style.defaultCurrencyCode
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let itemPriceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        textField.placeholder = ItemManagingViewModel.Style.itemPricePlaceholder
        return textField
    }()

    private let itemDiscountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        textField.placeholder = ItemManagingViewModel.Style.itemDiscountedPricePlaceholder
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
        textField.keyboardType = .numberPad
        textField.placeholder = ItemManagingViewModel.Style.itemStockPlaceholder
        return textField
    }()

    private lazy var itemDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.placeholder = ItemManagingViewModel.Style.itemDescriptionPlaceholder
        textField.contentVerticalAlignment = .top
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        textField.placeholder = ItemManagingViewModel.Style.passwordPlaceholder
        return textField
    }()

    init(mode: ItemManagingViewModel.ManageMode, product: DetailItem? = nil) {
        super.init(nibName: nil, bundle: nil)
        viewModel.manageMode = mode
        viewModel.product = product
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setContents()
        setItemManagingView()
        setOuterScrollView()
        setOuterStackView()
        setImageSelectStackView()
        setPriceView()
        setItemDescriptionTextField()
        setDivisionLine()
    }

    private func setContents() {
        if let product = viewModel.product {
            itemTitleTextField.text = product.name
            itemPriceTextField.text = product.price.description
            itemDiscountedPriceTextField.text = product.discountedPrice.description
            itemStockTextField.text = product.stock.description
            itemDescriptionTextField.text = product.description
        }
    }

    private func setItemManagingView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = viewModel.manageMode.navigationbarTitle
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

    private func setOuterStackView() {
        outerScrollView.addSubview(outerStackView)
        if viewModel.manageMode == .register {
            outerStackView.addArrangedSubview(imageSelectStackView)
        }
        outerStackView.addArrangedSubview(itemTitleTextField)
        outerStackView.addArrangedSubview(priceView)
        outerStackView.addArrangedSubview(itemStockTextField)
        outerStackView.addArrangedSubview(passwordTextField)
        outerStackView.addArrangedSubview(itemDescriptionTextField)
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
                                                  multiplier: ItemManagingViewModel.Style.imageSize.multiplier,
                                                  constant: ItemManagingViewModel.Style.imageSize.constant),
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
            priceView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: ItemManagingViewModel.Style.priceViewHeightProportion),
            itemCurrencyLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor),
            itemCurrencyLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
            itemPriceTextField.leadingAnchor.constraint(equalTo: itemCurrencyLabel.trailingAnchor,
                                                        constant: ItemManagingViewModel.Style.currencyTrailingMargin),
            itemPriceTextField.topAnchor.constraint(equalTo: priceView.topAnchor),
            itemPriceTextField.heightAnchor.constraint(equalTo: priceView.heightAnchor, multiplier: 1/2),
            itemPriceTextField.trailingAnchor.constraint(equalTo: priceView.trailingAnchor),
            itemDiscountedPriceTextField.leadingAnchor.constraint(equalTo: itemPriceTextField.leadingAnchor),
            itemDiscountedPriceTextField.topAnchor.constraint(equalTo: itemPriceTextField.bottomAnchor),
            itemDiscountedPriceTextField.heightAnchor.constraint(equalTo: priceView.heightAnchor, multiplier: 1/2),
            itemDiscountedPriceTextField.trailingAnchor.constraint(equalTo: itemPriceTextField.trailingAnchor)
        ])
    }

    private func setItemDescriptionTextField() {
        itemDescriptionTextField.delegate = self
        itemDescriptionTextField.heightAnchor
            .constraint(equalTo: view.heightAnchor,
                        multiplier: ItemManagingViewModel.Style.descriptionViewProportion).isActive = true
    }

    private func setDivisionLine() {
        let outerStackViewElements = outerStackView.arrangedSubviews.enumerated().dropLast()

        for (index, _) in outerStackViewElements {
            outerStackView.insertArrangedSubview(UIView.divisionLine, at: 2 * index  + 1)
        }
    }

    @objc private func registerItem() {
        guard let title = itemTitleTextField.text,
              let description = itemDescriptionTextField.text,
              let priceText = itemPriceTextField.text,
              let price = Double(priceText),
              let discountedPriceText = itemDiscountedPriceTextField.text,
              let discountedPrice = Double(discountedPriceText),
              let currency = itemCurrencyLabel.text,
              let stockText = itemStockTextField.text,
              let stock = Int(stockText),
              let password = passwordTextField.text else {
            return
        }
        if viewModel.manageMode == .register {
            let postingItem = PostRequest(
                parameter: PostRequest.Parameter(name: title, description: description, price: Double(price),
                                                 currency: currency, stock: stock,
                                                 discountedPrice: Double(discountedPrice), secret: password),
                images: postImages())
            viewModel.postItem(postRequest: postingItem, completionHandler: requestCompletionHandler(result:))
        } else if viewModel.manageMode == .modify {
            let patchingItem = PatchingItem(name: title, description: description,
                                            thumbnailId: nil, price: price, currency: currency,
                                            discountedPrice: discountedPrice, stock: stock, secret: password)
            viewModel.patchItem(patchingItem: patchingItem, completionHandler: requestCompletionHandler(result:))
        }
    }

    private func postImages() -> [PostRequest.PostingImage] {
        var postingImages = [PostRequest.PostingImage]()

        for item in viewModel.pickedImages {
            postingImages.append(.init(fileName: item.name, imageData: item.data))
        }

        return postingImages
    }

    private func requestCompletionHandler(result: Result<Void, OpenMarketError>) {
        switch result {
        case .success:
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        case .failure(let error):
            showErrorAlert(error: error)
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

// MARK: PHPickerDelegate
extension ItemManagingViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let items = results.map { $0.itemProvider }
        let lastItemIndex = items.count - 1
        let dispatchGroup = DispatchGroup()

        if items.isEmpty {
            dismiss(animated: true, completion: nil)
            return
        }

        viewModel.pickedImages.removeAll()

        dispatchGroup.enter()
        for index in 0...lastItemIndex {
            items[index].loadObject(ofClass: UIImage.self) { [weak self] (image, _) in
                guard let self = self else { return }
                if let name = items[index].suggestedName,
                   let image = image as? UIImage,
                   let data = image.pngData(),
                   data.count / 1000 < 300 {
                    self.viewModel.pickedImages.append(.init(name: name, image: image, data: data))
                }

                if index == lastItemIndex {
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.global()) {
            let didErrorOccurred = items.count != self.viewModel.pickedImages.count
            self.pickerCompletion(didErrorOccurred: didErrorOccurred)
        }
    }

    private func pickerCompletion(didErrorOccurred: Bool) {
        DispatchQueue.main.async {
            self.itemImageViews.forEach { $0.image = nil }
            for index in 0..<self.viewModel.pickedImages.count {
                self.itemImageViews[index].image = self.viewModel.pickedImages[index].image
            }

            didErrorOccurred ? self.dismiss(animated: true, completion: self.presentOverSizeError) : self.dismiss(animated: true, completion: nil)
        }
    }

    private func presentOverSizeError() {
        let alert = UIAlertController(title: "선택한 이미지 중 업로드 할 수 없는 이미지가 포함되어있어요",
                                      message: "이미지의 크기는 300Kb 이하여야 합니다🥲",
                                      preferredStyle: .alert)

        let yesAction = UIAlertAction(title: "확인", style: .cancel) { _ in  self.dismiss(animated: true, completion: nil) }
        alert.addAction(yesAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: TextFieldDelegate
extension ItemManagingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != itemDescriptionTextField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        } else {
            return true
        }
    }
}
