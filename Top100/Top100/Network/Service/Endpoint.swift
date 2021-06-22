//
//  Endpoint.swift
//  Top100
//
//  Created by Manpreet on 27/10/2020.
//

import Foundation

protocol EndPoint {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
}
