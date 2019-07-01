//
//  ViewController.swift
//  ReduxTestApp
//
//  Created by coco j on 2019/07/01.
//  Copyright © 2019 amaocha. All rights reserved.
//

import UIKit
import ReSwift

protocol ViewControllerTransitionDelegate: class {
    func push()
}

final class ViewController: UIViewController {

    weak var transitionDelegate: ViewControllerTransitionDelegate?
    
    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainStore.subscribe(self) {
            $0.select {
                $0.main
                }.skipRepeats {
                    $0.text == $1.text
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 監視削除
        mainStore.unsubscribe(self)
    }
    
    @IBAction func event(_ sender: Any) {
        self.transitionDelegate?.push()
    }
}

extension ViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = MainState
    // NOTE: 監視しているの値が変更されてた場合に呼ばれる
    func newState(state: MainState) {
        self.label.text = state.text ?? ""
    }
}

