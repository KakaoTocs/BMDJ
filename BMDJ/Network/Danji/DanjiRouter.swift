//
//  DanjiRouter.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/14.
//

import Foundation
import Alamofire

enum DanjiRouter: URLRequestConvertible {
    case all
    case plant(danji: DanjiCreate)
    case sort(ids: [String])
    case delete(id: String)
    case mood(id: String, mood: Danji.Mood)
    
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
        case .plant:
            return .post
        case .sort:
            return .put
        case .delete:
            return .delete
        case .mood:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .all:
            return "/danjis"
        case .plant:
            return "/danji"
        case .sort:
            return "/danjis"
        case .delete(let id):
            return "/danji/\(id)"
        case .mood(let id, _):
            return "/danji/\(id)/mood"
        }
    }
    
    var body: Data? {
        switch self {
        case .plant(let danjiBase):
            let data = try? JSONEncoder().encode(danjiBase)
            return data
        case .sort(let ids):
            let data = try? JSONEncoder().encode(["danjiIds": ids])
            return data
        case .mood(_, let mood):
            let data = try? JSONEncoder().encode(["mood": mood])
            return data
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
        case .plant, .sort, .mood:
            return ["Content-Type":"application/json"]
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
