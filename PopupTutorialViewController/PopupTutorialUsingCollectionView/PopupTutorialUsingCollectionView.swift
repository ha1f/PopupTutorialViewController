//
//  PopupTutorialUsingCollectionView.swift
//  PopupTutorialViewController
//
//  Created by ha1f on 2018/10/15.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import UIKit

final class PopupTutorialUsingCollectionView: UIViewController {
    // MARK: - Nested types
    
    struct Dependency {
        var viewControllers: [UIViewController]
    }
    
    // MARK: - Properties
    
    @IBOutlet private var containerView: UIView! {
        didSet {
            containerView.clipsToBounds = true
            containerView.layer.cornerRadius = 5
        }
    }
    @IBOutlet private var pageControl: UIPageControl!
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.allowsSelection = false
            collectionView.isPagingEnabled = true
            collectionView.contentInset = .zero
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(PopupTutorialCollectionViewCell.self, forCellWithReuseIdentifier: PopupTutorialCollectionViewCell.reuseIdentifier)
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
            }
        }
    }
    @IBOutlet private var closeButton: UIButton! {
        didSet {
            closeButton?.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        }
    }
    @IBOutlet private var bottomButton: UIButton! {
        didSet {
            bottomButton?.addTarget(self, action: #selector(didTapBottomButton), for: .touchUpInside)
        }
    }
    
    private let viewControllers: [UIViewController]
    private var bottomButtonHandler: (() -> Void)?
    
    // MARK: - Initializers
    
    init(_ dependency: Dependency) {
        viewControllers = dependency.viewControllers
        
        super.init(nibName: nil, bundle: nil)
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
        // necessary to change status bar appearance when using .overCurrentContext
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = viewControllers.count
        pageControl.currentPage = 0
        pageControl.isHidden = true
        
        _updateBottomButton(forPage: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // update itemSize to match with the size of collectionView.
        // I don't know why but sometimes view is not layed-out even here.
        // And this is why I execute in DispatchQueue.main.async
        DispatchQueue.main.async { [collectionView] in
            guard let collectionView = collectionView else {
                return
            }
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                let oldSize = layout.itemSize
                layout.itemSize = collectionView.bounds.size
                layout.invalidateLayout()
                
                // keep the page
                collectionView.contentOffset = CGPoint(x: collectionView.contentOffset.x / oldSize.width * layout.itemSize.width, y: collectionView.contentOffset.y)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension PopupTutorialUsingCollectionView {
    private static func pageIndex(from scrollView: UIScrollView) -> Int {
        return Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
    }
    
    private func currentIndex() -> Int {
        return PopupTutorialUsingCollectionView.pageIndex(from: collectionView)
    }
    
    private func moveToNextPage() {
        guard let collectionView = self.collectionView else {
            return
        }
        let nextIndex = currentIndex() + 1
        if nextIndex < collectionView.numberOfItems(inSection: 0) {
            collectionView.scrollToItem(at: IndexPath(row: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    private func _updateBottomButton(forPage pageIndex: Int) {
        if (pageIndex >= viewControllers.count - 1) {
            // last page
            bottomButton.setTitle("Close", for: .normal)
            bottomButtonHandler = { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        } else {
            bottomButton.setTitle("Next", for: .normal)
            bottomButtonHandler = { [weak self] in
                self?.moveToNextPage()
            }
        }
    }
}

extension PopupTutorialUsingCollectionView {
    // MARK: - Targets
    
    @objc
    func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func didTapBottomButton() {
        bottomButtonHandler?()
    }
}

extension PopupTutorialUsingCollectionView: UICollectionViewDelegate {
    // MARK: - UICollectionViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPageIndex = PopupTutorialUsingCollectionView.pageIndex(from: scrollView)
        pageControl.currentPage = currentPageIndex
        _updateBottomButton(forPage: currentPageIndex)
    }
}

extension PopupTutorialUsingCollectionView: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return viewControllers.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: PopupTutorialCollectionViewCell.reuseIdentifier, for: indexPath) as? PopupTutorialCollectionViewCell)
            ?? PopupTutorialCollectionViewCell()
        cell.setup(viewControllers[indexPath.row], toParent: self)
        return cell
    }
}
