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
            .response { [weak self] response in
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
    
    func allW(danjiID: String) -> BDResponse<[Memo]> {
        let semaphore = DispatchSemaphore(value: 0)
        var bdResponse: BDResponse<[Memo]> = .init(data: nil, error: .request)
        
        AF.request(MemoRouter.all(danjiID: danjiID))
            .response { [weak self] response in
                guard let self = self else {
                    semaphore.signal()
                    return
                }
                if let response = response.response {
                    switch response.statusCode {
                    case 400...499:
                        bdResponse = .init(data: nil, error: .request)
                    case 500...599:
                        bdResponse = .init(data: nil, error: .server)
                    default:
                        break
                    }
                } else if let data = response.data {
                    if let memos = try? self.decoder.decode(NetworkResult<[Memo]>.self, from: data).data {
                        bdResponse = .init(data: memos, error: nil)
                    } else {
                        bdResponse = .init(data: nil, error: .scheme)
                    }
                } else {
                    bdResponse = .init(data: nil, error: .response)
                }
                semaphore.signal()
            }
        semaphore.wait()
        return bdResponse
    }
    
    func deleteW(id: String) -> BDResponse<String> {
        let semaphore = DispatchSemaphore(value: 0)
        var bdResponse: BDResponse<String> = .init(data: nil, error: .request)
        
        AF.request(MemoRouter.delete(id: id))
            .response { response in
                if let response = response.response {
                    switch response.statusCode {
                    case 200:
                        bdResponse = .init(data: id, error: nil)
                    case 400...499:
                        bdResponse = .init(data: nil, error: .request)
                    case 500...599:
                        bdResponse = .init(data: nil, error: .server)
                    default:
                        break
                    }
                } else {
                    bdResponse = .init(data: nil, error: .response)
                }
                semaphore.signal()
            }
        semaphore.wait()
        return bdResponse
    }
    
    func addW(memoCreate: MemoCreate) -> BDResponse<Memo> {
        let semaphore = DispatchSemaphore(value: 0)
        var bdResponse: BDResponse<Memo> = .init(data: nil, error: .request)
        
        guard let moodData = memoCreate.mood.rawValue.data(using: .utf8),
              let textData = memoCreate.text.data(using: .utf8),
              let danjiIDData = memoCreate.danjiId.data(using: .utf8) else {
            return bdResponse
        }
        AF.upload(multipartFormData: { formData in
            if let imageData = memoCreate.imageData {
                formData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
            }
            formData.append(moodData, withName: "mood")
            formData.append(textData, withName: "text")
            formData.append(danjiIDData, withName: "danjiId")
        }, with: MemoRouter.add)
            .response { [weak self] response in
                guard let self = self else {
                    semaphore.signal()
                    return
                }
                if let response = response.response {
                    switch response.statusCode {
                    case 400...499:
                        bdResponse = .init(data: nil, error: .request)
                    case 500...599:
                        bdResponse = .init(data: nil, error: .server)
                    default:
                        break
                    }
                } else if let data = response.data {
                    if let memo = try? self.decoder.decode(Memo.self, from: data) {
                       bdResponse = .init(data: memo, error: nil)
                   } else {
                       bdResponse = .init(data: nil, error: .scheme)
                   }
                } else {
                    bdResponse = .init(data: nil, error: .response)
                }
                semaphore.signal()
            }
        semaphore.wait()
        return bdResponse
    }
    
    func updateW(id: String, text: String) -> BDResponse<String> {
        let semaphore = DispatchSemaphore(value: 0)
        var bdResponse: BDResponse<String> = .init(data: nil, error: .request)
        
        guard let textData = text.data(using: .utf8) else {
            return bdResponse
        }
        AF.upload(multipartFormData: { formData in
            formData.append(textData, withName: "text")
        }, with: MemoRouter.update(id: id))
            .response { response in
                if let response = response.response {
                    switch response.statusCode {
                    case 200:
                        bdResponse = .init(data: id, error: nil)
                    case 400...499:
                        bdResponse = .init(data: nil, error: .request)
                    case 500...599:
                        bdResponse = .init(data: nil, error: .server)
                    default:
                        break
                    }
                } else {
                    bdResponse = .init(data: nil, error: .response)
                }
                semaphore.signal()
            }
        semaphore.wait()
        return bdResponse
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
        }, urlRequest: MemoRouter.update(id: id))
        .map { _ in true }
    }
    func delete(id: String) -> Observable<Bool> {
        return RxAlamofire.request(MemoRouter.delete(id: id))
            .validate(statusCode: 200..<300)
            .map { _ in true }
    }
    
}
