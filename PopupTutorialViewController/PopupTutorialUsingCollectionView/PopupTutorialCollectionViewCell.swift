//
//  PopupTutorialCollectionViewCell.swift
//  PopupTutorialViewController
//
//  Created by ha1f on 2018/10/15.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import UIKit

final class PopupTutorialCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PopupTutorialCollectionViewCell"
    
    /// ViewController controlling contentView.
    /// This instance must be managed by the parent ViewController.
    private weak var _contentViewController: UIViewController?
    
    /// Setup cell using ViewController.
    /// Please pass ViewController controlling this collectionView to set as parent.
    ///
    /// - parameter viewController: UIViewController to add its view as content.
    /// - parameter parentViewController: UIViewController to set to viewController's parent.
    func setup(_ viewController: UIViewController, toParent parentViewController: UIViewController) {
        parentViewController.addChild(viewController)
        
        contentView.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        
        viewController.didMove(toParent: parentViewController)
        
        _contentViewController = viewController
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let viewController = _contentViewController {
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
}
