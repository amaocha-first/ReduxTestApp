//
//  ListReducer.swift
//  ReduxTestApp
//
//  Created by coco j on 2019/07/01.
//  Copyright © 2019 amaocha. All rights reserved.
//

import Foundation
import ReSwift

extension MainState {
    
    static func mainReducer(action: Action, state: MainState?) -> MainState {
        var state = state ?? MainState(text: "")
        
        var newState = state
        var mainState = state
        
        guard let action = action as? MainState.mainAction else { return state }
        
        switch action {
        case let .setTextFieldText(text):
            mainState.text = text
        default:
            break
        }
        newState = mainState
        return newState
    }
}
