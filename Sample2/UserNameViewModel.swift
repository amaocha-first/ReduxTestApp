////
////  UserNameViewModel.swift
////  ReduxTestApp
////
////  Created by coco j on 2019/07/04.
////  Copyright © 2019 amaocha. All rights reserved.
////

import Foundation
import RxSwift
import RxCocoa
import RxOptional

struct viewModelInput {
    let userNameTextField: Observable<String?>
    let validationLabel: UILabel?
}

protocol ViewModelOutput {
    var textDriver: Driver<String?> { get }
}

protocol ViewModelType {
    var outputs: ViewModelOutput? { get }
    func setup(input: viewModelInput)
}

class UserNameViewModel: ViewModelType {
    
    var outputs: ViewModelOutput?
    
    private let userNameRelay = BehaviorRelay<String>(value: "DefaultName")

    let disposeBag = DisposeBag()
    
    init() {
        self.outputs = self
    }
    
    func setup(input: viewModelInput) {
        
//        input.userNameTextField.subscribe(onNext: {[weak self] text in
//            print(text)
//            self!.incrementText(input_text: text!)
//        }).disposed(by: disposeBag)
        
        input.userNameTextField.map { "\($0!)さんですね"}.bind(to: input.validationLabel!.rx.text).disposed(by: disposeBag)
    }
    
    ///入力に対する加工をすることもできる
    private func incrementText(input_text: String) {
        let text = input_text + "さん"
        userNameRelay.accept(text)
        
    }
}

extension UserNameViewModel: ViewModelOutput {
    
    var textDriver: Driver<String?> {
        return  userNameRelay.map  { "\($0)ですね"}.asDriver(onErrorJustReturn: nil)
    }
    
    
}
