////
////  AlertService.swift
////  RxMemoTest
////
////  Created by PSD on 2020/05/20.
////  Copyright © 2020 koreacenter.com. All rights reserved.
////
//
//import UIKit
//import RxSwift
//
//protocol AlertActionType {
//    var title: String? { get }
//    var style: UIAlertAction.Style { get }
//}
//
//extension AlertActionType {
//    var style: UIAlertAction.Style {
//        return .default
//    }
//}
//
//protocol AlertServiceType: class {
//    func show<Action: AlertActionType>(
//        title: String?,
//        message: String?,
//        preferredStyle: UIAlertController.Style,
//        actions: [Action]
//    ) -> Observable<Action>
//}
//
//class AlertService: AlertActionType {
//    var title: String?   // ???????????????? 이게 없으면 에러가남 
//        
//    func show<Action: AlertActionType>(
//        title: String?,
//        message: String?,
//        preferredStyle: UIAlertController.Style,
//        actions: [Action]
//    ) -> Observable<Action> {
//        return Observable.create { observer in
//            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
//            for action in actions {
//                let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
//                    observer.onNext(action)
//                    observer.onCompleted()
//                }
//                alert.addAction(alertAction)
//            }
//            return Disposables.create {
//                alert.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
//}
