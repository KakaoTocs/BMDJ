//
//  DatabaseService.swift
//  BMDJ
//
//  Created by 김진우 on 2022/03/09.
//

import Foundation

final class DatabaseService {
    
    static let shared = DatabaseService()
    
    private static let danjiCacheFileURL = FileUtility.cacheDirectoryURL.appendingPathComponent("Danjis.txt")
    private static let memoCacheFileURL = FileUtility.cacheDirectoryURL.appendingPathComponent("Memos.txt")
    
    private let fileUtility = FileUtility.shared
    
    private(set) var danjis: [DanjiLite] = []
    private(set) var memos: [Memo] = []
    
    private init() {
        let danjis: [DanjiLite] = []
        let danjisData = try! JSONEncoder().encode(danjis)
        fileUtility.checkDBFile(url: DatabaseService.danjiCacheFileURL, data: danjisData)
        
        let memos: [Memo] = []
        let memosData = try! JSONEncoder().encode(memos)
        fileUtility.checkDBFile(url: DatabaseService.memoCacheFileURL, data: memosData)
        
        setup()
    }
    
    private func setup() {
        danjis = danjiAll()
        memos = memoAll()
    }
    
    func danjiAll() -> [DanjiLite] {
        if let danjis = fileUtility.readFileToObject(at: DatabaseService.danjiCacheFileURL, [DanjiLite].self) {
            return danjis
        }
        return []
    }
    
    func danjiClear() {
        fileUtility.removeFile(at: DatabaseService.danjiCacheFileURL)
        let danjis: [DanjiLite] = []
        let data = try! JSONEncoder().encode(danjis)
        fileUtility.checkDBFile(url: DatabaseService.danjiCacheFileURL, data: data)
    }
    
    func danjiWrite(danjis: [DanjiLite]) -> Bool {
        if let data = try? JSONEncoder().encode(danjis) {
            fileUtility.saveFile(at: DatabaseService.danjiCacheFileURL, data: data)
            self.danjis = danjiAll()
            return true
        }
        return false
    }
    
    func memoAll() -> [Memo] {
        if let memos = fileUtility.readFileToObject(at: DatabaseService.memoCacheFileURL, [Memo].self) {
            return memos
        }
        return []
    }
    
    func memoClear() {
        fileUtility.removeFile(at: DatabaseService.memoCacheFileURL)
        let memos: [Memo] = []
        let data = try! JSONEncoder().encode(memos)
        fileUtility.checkDBFile(url: DatabaseService.memoCacheFileURL, data: data)
    }
    
    func memoWrite(memos: [Memo]) -> Bool {
        if let data = try? JSONEncoder().encode(memos) {
            fileUtility.saveFile(at: DatabaseService.memoCacheFileURL, data: data)
            self.memos = memoAll()
            return true
        }
        return false
    }
}
