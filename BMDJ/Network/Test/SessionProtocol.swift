//
//  SessionProtocol.swift
//  BMDJ
//
//  Created by 김진우 on 2022/08/15.
//

import Foundation

import Alamofire

protocol SessionProtocol {
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest
    func upload(multipartFormData: @escaping (MultipartFormData) -> Void,
                with request: URLRequestConvertible) -> UploadRequest
}

extension Session: SessionProtocol {
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return AF.request(urlRequest, interceptor: nil)
    }
    
    func upload(multipartFormData: @escaping (MultipartFormData) -> Void,
                with request: URLRequestConvertible) -> UploadRequest {
        return AF.upload(multipartFormData: multipartFormData, with: request, fileManager: .default)
    }
}
