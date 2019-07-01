//
//  ApplicationCoordinator.swift
//  ReduxTestApp
//
//  Created by coco j on 2019/07/01.
//  Copyright © 2019 amaocha. All rights reserved.
//

import UIKit

final class ApplicationCoordinator {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    public func start() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC") as? ViewController else {
            return
        }
        vc.transitionDelegate = self
        self.window.rootViewController = UINavigationController(rootViewController: vc)
        self.window.makeKeyAndVisible()
    }
}

extension ApplicationCoordinator: ViewControllerTransitionDelegate {
    func push() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondVC") as? SecondViewController  else {
            return
        }
        (self.window.rootViewController as? UINavigationController)?.pushViewController(vc, animated: true)
    }
}
