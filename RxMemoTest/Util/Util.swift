//
//  Util.swift
//  RxMemoTest
//
//  Created by PSD on 2020/05/14.
//  Copyright © 2020 koreacenter.com. All rights reserved.
//

import UIKit

class Util {

    func getCuttentTime() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
