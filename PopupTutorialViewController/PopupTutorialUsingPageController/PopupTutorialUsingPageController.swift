//
//  PopupTutorialViewController.swift
//  PopupTutorialViewController
//
//  Created by ha1f on 2018/10/11.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import UIKit

final class PopupTutorialUsingPageController: UIViewController {
    // MARK: - Nested types
    
    struct Dependency {
        var viewControllers: [UIViewController]
    }
    
    // MARK: - Properties
    
    @IBOutlet private var wrapperView: UIView! {
        didSet {
            wrapperView?.layer.cornerRadius = 5
        }
    }
    @IBOutlet private var closeButton: UIButton! {
        didSet {
            closeButton?.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        }
    }
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var pageControl: UIPageControl! {
        didSet {
            pageControl?.isUserInteractionEnabled = false
        }
    }
    
    private let _pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil)
        return pageViewController
    }()
    
    private let pageViewControllerDataSource: PredefinedPageViewControllerDataSource
    
    // MARK: - Initializers
    
    init(_ dependency: Dependency) {
        pageViewControllerDataSource = PredefinedPageViewControllerDataSource(viewControllers: dependency.viewControllers)
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
        
        addChild(_pageViewController)
        containerView.addSubview(_pageViewController.view)
        _pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _pageViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            _pageViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            _pageViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            _pageViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            ])
        _pageViewController.didMove(toParent: self)
        
        pageControl.numberOfPages = pageViewControllerDataSource.numberOfPages
        // Set to initial page
        if let pageIndex = pageViewControllerDataSource.setInitialPage(for: _pageViewController) {
            pageControl.currentPage = pageIndex
        }
        _pageViewController.dataSource = pageViewControllerDataSource
        _pageViewController.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private functions
    
    private func _updatePageControl(from pageViewController: UIPageViewController) {
        pageControl.currentPage = pageViewControllerDataSource.currentIndex(of: pageViewController)
    }
}

extension PopupTutorialUsingPageController {
    // MARK: - Targets
    
    @objc
    func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension PopupTutorialUsingPageController: UIPageViewControllerDelegate {
    // MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        _updatePageControl(from: pageViewController)
    }
}
