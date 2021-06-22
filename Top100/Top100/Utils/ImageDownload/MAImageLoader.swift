//
//  ImageLoader.swift
//  Top100
//
//  Created by Manpreet on 28/10/2020.
//

import Foundation
import UIKit.UIImage
import Combine

public final class MAImageLoader {
    public static let shared = MAImageLoader()
    
    private let cache: ImageCacheType
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    public init(cache: ImageCacheType = MAImageCache()) {
        self.cache = cache
    }
    
    public func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cache[url] {
            return Just(image).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: {[unowned self] image in
                guard let image = image else { return }
                self.cache[url] = image
            })
            .subscribe(on: backgroundQueue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

public struct AlbumImage {
     static func loadImage(for album: Album) -> AnyPublisher<UIImage?, Never> {
        return Just(album.artworkUrl100)
            .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
                let url = URL(string: album.artworkUrl100 ?? "")!
                return MAImageLoader.shared.loadImage(from: url)
            })
            .eraseToAnyPublisher()
    }
}
