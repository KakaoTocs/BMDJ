//
//  AuthRouter.swift
//  BMDJ
//
//  Created by 김진우 on 2021/07/29.
//

import Foundation
import Alamofire

enum AuthRouter: URLRequestConvertible {
    case google(idToken: String)
    case apple(userID: String)
    case withdrawal(token: String)
    
    private var baseURL: String {
        #if DEBUG
        return "http://188.166.182.98:3000"
        #else
        return "http://188.166.182.98:3000"
        #endif
    }
    
    var method: HTTPMethod {
        switch self {
        case .google, .apple:
            return .post
        case .withdrawal:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .google:
            return "/auth/google"
        case .apple:
            return "/auth/apple"
        case .withdrawal:
            return "/user"
        }
    }
    
    var body: Data? {
        switch self {
        case .google(let idToken):
            let token = ["id_token": idToken]
            let data = try? JSONEncoder().encode(token)
            return data
        case .apple(let userID):
            let body = ["token": userID]
            let data = try? JSONEncoder().encode(body)
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
        case .google, .apple:
            return ["Content-Type": "application/json"]
        case .withdrawal(let token):
            return ["Authorization": token]
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
//        request.setValue("bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjEiLCJpYXQiOjE2MjA1Nzg2MTYsImV4cCI6MTYyMTE4MzQxNn0.y-Owmic4Ehd5nUBRPwiJ8CtxC9m4Su0IH6a4ZGJEuZw", forHTTPHeaderField: "Authorization")
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Set Body
        if let json = body {
            request.httpBody = json
        }
        print(request.curlString)
        return request
    }
}
