//
//  ServerCommunication.swift
//
//  Created by Pratik on 18/05/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import Foundation

/// HTTP method type
enum HTTPMethod {
    case GET,POST,DELETE,PUT
    var value : String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        case .DELETE:
            return "DELETE"
        case .PUT:
            return "PUT"
        }
    }
}

/// Server communication class
final class ServerCommunication {
    static let shared = ServerCommunication()
    typealias CompletionHandler = ((_ response : ResponseModel?) -> Void)
    
    ///size define for cache
    private let size = 10 * 1024 * 1024
    private lazy var urlCache: URLCache = {
        /// here we can also define storage path using : URLCache(memoryCapacity: , diskCapacity: , directory: )
        return URLCache(memoryCapacity: 0, diskCapacity: size, diskPath: "myCache")
    }()
    
    private func urlSession() -> URLSession {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.urlCache = urlCache
        sessionConfig.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: sessionConfig)
    }
    
    /// Server communication method to sent or get data
    /// - Parameters:
    ///   - requestObject: request object
    ///   - completionHandler: response block
    func dataTask(requestObject: RequestModel, completionHandler:@escaping CompletionHandler) {
        guard let stringURL = requestObject.url,let serverURL = URL(string: stringURL) else {
            return
        }
        var urlRequest = URLRequest(url: serverURL)
        urlRequest.httpMethod = requestObject.httpMethod.value
        urlRequest.httpBody = requestObject.httpBody
        urlRequest.allHTTPHeaderFields = requestObject.headerFields
        
        ///check and fetch cache data if available
        if let cacheData = urlCache.cachedResponse(for: urlRequest) {
            print("ServerCommunication:-  cache data return")
            let responseModel = ResponseModel(statusCode: 200, error: nil, data: cacheData.data)
            completionHandler(responseModel)
        } else {
            ///fetch data from server
            let session = urlSession()
            let task = session.dataTask(with: urlRequest, completionHandler: {
                (data,response,error) in
                print("ServerCommunication:-  server data return using API calling")
                if let responseObject = response as? HTTPURLResponse {
                    let responseModel = ResponseModel(statusCode: responseObject.statusCode, error: error, data: data)
                    if let responseData = data {
                        /// if response data found then cache those data
                        /// NOTE: nagative case not handle here assume response get success with 200 status code
                        let cachedResponse = CachedURLResponse(response: responseObject, data: responseData)
                        self.urlCache.storeCachedResponse(cachedResponse, for: urlRequest)
                    }
                    completionHandler(responseModel)
                    return
                }
                completionHandler(nil)
            })
            task.resume()
        }
    }
}

/// Request generate model
struct RequestModel {
    let url: String?
    var httpMethod: HTTPMethod = .GET
    var headerFields: [String : String]? = nil
    var httpBody: Data? = nil
}

/// Response model
struct ResponseModel {
    let statusCode : Int
    let error : Error?
    let data : Data?
}

class Student {
    let name = "bunty"
    private let lnbame = "sdsd"
    fileprivate let address = "asdfas"
}
