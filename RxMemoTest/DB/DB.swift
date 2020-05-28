//
//  DB.swift
//  RxMemoTest
//
//  Created by PSD on 2020/05/13.
//  Copyright © 2020 koreacenter.com. All rights reserved.
//

import RealmSwift
import RxSwift

class DB {
    static var shared = DB()
    var realm = try! Realm()
//    var memos: BehaviorSubject<[Memo]> = BehaviorSubject(value: [])
    
    func save(_ memo: Memo) {
        try! realm.write {
            realm.add(memo)
        }
    }
    
    func load() -> [Memo] {
        let data = realm.objects(Memo.self)
        return Array(data)
//        return NSArray(array: Array(data))
    }
    
    func update(_ title: String, _ content: String, _ date: String) {
        if let memo = realm.objects(Memo.self).filter("date='\(date)'").first {
            try! realm.write { 
                memo.title = title
                memo.content = content
                memo.date = Util().getCuttentTime()
            }
        }
    }
    
    func delete(_ memo: Memo) {
        if let deleteMemo = realm.objects(Memo.self).filter("date='\(memo.date)'").first {
            try! realm.write {
                realm.delete(deleteMemo)
            }
        }
    }
    
    func delete() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("\(error)")
        }
    }
    
}
