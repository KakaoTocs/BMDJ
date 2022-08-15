//
//  SessionProtocol.swift
//  BMDJ
//
//  Created by 김진우 on 2022/08/15.
//

import Alamofire
import RxSwift
import RxAlamofire

protocol SessionProtocol {
    func request(_ urlRequest: URLRequestConvertible) -> Observable<DataRequest>
}

extension Session: SessionProtocol {
    func request(_ urlRequest: URLRequestConvertible) -> Observable<DataRequest> {
        return RxAlamofire.request(urlRequest, interceptor: nil)
    }
    
}
