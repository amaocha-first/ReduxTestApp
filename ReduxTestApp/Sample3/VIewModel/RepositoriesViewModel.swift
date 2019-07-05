//
//  RepositoriesViewModel.swift
//  ReduxTestApp
//
//  Created by coco j on 2019/07/06.
//  Copyright © 2019 amaocha. All rights reserved.
//

import Foundation
import ObjectMapper
import RxAlamofire
import RxSwift
import RxCocoa

class RepositoriesViewModel {
    
    lazy var rx_repositories: Driver<[Repository]> = self.fetchRepositories()
    
    private var repositoryName: Observable<String>
    
    init(withNameObservable: Observable<String>) {
        self.repositoryName = withNameObservable
    }
    
    private func fetchRepositories() -> Driver<[Repository]> {
        
        return repositoryName
            
            .subscribeOn(MainScheduler.instance)
            .do(onNext: { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            })
            
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest { text in
                
                return RxAlamofire
                    .requestJSON(.get, "https://api.github.com/users/\(text)/repos")
                    .debug()
                    .catchError { error in
                        return Observable.never()
                }
            }
            
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { (response, json) -> [Repository] in
                if let repos = Mapper<Repository>().mapArray(JSONObject: json) {
                    return repos
                } else {
                    return []
                }
            }
            
            .observeOn(MainScheduler.instance)
            .do(onNext: { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            .asDriver(onErrorJustReturn: [])
    }
}
