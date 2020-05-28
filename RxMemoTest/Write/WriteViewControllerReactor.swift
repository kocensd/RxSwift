//
//  WriteViewControllerReactor.swift
//  RxMemoTest
//
//  Created by PSD on 2020/05/14.
//  Copyright © 2020 koreacenter.com. All rights reserved.
//

import RxSwift
import ReactorKit

enum EditViewMode {
    case new
    case edit(Memo)
}

class WriteViewControllerReactor: Reactor {
    
    enum Action {
        case save
        case close(Bool)
        case inputTitle(String)
        case inputContent(String)
    }
    
    enum Mutation {
        case dismiss(Bool)
        case inputTitle(String)
        case inputContent(String)
    }
    
    struct State {
        var shouldDismiss: Bool = false
        
        var isEdit: Bool
        var title: String
        var content: String
        var date: String
        
        init(_ memo: Memo, _ bool: Bool) {
            self.title = memo.title
            self.content = memo.content
            self.date = memo.date
            self.isEdit = bool
        }
    }
    
    var initialState: State
    let service: ServiceProtocol
    let mode: EditViewMode
    
    init(service: ServiceProtocol, mode: EditViewMode) {
        self.service = service
        self.mode = mode
        
        switch mode {
        case .edit(let memo):
            self.initialState = State.init(memo, true)
        default:
            self.initialState = State.init(Memo(), false)
        }
    }
    
    func mutate(action: WriteViewControllerReactor.Action) -> Observable<WriteViewControllerReactor.Mutation> {
        switch action {
        case .save:
            switch self.mode {
            case .new:
                return service.create(title: currentState.title, content: currentState.content, date: Util().getCuttentTime())
                .map { _ in.dismiss(true) }
            case .edit:
                return service.update(title: currentState.title, content: currentState.content, date: currentState.date)
                .map { _ in.dismiss(true) }
            }
        case let .close(bool):
            return Observable.just(.dismiss(bool))
        case let .inputTitle(title):
            return Observable.just(.inputTitle(title))
        case let .inputContent(content):
            return Observable.just(.inputContent(content))
        }
    }
    
    func reduce(state: WriteViewControllerReactor.State, mutation: WriteViewControllerReactor.Mutation) -> WriteViewControllerReactor.State {
        var newState = state
        switch mutation {
        case let .dismiss(bool):
            newState.shouldDismiss = bool
        case let .inputTitle(title):
            newState.title = title
        case let .inputContent(content):
            newState.content = content
        }
        return newState
    }
    
}
