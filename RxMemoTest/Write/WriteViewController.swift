//
//  WriteViewController.swift
//  RxMemoTest
//
//  Created by PSD on 2020/05/14.
//  Copyright © 2020 koreacenter.com. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

class WriteViewController: UIViewController, StoryboardView {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.reactor = WriteViewControllerReactor()
    }
    
    func bind(reactor: WriteViewControllerReactor) {
        self.saveButton.rx.tap
            .map { Reactor.Action.save }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.closeButton.rx.tap
            .map { Reactor.Action.close(true) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.titleField.rx.text.orEmpty
            .skip(1)
            .map(Reactor.Action.inputTitle)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.contentTextView.rx.text.orEmpty
            .skip(1)
            .map(Reactor.Action.inputContent)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable().map { $0.shouldDismiss }
        .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.title }
            .bind(to: self.titleField.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.content }
            .bind(to: self.contentTextView.rx.text)
            .disposed(by: self.disposeBag)
    }
}
