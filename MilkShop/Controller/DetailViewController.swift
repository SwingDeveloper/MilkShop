//
//  DetailViewController.swift
//  MilkShop
//
//  Created by macbook_air_1 on 2023/2/2.
//

import UIKit

class DetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    

    @IBOutlet weak var addTextField: UITextField!
    @IBOutlet weak var iceTextField: UITextField!
    @IBOutlet weak var sugarTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var drinksImageView: UIImageView!
    var menu: Menu.Records!
    var price = 0
    let size = ["大杯","中杯"]
    let sugar = ["無糖","微糖","半糖","少糖","正常甜"]
    let ice = ["去冰","微冰","少冰","正常冰","溫熱"]
    let add = ["加珍珠", "加布丁", "加仙草凍", "加綠茶凍","不加料"]
    let sizePickerView = UIPickerView()
    let sugarPickerView = UIPickerView()
    let icePickerView = UIPickerView()
    let addPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImage()
        nameLabel.text = menu.fields.name
        priceLabel.text = "\(menu.fields.price_m ?? menu.fields.price_l)"
        descriptionView.text = menu?.fields.description
        sizePickerView.delegate = self
        sizePickerView.dataSource = self
        sugarPickerView.delegate = self
        sugarPickerView.dataSource = self
        icePickerView.delegate = self
        icePickerView.dataSource = self
        addPickerView.delegate = self
        addPickerView.dataSource = self
        sizeTextField.inputView = sizePickerView
        sugarTextField.inputView = sugarPickerView
        iceTextField.inputView = icePickerView
        addTextField.inputView = addPickerView
    }
    
    func fetchImage() {
        let imageURL = URL(string: menu.fields.imageURL)
        if let url = imageURL {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.drinksImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    
    func postData() {
        let urlString = "https://api.airtable.com/v0/appfieMsUwTxzERom/ShoppingCart"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("Bearer keykgXb1GRqbLNtpC", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            let drinkDetail = ShoppingCart(records: [.init(fields: .init(name: self.nameLabel.text!, size: self.sizeTextField.text!, ice: self.iceTextField.text!, sugar: self.sugarTextField.text!, imageURL: self.menu.fields.imageURL, add: self.addTextField.text!, price: Int(self.priceLabel.text!)!))])
            if let data = try? encoder.encode(drinkDetail) {
                URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let response = try? decoder.decode(ShoppingCart.self, from: data)
                            print(response)
                        } catch  {
                            print(error)
                        }
                    }
                }.resume()
            }
        }
    }
    
    @IBAction func addToCart(_ sender: Any) {
        postData()
        dismiss(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case sizePickerView:
            return size.count
        case sugarPickerView:
            return sugar.count
        case icePickerView:
            return ice.count
        default:
            return add.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case sizePickerView:
            return size[row]
        case sugarPickerView:
            return sugar[row]
        case icePickerView:
            return ice[row]
        default:
            return add[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case sizePickerView:
            sizeTextField.text = size[row]
            sizeTextField.resignFirstResponder()
        case sugarPickerView:
            sugarTextField.text = sugar[row]
            sugarTextField.resignFirstResponder()
        case icePickerView:
            iceTextField.text = ice[row]
            iceTextField.resignFirstResponder()
        default:
            addTextField.text = add[row]
            addTextField.resignFirstResponder()
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
}


