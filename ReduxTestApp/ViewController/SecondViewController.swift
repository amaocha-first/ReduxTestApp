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
    
    private var secondViewModel = SecondViewModel()
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Viewが立ち上がるたびにシングルトンである唯一のデータストアのmainStoreからプロパティを参照してくる
        self.textField.text = mainStore.state.main.text
        ///viewModelのインスタンス生成
        secondViewModel = SecondViewModel()
        ///イベントの購読をしてバインディング
        secondViewModel.passTextToMainView(textField: textField)
    }
    
}
