//
//  ViewController.swift
//  ReduxTestApp
//
//  Created by coco j on 2019/07/01.
//  Copyright © 2019 amaocha. All rights reserved.
//

import UIKit
import ReSwift
import RxSwift
import RxCocoa

protocol ViewControllerTransitionDelegate: class {
    func push()
}

final class ViewController: UIViewController {

    weak var transitionDelegate: ViewControllerTransitionDelegate?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var transitionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///ボタンがタップされたら画面遷移するという関係性を宣言
        transitionButton.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.transitionDelegate?.push()
        })
    }
    
    ///監視登録
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

    ///監視削除
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainStore.unsubscribe(self)
    }
}

///状態変化した時にViewの更新をする
extension ViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = MainState
    // NOTE: 監視しているの値が変更されてた場合に呼ばれる
    func newState(state: MainState) {
        self.label.text = state.text ?? ""
    }
}

