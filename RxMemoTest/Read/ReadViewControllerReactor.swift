//
//  ReadViewControllerReactor.swift
//  RxMemoTest
//
//  Created by PSD on 2020/05/13.
//  Copyright © 2020 koreacenter.com. All rights reserved.
//

import ReactorKit
import RxSwift

class ReadViewControllerReactor: Reactor {
    
    //사용자 액션
    enum Action {
        case getMemos
        case deleteMemu(IndexPath)
        case deleteAllMemos
    }
    
    //상태변화 (비동기 or API호출 등)
    enum Mutation {
        case getMemos([Memo])
        case present(Bool)
        case createMemo(Memo)
        case updateMemo
        case deleteMemos([Memo])
    }
    
    //현재뷰의 상태
    struct State {
        var memos: [Memo] = []
        var shouldPresent: Bool = false
        var userName: String = ""
    }
    
    let initialState: State
    let service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.initialState = State()
        self.service = service
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = service.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .create(let memo):
                return .just(.createMemo(memo))
            case .update:
                return .just(.updateMemo)
//            case .delete(let memos):
//                return .just(.deleteMemos(memos))
            }
        }
        return Observable.merge(mutation, eventMutation)
    }
    
    func mutate(action: ReadViewControllerReactor.Action) -> Observable<ReadViewControllerReactor.Mutation> {
        switch action {
        case .getMemos:
            return service.fetch().map { .getMemos($0) }
        case let .deleteMemu(indexPath):
            let memo = currentState.memos[indexPath.row]
            //기호 1번 transfrom으로 던져서 reduce로 가느냐
//            return service.delete(memo).flatMap { _ in Observable.empty() }
            
            //기호 2번 여기서 받은걸 바로 reduce로 가느냐 차이
            return service.delete(memo).map { memos in
                return .deleteMemos(memos)
            }
        case .deleteAllMemos:
            DB.shared.delete()
            return Observable.just(.getMemos(DB.shared.load()))
        }
    }
    
    func reduce(state: ReadViewControllerReactor.State, mutation: ReadViewControllerReactor.Mutation) -> ReadViewControllerReactor.State {
        var newState = state
        switch mutation {
        case let .getMemos(memo):
            newState.memos = memo
        case let .present(bool):
            newState.shouldPresent = bool
        case .createMemo(let memo):
            var newMemo = currentState.memos
            newMemo.append(memo)
            newState.memos = newMemo
        case .updateMemo:
            break
        case .deleteMemos(let memos):
            newState.memos = memos
        }
        return newState
    }
    
    func writeCreating() -> WriteViewControllerReactor {
        return WriteViewControllerReactor(service: service, mode: .new)
    }
    
    func updateCreating(_ memo: Memo) -> WriteViewControllerReactor {
        return WriteViewControllerReactor(service: self.service, mode: .edit(memo))
    }
}
