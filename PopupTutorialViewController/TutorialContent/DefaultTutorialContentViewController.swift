//
//  DefaultTutorialContentViewController.swift
//  PopupTutorialViewController
//
//  Created by ha1f on 2018/10/11.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import UIKit

final class DefaultTutorialContentViewController: UIViewController {
    struct Dependency {
        var image: UIImage?
        var title: String?
        var description: String?
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    let dependency: Dependency
    
    init(_ dependency: Dependency) {
        self.dependency = dependency
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = dependency.image ?? UIImage(named: "fish.jpg")
        titleLabel.text = dependency.title
        descriptionLabel.text = dependency.description
    }
}
