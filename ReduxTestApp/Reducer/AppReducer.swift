//
//  AppReducer.swift
//  ReduxTestApp
//
//  Created by coco j on 2019/07/01.
//  Copyright © 2019 amaocha. All rights reserved.
//

import Foundation
import ReSwift

func AppReducer(action: Action, state: AppState?) -> AppState {
    return AppState(
        main: MainState.mainReducer(action: action, state: state?.main)
    )
}
