import Foundation

struct AlbumApiResponse : Codable {
    let feed : Feed?
    
    enum CodingKeys: String, CodingKey {
        
        case feed = "feed"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        feed = try values.decodeIfPresent(Feed.self, forKey: .feed)
    }
    
}
