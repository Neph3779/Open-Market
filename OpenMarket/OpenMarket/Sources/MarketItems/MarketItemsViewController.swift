//
//  OpenMarket - MarketItemsViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MarketItemsViewController: UIViewController {
    private let viewModel = MarketItemsViewModel()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    private lazy var layoutSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [MarketItemsViewModel.LayoutMode.list.name,
                                                          MarketItemsViewModel.LayoutMode.grid.name])
        segmentedControl.selectedSegmentIndex = MarketItemsViewModel.LayoutMode.list.rawValue
        segmentedControl.layer.borderWidth = Style.segmentControlBorderWidth
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.addTarget(self, action: #selector(changeLayoutMode), for: .valueChanged)
        return segmentedControl
    }()

    private lazy var registerItemButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(moveToRegisterView))
        return button
    }()

    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInsetReference = .fromSafeArea
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()

    override func viewWillAppear(_ animated: Bool) {
        viewModel.refreshPageData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        addSubviews()
        configureCollectionView()
        configureLoadingIndicator()
        configureNavigationItems()
    }

    private func bind() {
        viewModel.reloadData = collectionView.reloadData
        viewModel.showErrorAlert = showErrorAlert(error: )
        viewModel.insertItems = collectionView.insertItems(at:)
        viewModel.stopLoadingIndicator = loadingIndicator.stopAnimating
    }

    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
    }

    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collectionView.register(ItemListCell.self, forCellWithReuseIdentifier: ItemListCell.reuseIdentifier)
        collectionView.register(ItemGridCell.self, forCellWithReuseIdentifier: ItemGridCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }

    private func configureLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
        loadingIndicator.startAnimating()
    }

    private func configureNavigationItems() {
        navigationItem.titleView = layoutSegmentedControl
        navigationItem.rightBarButtonItem = registerItemButton
    }

    private func fetchFirstPageData() {
        viewModel.refreshPageData()
    }

    private func getCellWidth(numberOfcolumns: Int, inset: CGFloat) -> CGFloat {
        let listCellWidth: CGFloat = collectionView.safeAreaLayoutGuide.layoutFrame.width
        let rowWidthWithoutInset: CGFloat = collectionView.safeAreaLayoutGuide.layoutFrame.width - inset * CGFloat(numberOfcolumns + 1)
        let gridCellWidth: CGFloat = rowWidthWithoutInset / CGFloat(numberOfcolumns)

        switch viewModel.layoutMode {
        case .list:
            return listCellWidth
        case .grid:
            return gridCellWidth
        }
    }

    @objc private func changeLayoutMode() {
        let mode = MarketItemsViewModel.LayoutMode(rawValue: layoutSegmentedControl.selectedSegmentIndex)!
        viewModel.layoutMode.changeMode(into: mode)
        collectionView.reloadData()
    }

    @objc func moveToRegisterView() {
        let view = ItemManagingViewController(mode: .register)
        navigationItem.backButtonTitle = "취소"
        navigationController?.pushViewController(view, animated: true)
    }
}

extension MarketItemsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.marketItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.layoutMode {
        case .list:
            return collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCell.reuseIdentifier, for: indexPath)
        case .grid:
            return collectionView.dequeueReusableCell(withReuseIdentifier: ItemGridCell.reuseIdentifier, for: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.marketItems.count - Style.numberOfCellsToTriggerFetch
            && viewModel.hasNextPage {
            viewModel.fetchNextPageData()
        }

        switch viewModel.layoutMode {
        case .list:
            guard let itemCell = cell as? ItemListCell else { return }
            itemCell.item = viewModel.marketItems[indexPath.row]
        case .grid:
            guard let itemCell = cell as? ItemGridCell else { return }
            itemCell.item = viewModel.marketItems[indexPath.item]
        }
    }
}

extension MarketItemsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(
            ProductDetailViewController(productId: viewModel.marketItems[indexPath.row].id),
            animated: true)
    }
}

extension MarketItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let listCellWidth: CGFloat = collectionView.safeAreaLayoutGuide.layoutFrame.width
        let listCellHeight: CGFloat = Style.listCellHeight
        let gridCellWidth: CGFloat = getCellWidth(numberOfcolumns: 2, inset: 10)
        let gridCellHeight: CGFloat = gridCellWidth * Style.goldenRatio

        return viewModel.layoutMode == .list ? CGSize(width: listCellWidth, height: listCellHeight) :
            CGSize(width: gridCellWidth, height: gridCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        switch viewModel.layoutMode {
        case .grid:
            return UIEdgeInsets(top: 0, left: Style.gridHorizontalInset, bottom: 0, right: Style.gridHorizontalInset)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

extension MarketItemsViewController {
    private enum Style {
        static let goldenRatio: CGFloat = 1.618
        static let gridHorizontalInset: CGFloat = 10
        static let listCellHeight: CGFloat = 70
        static let numberOfCellsToTriggerFetch = 3
        static let numberOfGridColumns: Int = 2
        static let segmentControlBorderWidth: CGFloat = 2
    }
}
