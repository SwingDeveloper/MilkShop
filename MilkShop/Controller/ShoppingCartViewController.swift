//
//  ShoppingCartViewController.swift
//  MilkShop
//
//  Created by macbook_air_1 on 2023/2/2.
//

import UIKit

class ShoppingCartViewController: UIViewController {
    
    var menu: Menu.Records?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(menu?.fields.name)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
