//
//  MainMiddleware.swift
//  ReduxTestApp
//
//  Created by coco j on 2019/07/02.
//  Copyright © 2019 amaocha. All rights reserved.
//

import Foundation
import ReSwift

let mainMiddleware: ReSwift.Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            print("🔥 [Action] \(action)")
            return next(action)
        }
    }
}
