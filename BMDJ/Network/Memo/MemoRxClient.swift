//
//  MemoRxClient.swift
//  BMDJ
//
//  Created by 김진우 on 2022/08/15.
//

import Foundation

import Alamofire
import RxSwift
import RxAlamofire

final class MemoRxClient: MemoAPI {
    
    // MARK: - Property
    private let decoder = JSONDecoder()
    private let session: SessionProtocol
    
    // MARK: - Init
    init(session: SessionProtocol) {
        self.session = session
    }
    
    // MARK: - Interface
    func create(_ memoCreate: MemoCreate) -> Observable<MemoCreateResult> {
        return createUploadObservable(multipartFormData: { formData in
            guard let moodData = memoCreate.mood.rawValue.data(using: .utf8),
                  let textData = memoCreate.text.data(using: .utf8),
                  let danjiIDData = memoCreate.danjiId.data(using: .utf8),
                  let imageData = memoCreate.imageData else {
                return
            }
            formData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
            formData.append(moodData, withName: "mood")
            formData.append(textData, withName: "text")
            formData.append(danjiIDData, withName: "danjiId")
        }, MemoRouter.add, type: Memo.self)
    }
    
    func read(_ danjiID: String) -> Observable<MemoReadResult> {
        return createRequestObservable(MemoRouter.all(danjiID: danjiID), type: [Memo].self)
    }
    
    func update(_ id: String, memoUpdate: MemoUpdate) -> Observable<MemoUpdateResult> {
        return createUploadObservable(multipartFormData: { formData in
            guard let textData = memoUpdate.text.data(using: .utf8) else {
                return
            }
            formData.append(textData, withName: "text")
        }, MemoRouter.update(id: id), type: EmptyEntity.self)
    }
    
    func delete(_ id: String) -> Observable<MemoDeleteResult> {
        return createRequestObservable(MemoRouter.delete(id: id), type: EmptyEntity.self)
    }
    
    // MARK: - Private Method
    private func createRequestObservable<T: Codable>(_ request: URLRequestConvertible, type: T.Type) -> Observable<Result<T, BDError>> {
        return Observable<Result<T, BDError>>.create { observable in
            self.session.request(request)
                .response { afResponse in
                    let result = self.generateResult(afResponse, dataType: type)
                    observable.onNext(result)
                }
            return Disposables.create()
        }
    }
    
    private func createUploadObservable<T: Codable>(multipartFormData: @escaping (MultipartFormData) -> Void, _ request: URLRequestConvertible, type: T.Type) -> Observable<Result<T, BDError>> {
        return Observable<Result<T, BDError>>.create { observable in
            self.session.upload(multipartFormData: multipartFormData, with: request)
                .response { afResponse in
                    let result = self.generateResult(afResponse, dataType: type)
                    observable.onNext(result)
                }
            return Disposables.create()
        }
    }
    
    private func generateResult<T: Codable>(_ afResponse: AFDataResponse<Data?>,  dataType: T.Type) -> Result<T, BDError> {
        var result: Result<T, BDError> = .failure(.response)
        
        if let data = afResponse.data {
            if let entity = decode(data, type: dataType) {
                result = .success(entity)
            } else {
                result = .failure(.scheme)
            }
        } else if let response = afResponse.response {
            if let error = verifyStatusCode(response) {
                result = .failure(error)
            } else {
                result = .failure(.response)
            }
        } else {
            result = .failure(.response)
        }
        return result
    }
    
    private func decode<T: Codable>(_ data: Data, type: T.Type) -> T? {
        if let entity = try? self.decoder.decode(T.self, from: data) {
            return entity
        } else {
            return nil
        }
    }
    
    private func verifyStatusCode(_ response: HTTPURLResponse) -> BDError? {
        switch response.statusCode {
        case 200...299:
            return nil
        case 400...499:
            return .request
        case 500...599:
            return .server
        default:
            return .response
        }
    }
}
