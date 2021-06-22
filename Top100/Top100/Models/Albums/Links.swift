import Foundation

struct Links : Codable {
    let SelfLink : String?
    
    enum CodingKeys: String, CodingKey {
        
        case SelfLink = "self"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        SelfLink = try values.decodeIfPresent(String.self, forKey: .SelfLink)
    }
    
}
