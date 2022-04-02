//
//  MemoClient.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/26.
//

import Foundation

import RxSwift
import Alamofire
import RxAlamofire

final class MemoClient {
    
    static let shared = MemoClient()
    
    private let decoder = JSONDecoder()
    let disposeBag = DisposeBag()
    
    private init() {}
    
    func lowLevelAll(danjiID: String) -> [Memo]? {
        let semaphore = DispatchSemaphore(value: 0)
        var result: [Memo]?
        print(MemoRouter.all(danjiID: danjiID).urlRequest?.curlString ?? "nil")
        AF.request(MemoRouter.all(danjiID: danjiID))
            .responseData { [weak self] response in
                if let data = response.data,
                   let memos = try? self?.decoder.decode(NetworkResult<[Memo]>.self, from: data) {
                    print("\(danjiID) Succes")
                    result = memos.data
                } else {
                    print("\(danjiID) Fail")
                    result = nil
                }
                semaphore.signal()
            }
        semaphore.wait()
        return result
    }
    
    func all(danjiID: String) -> Observable<[Memo]> {
        return RxAlamofire.request(MemoRouter.all(danjiID: danjiID))
            .validate(statusCode: 200..<300)
            .data()
            .decode(type: NetworkResult<[Memo]>.self, decoder: decoder)
            .map { $0.data }
    }
    
    func add(memoCreate: MemoCreate) -> Observable<Memo> {
        return RxAlamofire.upload(multipartFormData: { formData in
            if let data = memoCreate.imageData {
                formData.append(data, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
            }
            formData.append(memoCreate.mood.rawValue.data(using: .utf8)!, withName: "mood")
            formData.append(memoCreate.text.data(using: .utf8)!, withName: "text")
            formData.append(memoCreate.danjiId.data(using: .utf8)!, withName: "danjiId")
        }, urlRequest: MemoRouter.add)
        .flatMap { $0.rx.data() }
        .decode(type: NetworkResult<Memo>.self, decoder: decoder)
        .map { $0.data }
    }
    
    func update(id: String, text: String) -> Observable<Bool> {
        return RxAlamofire.upload(multipartFormData: { formData in
            if let text = text.data(using: .utf8) {
                formData.append(text, withName: "text")
            }
        }, urlRequest: MemoRouter.update(id: id, text: text))
        .map { _ in true }
    }
    func delete(id: String) -> Observable<Bool> {
        return RxAlamofire.request(MemoRouter.delete(id: id))
            .validate(statusCode: 200..<300)
            .map { _ in true }
    }
    
}
