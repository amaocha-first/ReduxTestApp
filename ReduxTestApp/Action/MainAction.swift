//
//  ListAction.swift
//  ReduxTestApp
//
//  Created by coco j on 2019/07/01.
//  Copyright © 2019 amaocha. All rights reserved.
//

import Foundation
import ReSwift

extension MainState {
    
    enum mainAction: ReSwift.Action {
        case setTextFieldText(text: String)
    }
}
//struct MainAction: Action {
//    var text: String
//}
