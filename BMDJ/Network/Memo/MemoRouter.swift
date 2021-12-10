//
//  MemoRouter.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/26.
//

import Foundation
import Alamofire

enum MemoRouter: URLRequestConvertible {
    case all(danjiID: String)
    case add(memoCreate: MemoCreate)
    case update(id: String, text: String)
    case delete(id: String)
    
    private var baseURL: String {
        #if DEBUG
        return "http://188.166.182.98:3000"
        #else
        return "http://188.166.182.98:3000"
        #endif
    }
    
    var method: HTTPMethod {
        switch self {
        case .all:
            return .get
        case .add:
            return .post
        case .update:
            return .put
        case .delete:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .all(let id):
            return "/memos?danjiId=\(id)"
        case .add:
            return "/memo"
        case .update(let id, _):
            return "/memo/\(id)"
        case .delete(let id):
            return "/memo/\(id)"
        }
    }
    
    var body: Data? {
        switch self {
        default:
            return nil
        }
    }
    
    var queryString: [URLQueryItem] {
        switch self {
        default:
            return []
        }
    }
    
    var header: [String: String] {
        switch self {
//        case .add(let memoCreate):
//            return ["Content-Type": "multipart/form-data; boundary=\(memoCreate.uuid)"]
        default:
            return [:]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        // Set URL (Base + Path)
        var urlComponent = URLComponents(string: baseURL + path)
        if !queryString.isEmpty {
            urlComponent?.queryItems = queryString
        }
        let url = urlComponent!.url!
        var request = URLRequest(url: url)
        
        // Set Method
        request.method = method
//        request.
        // Set Header
        for (key, value) in header {
            request.setValue(value, forHTTPHeaderField: key)
        }
        if let token = UserDefaultService.shared.token {
            request.setValue("bearer \(token)", forHTTPHeaderField: "Authorization")
        }
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Set Body
        if let json = body {
            request.httpBody = json
        }
        print(request.curlString)
        return request
    }
}
