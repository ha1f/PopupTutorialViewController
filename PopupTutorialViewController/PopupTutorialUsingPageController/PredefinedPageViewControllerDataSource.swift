//
//  PredefinedPageViewControllerDataSource.swift
//  PopupTutorialViewController
//
//  Created by ha1f on 2018/10/12.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import UIKit

private extension Array {
    /// Safely extract value at given index from array using optional value.
    /// - parameter index: The index to get value.
    /// - returns: The element at index if exists, nil for the other cases.
    func elementOrNil(at index: Index) -> Element? {
        guard indices ~= index else {
            return nil
        }
        return self[index]
    }
}

/// DataSource for UIPageViewController to provide pre-defined viewController set.
final class PredefinedPageViewControllerDataSource: NSObject {
    let viewControllers: [UIViewController]
    
    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }
    
    var numberOfPages: Int {
        return viewControllers.count
    }
    
    /// Sets initial page for UIPageViewController.
    /// - parameter pageViewController: UIPageViewController to set initial page
    /// - returns: index of set ViewController
    @discardableResult
    func setInitialPage(for pageViewController: UIPageViewController) -> Int? {
        guard let firstViewController = viewControllers.first else {
            return nil
        }
        pageViewController.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        return 0
    }
    
    func currentIndex(of pageViewController: UIPageViewController) -> Int {
        guard let currentViewController = pageViewController.viewControllers?.first,
            let currentIndex = viewControllers.firstIndex(of: currentViewController) else {
                // error　cases
                return 0
        }
        return currentIndex
    }
}

extension PredefinedPageViewControllerDataSource: UIPageViewControllerDataSource {
    // MARK: - UIPageViewControllerDataSource
    
    // Note: Implementing rest UIPageViewControllerDataSource functions will show UIPageControl automatically,
    // but we cannot chagne the color of internal UIPageControl, we decided to add it manually.
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        return viewControllers.elementOrNil(at: currentIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        return viewControllers.elementOrNil(at: currentIndex + 1)
    }
}
