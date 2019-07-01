//
//  SecondViewController.swift
//  ReduxTestApp
//
//  Created by coco j on 2019/07/01.
//  Copyright © 2019 amaocha. All rights reserved.
//
import UIKit
import ReSwift

final class SecondViewController: UIViewController {
    
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.text = mainStore.state.main.text
    }
    @IBAction func finishButton(_ sender: Any) {
        mainStore.dispatch(MainState.mainAction.setTextFieldText(text: textField.text!))
    }
}

extension SecondViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // NOTE: dispatch関数を使用して、Actionを送信する。対応するReduserが検知し、新たなStateが作成され更新されます。
        
    }
}
