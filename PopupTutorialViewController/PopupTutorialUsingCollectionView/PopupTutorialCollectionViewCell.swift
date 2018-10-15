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
    private weak var _contentViewController: UIViewController?
    
    /// Please pass ViewController controlling this collectionView to set as parent.
    func setup(_ viewController: UIViewController, toParent parentViewController: UIViewController) {
        parentViewController.addChild(viewController)
        
        addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
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
