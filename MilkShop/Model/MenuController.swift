
import Foundation

class MenuController {
    static let shared = MenuController()
    
    let baseURL = URL(string: "https://api.airtable.com/v0/appfieMsUwTxzERom")!
    
    func fetchMenuItem(completion: @escaping (Result<Menu,NetworkError>) -> Void) {
        let menuUrl = baseURL.appendingPathComponent("Menu")
        var component = URLComponents(url: menuUrl, resolvingAgainstBaseURL: true)
        component?.queryItems = [URLQueryItem(name: "sort[][field]", value: "type"),
                                 URLQueryItem(name: "sort[][direction]", value: "desc"),
                                 URLQueryItem(name: "api_key", value: "keykgXb1GRqbLNtpC")]
        if let url = component?.url {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let menu = try decoder.decode(Menu.self, from: data)
                        completion(.success(menu))
                    } catch {
                        completion(.failure(.jsonDecodeFailed))
                    }
                } else {
                    completion(.failure(.requestFailed))
                }
            }.resume()
        } else {
            completion(.failure(.invaildUrl))
        }
    }
    
    func uploadOrder(order: ShoppingCart,completion: @escaping (Result<ShoppingCart,NetworkError>) -> Void) {
        let orderUrl = baseURL.appendingPathComponent("ShoppingCart")
        var urlRequest = URLRequest(url: orderUrl)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer keykgXb1GRqbLNtpC", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(order)
        urlRequest.httpBody = jsonData
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(ShoppingCart.self, from: data)
                    completion(.success(response))
                } catch  {
                    completion(.failure(.jsonDecodeFailed))
                }
            } else {
                completion(.failure(.requestFailed))
            }
        }.resume()
    }
    
    func deleteOrderItem(orderID: String,completion: @escaping (Result<String,NetworkError>) -> Void) {
        let orderUrl = baseURL.appendingPathComponent("ShoppingCart/\(orderID)")
        //let newUrl = orderUrl.appendingPathComponent("\(orderID)")
        var urlRequest = URLRequest(url: orderUrl)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("Bearer keykgXb1GRqbLNtpC", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let order = try decoder.decode(ShoppingCartResponse.self, from: data)
                    print(order)
                    completion(.success("删除成功"))
                } catch  {
                    completion(.failure(.jsonDecodeFailed))
                }
            } else {
                completion(.failure(.requestFailed))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invaildUrl
    case requestFailed
    case responseFailed
    case jsonDecodeFailed
}
