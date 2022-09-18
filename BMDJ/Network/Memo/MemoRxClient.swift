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
    func all(_ danjiID: String) -> Observable<MemoAllResult> {
        return session.request(MemoRouter.all(danjiID: danjiID))
            .responseJSON()
            .map { self.generateResult($0, dataType: [Memo].self) }
    }
    
    func remove(_ danjiID: String) -> Observable<MemoRemoveResult> {
        return .empty()
    }
    
    func add(_ memoCreate: MemoCreate) -> Observable<MemoAddResult> {
        return .empty()
    }
    
    func update(_ danjiID: String, memoUpdate: MemoUpdate) -> Observable<MemoUpdateResult> {
        return .empty()
    }
    
    // MARK: - Private Method
    private func generateResult<T: Codable>(_ response: DataResponse<Any, AFError>,  dataType: T.Type) -> Result<T, BDError> {
        var result: Result<T, BDError> = .failure(.request)
        
        if let data = response.data {
            if let decodedData = try? self.decoder.decode(T.self, from: data) {
                result = .success(decodedData)
            } else {
                result = .failure(.scheme)
            }
        } else if let response = response.response {
            switch response.statusCode {
            case 400...499:
                result = .failure(.networkState)
            case 500...599:
                result = .failure(.server)
            default:
                result = .failure(.response)
            }
        } else {
            result = .failure(.response)
        }
        
        return result
    }
}
