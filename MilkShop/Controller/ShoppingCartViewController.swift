//
//  ShoppingCartViewController.swift
//  MilkShop
//
//  Created by macbook_air_1 on 2023/2/2.
//

import UIKit

class ShoppingCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var cartTableView: UITableView!
    var cart = [ShoppingCartResponse.Records]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        fetchData()
    }
    
    func fetchData() {
        let urlString = "https://api.airtable.com/v0/appfieMsUwTxzERom/ShoppingCart"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("Bearer keykgXb1GRqbLNtpC", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { data, response, error in
                let decoder = JSONDecoder()
                if let data = data {
                    do {
                        let shoppingCart = try decoder.decode(ShoppingCartResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.cart = shoppingCart.records
                            self.cartTableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func deleteData() {
        let urlString = "https://api.airtable.com/v0/appfieMsUwTxzERom/ShoppingCart"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("Bearer keykgXb1GRqbLNtpC", forHTTPHeaderField: "Authorization")
            request.httpMethod = "DELETE"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { data, response, error in
                let decoder = JSONDecoder()
                if let data = data {
                    do {
                        let shoppingCart = try decoder.decode(ShoppingCart.self, from: data)
                        DispatchQueue.main.async {
//                            self.cart = shoppingCart.records
//                            self.cartTableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func showInputAlert() {
        let alertController = UIAlertController(
            title: "訂購人資訊",
            message: "請填寫完整訂購人資訊",
            preferredStyle: .alert
        )
        let alertStrings = ["訂購人姓名","訂購人電話","外送地址"]
        for alertString in alertStrings {
            alertController.addTextField { textField in
                textField.placeholder = "\(alertString)"
            }
        }
        alertController.addAction(
            UIAlertAction(title: "Submit", style: .default) { _ in
                if let textField = alertController.textFields?.first {
                    // Handle the submitted text
                    print("Submitted text: \(textField.text ?? "")")
                }
            }
        )

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }

    @IBAction func sendOrder(_ sender: Any) {
        showInputAlert()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let orderItem = cart[indexPath.row]
            MenuController.shared.deleteOrderItem(orderID: orderItem.id) { result in
                switch result {
                case .success(let message):
                    print(message)
                   
                case .failure(let error):
                    print(error)
                    print(orderItem.id)
                    DispatchQueue.main.async {
                        self.cart.remove(at: indexPath.row)
                        self.cartTableView.deleteRows(at: [indexPath], with: .automatic)
                        self.cartTableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return cart.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        cell.nameLabel.text = "\(cart[indexPath.row].fields.name)    $ \(cart[indexPath.row].fields.price) 元"
        cell.detailLabel.text = "\(cart[indexPath.row].fields.size),\(cart[indexPath.row].fields.ice),\(cart[indexPath.row].fields.sugar),\(cart[indexPath.row].fields.add)"
        let imageURL = URL(string: "\(cart[indexPath.row].fields.imageURL)")!
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    cell.drinkImageView.image = UIImage(data: data)
                }
            }
        }.resume()
        return cell
    }
}
