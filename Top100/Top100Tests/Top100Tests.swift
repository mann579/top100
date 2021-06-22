//
//  Top100Tests.swift
//  Top100Tests
//
//  Created by Manpreet on 27/10/2020.
//

import XCTest
@testable import Top100

final class ApiRouteTests: XCTestCase {
  func testApiRouteUrlsAreNotNil() {
    for route in AlbumApi.allCases {
        XCTAssertNotNil(route.baseURL, "Url nil for route: \(route)")
        XCTAssertNotNil(route.path, "Url nil for route: \(route)")
        XCTAssertNotNil(route.httpMethod, "Url nil for route: \(route)")
    }
  }
}

final class ModelMappingTests: XCTestCase {
    func testModelMappingFromJSON() {
        let json = "{\"feed\": {\"title\": \"Top Albums\",\"id\": \"https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json\",\"author\": {\"name\": \"iTunes Store\",\"uri\": \"http://wwww.apple.com/us/itunes/\"},\"links\": [{\"self\": \"https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json\"}, {\"alternate\": \"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?genreId=34\\u0026popId=82\\u0026app=music\"}],\"copyright\": \"Copyright © 2018 Apple Inc. All rights reserved.\",\"country\": \"us\",\"icon\": \"http://itunes.apple.com/favicon.ico\",\"updated\": \"2020-10-29T04:09:19.000-07:00\",\"results\": [{\"artistName\": \"21 Savage \\u0026 Metro Boomin\",\"id\": \"1534209957\",\"releaseDate\": \"2020-10-02\",\"name\": \"SAVAGE MODE II\",\"kind\": \"album\",\"copyright\": \"℗ 2020 Slaughter Boomin, LLC under exclusive license to Epic Records. With Boominati Worldwide/Republic Records\",\"artistId\": \"894820464\",\"contentAdvisoryRating\": \"Explicit\",\"artistUrl\":\"https://music.apple.com/WebObjects/MZStore.woa/wa/viewCollaboration?cc=us\\u0026ids=894820464-670534462\\u0026app=music\",\"artworkUrl100\":\"https://is4-ssl.mzstatic.com/image/thumb/Music114/v4/ac/de/53/acde53ab-a5de-5338-75e1-3669c49e1204/886448747697.jpg/200x200bb.png\",\"genres\": [{\"genreId\": \"18\",\"name\": \"Hip-Hop/Rap\",\"url\": \"https://itunes.apple.com/us/genre/id18\"}, {\"genreId\": \"34\",\"name\": \"Music\",\"url\": \"https://itunes.apple.com/us/genre/id34\"}, {\"genreId\": \"1076\",\"name\": \"Rap\",\"url\": \"https://itunes.apple.com/us/genre/id1076\"}, {\"genreId\": \"1069\",\"name\": \"Dirty South\",\"url\": \"https://itunes.apple.com/us/genre/id1069\"}],\"url\": \"https://music.apple.com/us/album/savage-mode-ii/1534209957?app=music\"}]}}"
        let data = Data(json.utf8)
        let apiResponse = try! JSONDecoder().decode(AlbumApiResponse.self, from: data)
        XCTAssertEqual(apiResponse.feed?.results?[0].name, "SAVAGE MODE II")
    }
}

final class NetworkTest: XCTestCase {
    func testApiClientFetchAlbumsRequest() {
        let networkManager = NetworkManager()
        
        let expectation = self.expectation(description: "Wait for stubbed response")
        networkManager.getTopAlbums(count: 100) { (albums, error) in
            if error != nil {
               XCTFail()
            }
            XCTAssert(albums?.count == 100)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 5.0)
    }
}
