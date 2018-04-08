//
//  NavigationRouter.swift
//  SwivlTestApp
//
//  Created by Pavlo Deynega on 08.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import UIKit

class NavigationRouter: NSObject {
    
    let navigationController: UINavigationController
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
