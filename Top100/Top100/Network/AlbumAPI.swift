//
//  AlbumAPI.swift
//  Top100
//
//  Created by Manpreet on 27/10/2020.
//

import Foundation

public enum AlbumApi:EndPoint, CaseIterable {
    public static var allCases: [AlbumApi] {
        return [.top(100)]
    }
    case top(_ count: Int)
}

extension AlbumApi {
    
    var baseURL: URL {
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .top(let count):
            return "/us/apple-music/top-albums/all/\(count)/explicit.json"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
}
