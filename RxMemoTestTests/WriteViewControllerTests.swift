//
//  WriteViewControllerTests.swift
//  RxMemoTestTests
//
//  Created by PSD on 2020/05/27.
//  Copyright © 2020 koreacenter.com. All rights reserved.
//

import XCTest
@testable import RxMemoTest

import RxSwift
import RxTest
import RxExpect
import RxCocoa

class WriteViewControllerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

 
    func testCreate() {
        let test = RxExpect()
        let serviceProvider = Service()
        let reactor = test.retain(WriteViewControllerReactor(service: serviceProvider, mode: .new))
        
//        test.input(reactor.action, [Recorded.next(100, .save)])
        
//        reactor.service.create(title: "Test1", content: "TestContent", date: "2020-05-27 16:00:00")
        test.input(reactor.action, [
            Recorded.next(100, .inputTitle("a")),
            Recorded.next(200, .inputTitle("b")),
            Recorded.next(300, .inputTitle("c")),
        ])
        
        test.assert(reactor.state.map { $0.title }) { events in
            XCTAssertEqual(events, [
                Recorded.next(0, ""),
                Recorded.next(100, "a"),
                Recorded.next(200, "b"),
                Recorded.next(300, "c")
            ])
        }
        
    }
}
