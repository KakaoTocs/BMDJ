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
    
    func all(danjiID: String) -> Observable<[Memo]> {
        return RxAlamofire.request(MemoRouter.all(danjiID: danjiID))
            .validate(statusCode: 200..<300)
            .data()
            .decode(type: NetworkResult<[Memo]>.self, decoder: decoder)
            .map { $0.data }
    }
    
    func add(memoCreate: MemoCreate) -> Observable<Memo> {
        return RxAlamofire.upload(multipartFormData: { formData in
            if let data = memoCreate.image?.pngData() {
                formData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
            formData.append(memoCreate.mood.rawValue.data(using: .utf8)!, withName: "mood")
            formData.append(memoCreate.text.data(using: .utf8)!, withName: "text")
            formData.append(memoCreate.danjiId.data(using: .utf8)!, withName: "danjiId")
        }, urlRequest: MemoRouter.add(memoCreate: memoCreate))
        .flatMap { $0.rx.data() }
        .decode(type: NetworkResult<Memo>.self, decoder: decoder)
        .map { $0.data }
    }
    
    func update(memo: Memo) -> Observable<Bool> {
        return RxAlamofire.upload(multipartFormData: { formData in
            if let text = memo.text.data(using: .utf8) {
                formData.append(text, withName: "text")
            }
        }, urlRequest: MemoRouter.update(id: memo.id, text: memo.text))
        .map { _ in true }
    }
    func delete(memo: Memo) -> Observable<Bool> {
        return RxAlamofire.request(MemoRouter.delete(id: memo.id))
            .validate(statusCode: 200..<300)
            .map { _ in true }
    }
    
}
