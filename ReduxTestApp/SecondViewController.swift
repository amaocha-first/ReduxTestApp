//
//  SecondViewController.swift
//  ReduxTestApp
//
//  Created by coco j on 2019/07/01.
//  Copyright © 2019 amaocha. All rights reserved.
//
import UIKit
import ReSwift
import RxSwift
import RxCocoa

final class SecondViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var secondViewModel = SecondViewModel()

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Viewが立ち上がるたびにシングルトンである唯一のデータストアのmainStoreからプロパティを参照してくる
        self.textField.text = mainStore.state.main.text
        
        ///viewModelのインスタンス生成
        secondViewModel = SecondViewModel()
        
        finishButton.rx.tap.subscribe({ [weak self] _ in
            guard let selfVC = self else { return }
            mainStore.dispatch(MainState.mainAction.setTextFieldText(text: selfVC.textField.text!))
        })
    }
    
}
