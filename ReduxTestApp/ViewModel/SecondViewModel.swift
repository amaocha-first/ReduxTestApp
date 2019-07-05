//
//  MainViewModel.swift
//  ReduxTestApp
//
//  Created by coco j on 2019/07/01.
//  Copyright © 2019 amaocha. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SecondViewModel {
    
    var textObservable: Observable<String> {
        return textRelay.asObservable()
    }
    
    private let textRelay = PublishRelay<String>()
    
    private let disposeBag = DisposeBag()
    
    ///イベントの購読
    func passTextToMainView(textField: UITextField) {
        textField.rx.text.subscribe({ [weak self] _ in
            mainStore.dispatch(MainState.mainAction.setTextFieldText(text: textField.text!))
        }).disposed(by: disposeBag)
    }
}
