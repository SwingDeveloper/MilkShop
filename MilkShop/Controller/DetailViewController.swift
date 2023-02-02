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
    let add = ["不加料", "珍珠", "布丁", "仙草凍", "綠茶凍"]
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
    
    @IBAction func addToCart(_ sender: Any) {
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
        if segue.identifier == "cartSegue" {
            let destination = segue.destination as! ShoppingCartViewController
            destination.menu = menu
        }
    }
    

}
