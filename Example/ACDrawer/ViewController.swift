//
//  ViewController.swift
//  ACDrawer
//
//  Created by Christian Ampe on 10/13/2019.
//  Copyright (c) 2019 Christian Ampe. All rights reserved.
//

import ACDrawer

class ViewController: UIViewController {
    
    private var drawerViewController = ACDrawerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        drawerViewController.view.backgroundColor = .darkGray
        drawerViewController.add(toParent: self, height: (0.1, 0.9), opacity: (0.0, 0.9))
    }

}

