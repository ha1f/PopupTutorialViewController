//
//  ViewController.swift
//  PopupTutorialViewController
//
//  Created by ha1f on 2018/10/11.
//  Copyright © 2018年 ha1f. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let button = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.setTitle("Show Tutorial", for: .normal)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            ])
        button.addTarget(self, action: #selector(didTapShowTutorialButton), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _showTutorial()
    }
    
    @objc
    private func didTapShowTutorialButton() {
        _showTutorial()
    }
    
    private func _showTutorial() {
        let viewController = PopupTutorialUsingCollectionView(.init(viewControllers: [
            DefaultTutorialContentViewController(.init(image: nil, title: "page1", description: "desc1")),
            DefaultTutorialContentViewController(.init(image: nil, title: "page2", description: "desc2desc2desc2desc2desc2desc2desc2desc2desc2desc2desc2desc2desc2desc2desc2desc2desc2desc2")),
            DefaultTutorialContentViewController(.init(image: nil, title: "page3", description: "desc3")),
            DefaultTutorialContentViewController(.init(image: nil, title: "page4", description: "desc4"))
            ]))
        present(viewController, animated: true, completion: nil)
    }

}

