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
    
    private let viewControllers: [UIViewController]
    
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // update itemSize to match with the size of collectionView.
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = collectionView.bounds.size
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension PopupTutorialUsingCollectionView {
    // MARK: - Targets
    
    @objc
    func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension PopupTutorialUsingCollectionView: UICollectionViewDelegate {
    // MARK: - UICollectionViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
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
