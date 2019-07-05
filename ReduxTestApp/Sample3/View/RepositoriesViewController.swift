//
//  RepositoriesViewController.swift
//  ReduxTestApp
//
//  Created by coco j on 2019/07/06.
//  Copyright © 2019 amaocha. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class RepositoriesViewContoller: UIViewController {
    
    @IBOutlet weak var nameSearchBar: UISearchBar!
    @IBOutlet weak var repositoryListTableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var repoViewModel: RepositoriesViewModel!
    
    let disposeBag = DisposeBag()
    
    var rx_searchBarText: Observable<String> {
        return  nameSearchBar.rx.text
            .filter { $0 != nil }
            .map { $0! }
            .filter { $0.count > 0 }
        .debounce(0.5, scheduler: MainScheduler.instance)
        .distinctUntilChanged()
    }
    
    override func viewDidLoad() {
        setupUI()
        setupRx()
    }
    
    func setupRx() {
        repoViewModel = RepositoriesViewModel(withNameObservable: rx_searchBarText)
        
        repoViewModel.rx_repositories.drive(repositoryListTableView.rx.items) { (tableView, i, repository) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: IndexPath(row: i, section: 0))
            cell.textLabel?.text = repository.name
            cell.detailTextLabel?.text = repository.html_url
            return cell
        }.disposed(by: disposeBag)
        
        repoViewModel.rx_repositories.drive(onNext: { repositories in
            
            //データ取得ができなかった場合だけ処理をする
            if repositories.count == 0 {
                
                let alert = UIAlertController(title: ":(", message: "No repositories for this user.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                //ポップアップを閉じる
                if self.navigationController?.visibleViewController is UIAlertController != true {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }).disposed(by: disposeBag)
        
    }
    
    func setupUI() {
        
        /**
         * 2017/01/14: 補足事項
         *
         * Notification周りやGesture周りもRxでの記載が可能
         *
         * (記載例)
         * ----------
         * Notification:
         * ----------
         * NotificationCenter.default.rx.notification(.UIKeyboardWillChangeFram) ...
         * NotificationCenter.default.rx.notification(.UIKeyboardWillHide) ...
         *
         * ----------
         * Gesutre:
         * ----------
         * let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped(_:)))
         * let didTap = stap.rx.event ...
         *
         * → NotificationやGestureに関しても、このような記述をすることでObservableとして利用可能！
         *
         * (さらに参考になった資料)【RxSwift入門】普段使ってるこんなんもRxSwiftで書けるんよ
         * http://qiita.com/ikemai/items/8d3efcc71ea9db340484
         *
         * RxKeyboard:
         * https://github.com/RxSwiftCommunity/RxKeyboard/blob/master/Sources/RxKeyboard.swift
         */
        
        //テーブルビューにGestureRecognizerを付与する
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped(_:)))
        repositoryListTableView.addGestureRecognizer(tap)
        
        //キーボードのイベントを監視対象にする
        //Case1. キーボードを開いた場合のイベント
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        //Case2. キーボードを閉じた場合のイベント
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    //キーボード表示時に発動されるメソッド
    @objc func keyboardWillShow(_ notification: Notification) {
        
        //キーボードのサイズを取得する（英語のキーボードが基準になるので日本語のキーボードだと少し見切れてしまう）
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        //一覧表示用テーブルビューのAutoLayoutの制約を更新して高さをキーボード分だけ縮める
        tableViewBottomConstraint.constant = keyboardFrame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.view.updateConstraints()
        })
    }
    
    //キーボード非表示表示時に発動されるメソッド
    @objc func keyboardWillHide(_ notification: Notification) {
        
        //一覧表示用テーブルビューのAutoLayoutの制約を更新して高さを元に戻す
        tableViewBottomConstraint.constant = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.updateConstraints()
        })
    }
    
    //メモリ解放時にキーボードのイベント監視対象から除外する
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //テーブルビューのセルタップ時に発動されるメソッド
    @objc func tableTapped(_ recognizer: UITapGestureRecognizer) {
        
        //どのセルがタップされたかを探知する
        let location = recognizer.location(in: repositoryListTableView)
        let path = repositoryListTableView.indexPathForRow(at: location)
        
        //キーボードが表示されているか否かで処理を分ける
        if nameSearchBar.isFirstResponder {
            
            //キーボードを閉じる
            nameSearchBar.resignFirstResponder()
            
        } else if let path = path {
            
            //タップされたセルを中央位置に持ってくる
            repositoryListTableView.selectRow(at: path, animated: true, scrollPosition: .middle)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
