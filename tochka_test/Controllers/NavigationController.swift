//
//  NavigationController.swift
//  tochka_test
//
//  Created by Станислав Коцарь on 28/07/2019.
//  Copyright © 2019 Станислав Коцарь. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewController = NewsTableViewController()
        setViewControllers([viewController], animated: false)
    }

}
