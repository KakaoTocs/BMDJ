//
//  DataBaseService.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/20.
//

import Foundation

import RxSwift
import RxCocoa

protocol DanjiDataBase {
    
}

class DanjiDBService: BaseService {
    
    private static let cacheFileURL = FileUtility.cacheDirectoryURL.appendingPathComponent("Danjis.txt")
    
    private let fileUtility = FileUtility.shared
    
    override init(provider: ServiceProviderType) {
        super.init(provider: provider)
        
        let danjis: [DanjiLite] = []
        let data = try! JSONEncoder().encode(danjis)
        fileUtility.checkDBFile(url: DanjiDBService.cacheFileURL, data: data)
    }
    
    func clear() {
        fileUtility.removeFile(at: DanjiDBService.cacheFileURL)
        let danjis: [DanjiLite] = []
        let data = try! JSONEncoder().encode(danjis)
        fileUtility.checkDBFile(url: DanjiDBService.cacheFileURL, data: data)
    }
    
    func all() -> [DanjiLite] {
        if let danjis = fileUtility.readFileToObject(at: DanjiDBService.cacheFileURL, [DanjiLite].self) {
            return danjis
        }
        return []
    }
    
    func write(danjis: [DanjiLite]) {
        if let data = try? JSONEncoder().encode(danjis) {
            fileUtility.saveFile(at: DanjiDBService.cacheFileURL, data: data)
        }
    }
}
