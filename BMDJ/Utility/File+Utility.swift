//
//  File+Utility.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/20.
//

import Foundation

final class FileUtility {
    
    static let rootDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let cacheDirectoryURL = rootDirectoryURL.appendingPathComponent("Cache", isDirectory: true)
    
    static let shared = FileUtility()
    
    private let fileManager = FileManager.default
    
    private init() {
        print(FileUtility.rootDirectoryURL.path)
        checkDirectory(url: FileUtility.cacheDirectoryURL)
    }
    
    func saveFile(at url: URL, data: Data) {
        do {
            try data.write(to: url)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func readFileToObject<Element: Codable>(at url: URL, _ type: Element.Type) -> Element? {
        do {
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode(type, from: data)
            return result
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func removeFile(at url: URL) {
        do {
            try fileManager.removeItem(at: url)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func createDirectory(at url: URL) {
        guard !fileManager.fileExists(atPath: url.absoluteString) else {
            return
        }
        
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func existDirectory(at url: URL) -> Bool {
        var isDirectory: ObjCBool = true
        if fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) {
            return isDirectory.boolValue
        } else {
            return false
        }
    }
    
    func existFile(at url: URL) -> Bool {
        return fileManager.fileExists(atPath: url.path)
    }
    
    func checkDirectory(url: URL) {
        if !existDirectory(at: url) {
            createDirectory(at: url)
        }
    }
    
    func checkDBFile(url: URL, data: Data) {
        if !existFile(at: url) {
            try? data.write(to: url)
        }
    }
}
