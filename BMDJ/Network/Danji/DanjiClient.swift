//
//  DanjiClient.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/14.
//

import Foundation

import RxSwift
import Alamofire
import RxAlamofire

final class DanjiClient {
    
    static let shared = DanjiClient()
    
    private let decoder = JSONDecoder()
    let disposeBag = DisposeBag()
    
    private init() {}
    
    func lowLevelAll() -> [Danji]? {
        let semaphore = DispatchSemaphore(value: 0)
        var result: [Danji]?
        AF.request(DanjiRouter.all)
            .responseData { [weak self] response in
                if let data = response.data,
                   let danjis = try? self?.decoder.decode(NetworkResult<[Danji]>.self, from: data) {
                    result = danjis.data
                } else {
                    result = nil
                }
                semaphore.signal()
            }
        semaphore.wait()
        return result
    }
    
    func all() -> Observable<[Danji]> {
        return RxAlamofire.request(DanjiRouter.all)
            .data()
            .decode(type: NetworkResult<[Danji]>.self, decoder: decoder)
            .map { $0.data }
            .map { $0 }
    }
    
    func plant(danji: DanjiCreate) -> Observable<Danji> {
        return RxAlamofire.request(DanjiRouter.plant(danji: danji))
            .validate(statusCode: 200..<300)
            .data()
            .decode(type: NetworkResult<Danji>.self, decoder: decoder)
            .map { $0.data }
    }
    
    func sort(ids: [String]) -> Observable<[Danji]> {
        return RxAlamofire.request(DanjiRouter.sort(ids: ids))
            .data()
            .decode(type: NetworkResult<[Danji]>.self, decoder: decoder)
            .map { $0.data }
    }
    
    func mood(id: String, mood: Danji.Mood) -> Observable<Danji> {
        return RxAlamofire.request(DanjiRouter.mood(id: id, mood: mood))
            .data()
            .decode(type: Danji.self, decoder: decoder)
    }
    
    func delete(danjiID: String) -> Observable<Int> {
        return RxAlamofire.request(DanjiRouter.delete(id: danjiID))
            .validate(statusCode: 200..<300)
            .data()
            .decode(type: Int.self, decoder: decoder)
//            .map { $0 }
    }
}

struct Danjis: Codable {
    let danji: [Danji]
}
