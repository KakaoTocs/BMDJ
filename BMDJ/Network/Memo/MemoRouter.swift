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
    case update(id: String)
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
        case .update(let id):
            return "memo/\(id)"
        case .delete(let id):
            return "/memo/\(id)"
        }
    }
    
    var body: Data? {
        switch self {
//        case .add(let memo):
//            let params = [
//                "mood": memo.mood.rawValue,
//                "text": memo.text,
//                "danjiId": memo.danjiId
//            ]
//            var strings: [String] = []
//            for (key, value) in params {
//                strings.append(key + "=\(value)")
//            }
//            guard let data = strings.map({ String($0) }).joined(separator: "&").data(using: .utf8) else {
//                return nil
//            }
            /*
            if let image = memo.image,
               let imageData = image.pngData() {
                data.append("\r\n--\(memo.uuid)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"image\"; filename=\"image\"\r\n".data(using: .utf8)!)
//                data.append(imageData)
                data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            }*/
//            return data
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
