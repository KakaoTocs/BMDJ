//
//  ServiceProvider.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/29.
//

import Foundation

protocol ServiceProviderType: AnyObject {
//    var danjiRepository: DanjiRepository { get }
    var repository: Repository { get }
//    var memoRepository: MemoRepository { get }
    var danjiDataBaseService: DanjiDBService { get }
    var memoDataBaseService: MemoDBService { get }
}

final class ServiceProvider: ServiceProviderType {
    static let shared = ServiceProvider()
    
//    lazy var danjiRepository: DanjiRepository = DanjiRepository(provider: self)
    lazy var repository: Repository = Repository.shared
//    lazy var memoRepository: MemoRepository = MemoRepository(provider: self)
    lazy var danjiDataBaseService: DanjiDBService = DanjiDBService(provider: self)
    lazy var  memoDataBaseService: MemoDBService = MemoDBService(provider: self)
}
