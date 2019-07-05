//
//  UserNameViewController.swift
//  ReduxTestApp
//
//  Created by coco j on 2019/07/04.
//  Copyright © 2019 amaocha. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserNameViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        //基本形で書いてみると・・・
//        userNameTextField.rx.text.subscribe(onNext: {[weak self] text in
//            self?.validationLabel.text = text!
//        }).disposed(by: disposeBag)
//
        //簡略化して書いてみると・・・
//        userNameTextField.rx.text.bind(to: validationLabel.rx.text).disposed(by: disposeBag)

        //ViewModelでやってみると・・・
        ///ViewModel内で処理するためのobservableと実際のViewのobservableをひもづける
        let input = viewModelInput(userNameTextField: userNameTextField.rx.text.asObservable(), validationLabel: validationLabel)
        ///それを元にViewModelのインスタンス生成
        let viewModel = UserNameViewModel()
        viewModel.setup(input: input)
        viewModel.outputs?.textDriver.drive(validationLabel.rx.text).disposed(by: disposeBag)
    }

}
