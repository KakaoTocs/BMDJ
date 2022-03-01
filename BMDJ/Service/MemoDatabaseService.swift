//
//  MemoDatabaseService.swift
//  BMDJ
//
//  Created by 김진우 on 2021/07/04.
//

import Foundation

import RxSwift
import RxCocoa

protocol MemoDataBase {
    
}

class MemoDBService: BaseService {
    
    private static let cacheFileURL = FileUtility.cacheDirectoryURL.appendingPathComponent("Memos.txt")
    
    private let fileUtility = FileUtility.shared
    
    override init(provider: ServiceProviderType) {
        super.init(provider: provider)
        
        let memos: [Memo] = []
        let data = try! JSONEncoder().encode(memos)
        fileUtility.checkDBFile(url: MemoDBService.cacheFileURL, data: data)
    }
    
    func clear() {
        fileUtility.removeFile(at: MemoDBService.cacheFileURL)
        let memos: [Memo] = []
        let data = try! JSONEncoder().encode(memos)
        fileUtility.checkDBFile(url: MemoDBService.cacheFileURL, data: data)
    }
    
    func all() -> [Memo] {
        if let memos = fileUtility.readFileToObject(at: MemoDBService.cacheFileURL, [Memo].self) {
            return memos
        }
        return []
    }
    
    func write(memos: [Memo]) {
        if let data = try? JSONEncoder().encode(memos) {
            fileUtility.saveFile(at: MemoDBService.cacheFileURL, data: data)
        }
    }
}
