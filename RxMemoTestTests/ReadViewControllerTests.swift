//
//  RxMemoTestTests.swift
//  RxMemoTestTests
//
//  Created by PSD on 2020/05/13.
//  Copyright © 2020 koreacenter.com. All rights reserved.
//

import XCTest
@testable import RxMemoTest

import RxSwift
import RxTest
import RxExpect
import RxCocoa

class ReadViewControllerTests: XCTestCase {

    let test = RxExpect()
    let serviceProvider = Service()
    lazy var reactor = test.retain(ReadViewControllerReactor(service: serviceProvider))
    
    //초기화코드 (객체인스터스 생성, DB초기화, 규칙작성)
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let memo = Memo()
        memo.title = "Test"
        memo.content = "TestContent"
        memo.date = "2020-05-27 20:15:30"
        DB.shared.save(memo)
    }

    //해체코드 (앱 초기상태로 변환)
    override func tearDown() {
        DB.shared.delete()
    }

    func testGetMemo() {
//        let test = RxExpect()
//        let serviceProvider = Service()
//        let reactor = test.retain(ReadViewControllerReactor(service: serviceProvider))
        
        test.input(reactor.action, [Recorded.next(100, .getMemos)])
        
        let taskCount = reactor.state.map { $0.memos.count }
        test.assert(taskCount) { events in
            XCTAssertEqual(events, [
                Recorded.next(0, 0),
                Recorded.next(100, 1)
            ])
        }
    }
    
    func testAllDelete() {
        test.input(reactor.action, [Recorded.next(100, .deleteAllMemos)])

        let taskCount = reactor.state.map { $0.memos.count }
        test.assert(taskCount) { events in
            XCTAssertEqual(events, [
                Recorded.next(0, 0),
                Recorded.next(100, 0)
            ])
        }
    }

    func testSelectDelete() {
        test.input(reactor.action, [
            Recorded.next(100, .getMemos),
            Recorded.next(200, .deleteMemu(IndexPath(row: 0, section: 0))) //삭제를 하기 위해서는 memos에 데이터가 있어야 하기 때문에 .getMemos를 먼저 실행시켜줘야한다.
        ])

        let taskCount = reactor.state.map { $0.memos.count }
        test.assert(taskCount) { events in
            XCTAssertEqual(events, [
                Recorded.next(0, 0),
                Recorded.next(100, 1),
                Recorded.next(200, 0)
            ])
        }
    }
}

























