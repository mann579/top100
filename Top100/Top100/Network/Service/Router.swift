//
//  Router.swift
//  Top100
//
//  Created by Manpreet on 27/10/2020.
//

import Foundation

public typealias HTTPCallerCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol HTTPCaller: class {
    associatedtype EndPointObj: EndPoint
    func request(_ route: EndPointObj, completion: @escaping HTTPCallerCompletion)
    func cancel()
}

class Router<EndPointObj: EndPoint>: HTTPCaller {
    private var task: URLSessionTask?
    
    func request(_ route: EndPointObj, completion: @escaping HTTPCallerCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        return request
    }
}
