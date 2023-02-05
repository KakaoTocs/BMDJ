//
//  DanjiFetchMetaInfoService.swift
//  BMDJ
//
//  Created by 김진우 on 2023/02/05.
//

import Foundation

final class DanjiFetchMetaInfoService: DanjiFetchMetaInfoServiceProtocol {
    // MARK: - Private Static Property
    private static let cacheFileURL = FileUtility.cacheDirectoryURL.appendingPathComponent("DanjiFetcher.txt")
    
    // MARK: - Private Property
    private let fileUtility = FileUtility.shared
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"
        return dateFormatter
    }()
    
    // MARK: - Initializer
    init() {
    }
    
    // MARK: - Interface
    func readDate() -> DateResult {
        guard let metaInfo = fileUtility.readFileToObject(at: DanjiFetchMetaInfoService.cacheFileURL, DanjiFetchMetaInfo.self) else {
            return .failure(.result)
        }
        guard let date = dateFormatter.date(from: metaInfo.updateDate) else {
            return .failure(.scheme)
        }
        return .success(date)
    }
    
    func updateDate() {
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let metaInfo: DanjiFetchMetaInfo = .init(updateDate: dateString)
        
        if let metaInfoData = try? JSONEncoder().encode(metaInfo) {
            fileUtility.saveFile(at: DanjiFetchMetaInfoService.cacheFileURL, data: metaInfoData)
        }
    }
    
    // MARK: - Private Method
    private func readMetaInfo() {
    }
}
