
import Foundation
import UIKit

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
        let price_l: Int
    }
}

struct ShoppingCart: Codable {
    
    let records: [Records]
    
    struct Records: Codable {
        let fields: Fields
    }
    struct Fields: Codable {
        let name: String
        let size: String
        let ice: String
        let sugar: String
        let imageURL: String
        let add: String
        let price: Int
    }
}

struct ShoppingCartResponse: Decodable {
    
    let records: [Records]
    
    struct Records: Decodable {
        let fields: Fields
        let id: String
    }
    struct Fields: Decodable {
        let name: String
        let size: String
        let ice: String
        let sugar: String
        let imageURL: String
        let add: String
        let price: Int
    }
}




struct Detail {
    let name: String
    let price: Int
    let image: UIImage
    let size: String
    let ice: String
    let sugar: String
    let add: String
}
