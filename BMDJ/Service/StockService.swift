//
//  StockService.swift
//  BMDJ
//
//  Created by 김진우 on 2021/12/30.
//

import Foundation

final class StockService {
    
    static let shared = StockService()
    
    private var list: [Stock] = []
    
    private init() {
        setup()
    }
    
    private func setup() {
        DispatchQueue.global().async {
            let stocks = FIBDatabaseService.shared.requestStock()
            if let stocks = stocks {
                self.list = stocks
            }
        }
    }
    
    func getName(form code: String) -> String? {
        if !code.isEmpty,
           let stock = list.first(where: { $0.code == code }) {
            return stock.name
        }
        return nil
    }
    
    func search(text: String) -> [Stock] {
        var result = searchName(text: text)
        var resultCode = searchCode(text: text)
        for stock in resultCode {
            if !result.contains(stock) {
                result.append(stock)
            }
        }
        return result
    }
    
    private func searchName(text: String) -> [Stock] {
        var basicResult = list.filter { $0.name.contains(text) }
        let upperResult = list.filter { $0.name.uppercased().contains(text.uppercased()) }
        let lowerResult = list.filter { $0.name.lowercased().contains(text.lowercased()) }
        
        basicResult.append(contentsOf: upperResult.filter { !basicResult.contains($0) })
        basicResult.append(contentsOf: lowerResult.filter { !basicResult.contains($0) })
        return basicResult
    }
    
    private func searchCode(text: String) -> [Stock] {
        return list.filter { $0.code.contains(text) }
    }
}
