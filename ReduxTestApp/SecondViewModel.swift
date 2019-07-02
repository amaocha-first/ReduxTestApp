//
//  MainViewModel.swift
//  ReduxTestApp
//
//  Created by coco j on 2019/07/01.
//  Copyright © 2019 amaocha. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift
import RxCocoa
import RxOptional

class SecondViewModel {
    
    var textObservable: Observable<String> {
        return textRelay.asObservable()
    }
    var labelObservable: UILabel?
    
    private let textRelay = PublishRelay<String>()
}
