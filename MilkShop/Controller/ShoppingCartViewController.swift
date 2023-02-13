//
//  ShoppingCartViewController.swift
//  MilkShop
//
//  Created by macbook_air_1 on 2023/2/2.
//

import UIKit

class ShoppingCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    
    
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    var detailGroup: Detail?
    
    var cart = [Detail]()
    var menu: Menu.Records?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTableView.delegate = self
        cartTableView.dataSource = self

        print(detailGroup?.name)
        print(detailGroup?.price)
        print(detailGroup?.size)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
