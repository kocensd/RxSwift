//
//  ServiceProvider.swift
//  RxMemoTest
//
//  Created by PSD on 2020/05/19.
//  Copyright © 2020 koreacenter.com. All rights reserved.
//

import RxSwift

enum MemoEvent {
    case create(Memo)
    case update
//    case delete([Memo])
}

protocol ServiceProtocol {
    var event: PublishSubject<MemoEvent> { get }
    
    func fetch() -> Observable<[Memo]>
    func create(title: String, content: String, date: String) -> Observable<Void>
    func update(title: String, content: String, date: String) -> Observable<Void>
    func delete(_ memo: Memo) -> Observable<[Memo]>
}

class Service: ServiceProtocol {
    var event = PublishSubject<MemoEvent>()
    
    func fetch() -> Observable<[Memo]> {
        let memos = DB.shared.load()
        return .just(memos)
    }
    
    //write -> read
    func create(title: String, content: String, date: String) -> Observable<Void> {
        let memo = Memo()
        memo.title = title
        memo.content = content
        memo.date = date
        DB.shared.save(memo)
        event.onNext(.create(memo))
        return .just(Void())
    }
    
    //write -> read
    func update(title: String, content: String, date: String) -> Observable<Void> {
        DB.shared.update(title, content, date)
        event.onNext(.update)
        return .just(Void())
    }
    
    //read -> read 굳이 transform을 해야하나?
    func delete(_ memo: Memo) -> Observable<[Memo]> {
        DB.shared.delete(memo)
        
        //기호 1번 event에 delete를 추가해줘서 transform으로 던지면서 return은 Void()형태로 하느냐
//        event.onNext(.delete(DB.shared.load()))
//        return .just(Void())
        
        //기호 2번
        return .just(DB.shared.load())
    }
}














