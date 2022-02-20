//
//  DanjiCellDelegateProxy.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/19.
//

import UIKit

import RxSwift
import RxCocoa

//final class RxDanjiCellDelegateProxy: DelegateProxy<DanjiCollectionCell, DanjiCollectionCellDelegate>, DelegateProxyType, DanjiCollectionCellDelegate {
//    static func registerKnownImplementations() {
//        self.register { (danjiCell) -> RxDanjiCellDelegateProxy in
//            RxDanjiCellDelegateProxy(parentObject: danjiCell, delegateProxy: self)
//        }
//    }
//    
//    static func currentDelegate(for object: DanjiCollectionCell) -> DanjiCollectionCellDelegate? {
//        return object.delegate
//    }
//    
//    static func setCurrentDelegate(_ delegate: DanjiCollectionCellDelegate?, to object: DanjiCollectionCell) {
//        object.delegate = delegate
//    }
//    
//    var activeMood: PublishRelay<Danji.Mood> = .init()
//}
