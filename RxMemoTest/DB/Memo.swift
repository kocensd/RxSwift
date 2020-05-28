//
//  Memo.swift
//  RxMemoTest
//
//  Created by PSD on 2020/05/13.
//  Copyright © 2020 koreacenter.com. All rights reserved.
//

import RealmSwift

class Memo: Object {
    @objc dynamic var title = ""
    @objc dynamic var content = ""
    @objc dynamic var date = ""
}
