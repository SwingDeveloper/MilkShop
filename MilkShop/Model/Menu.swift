
import Foundation

struct Menu: Decodable {
    
    let records: [Records]
    
    struct Records: Decodable {
        let fields: Fields
    }
    
    struct Fields: Decodable {
        let name: String
        let type: String
        let description: String
        let imageURL: String
        let price_m: Int?
        let price_l: Int?
    }
}
