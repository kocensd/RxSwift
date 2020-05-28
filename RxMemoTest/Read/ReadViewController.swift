//
//  ViewController.swift
//  RxMemoTest
//
//  Created by PSD on 2020/05/13.
//  Copyright © 2020 koreacenter.com. All rights reserved.
//

import UIKit
import RealmSwift
import ReactorKit
import RxDataSources
import RxViewController
import RxSwift
import RxCocoa


class ReadViewController: UIViewController, StoryboardView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var writeButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //일반적으로보기 외부에 설정됩니다. -> SceneDelegate로 옮겼음 (Dependency Injection)
//        self.reactor = ReadViewControllerReactor()
    }
    
    func bind(reactor: ReadViewControllerReactor) {
        
        //action
        Observable.just(Void())
            .map { Reactor.Action.getMemos }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        deleteButton.rx.tap
            .map { Reactor.Action.deleteAllMemos }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .map( Reactor.Action.deleteMemu )
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        writeButton.rx.tap
            .map(reactor.writeCreating)
            .subscribe(onNext: { [weak self] writeReactor in
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WriteViewController") as? WriteViewController {
                    vc.reactor = writeReactor
                    self?.present(vc, animated: true, completion: nil)
                }
            }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Memo.self)
            .map(reactor.updateCreating)
            .subscribe(onNext: { [weak self] writeReactor in
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WriteViewController") as? WriteViewController {
                    vc.reactor = writeReactor
                    self?.present(vc, animated: true, completion: nil)
                }
            }).disposed(by: disposeBag)
        
        //State
        reactor.state.map { $0.memos }
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { indexPath, memos, cell in
                cell.textLabel?.text = memos.title
                cell.detailTextLabel?.text = memos.date
        }.disposed(by: disposeBag)
    }
}

