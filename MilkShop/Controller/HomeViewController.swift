//
//  HomeViewController.swift
//  MilkShop
//
//  Created by macbook_air_1 on 2023/1/30.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, Getdata {
    func passValue(data: Detail) {
       detailGroup = data
    }
    
    
    @IBOutlet weak var drinksCollectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    var menuArray = [Menu.Records]()
    let bannerArray: [UIImage] = {
        var array = [UIImage]()
        for i in 1...3 {
            let image = UIImage(named: "banner-\(i)")!
            array.append(image)
        }
        let firstImage = UIImage(named: "banner-1")!
        array.append(firstImage)
        return array
    }()
    var bannerIdx = 0
    var nameLabelString = ""
    var detailGroup: Detail?
    override func viewDidLoad() {
        super.viewDidLoad()

        drinksCollectionView.delegate = self
        drinksCollectionView.dataSource = self
        drinksCollectionView.collectionViewLayout = setupDrinksCollectionView()
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.collectionViewLayout = setupBannerCollectionView()
        fetchData()
       

        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(changeBanner), userInfo: nil, repeats: true)
    }
    
   
    func setupBannerCollectionView() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    func setupDrinksCollectionView() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2 - 10, height: 200)
        return layout
    }
    
    func fetchData() {
        let urlString = "https://api.airtable.com/v0/appfieMsUwTxzERom/Menu?sort[][field]=type&sort[][direction]=desc"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("Bearer keykgXb1GRqbLNtpC", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { data, response, error in
                let decoder = JSONDecoder()
                if let data = data {
                    do {
                        let menu = try decoder.decode(Menu.self, from: data)
                        DispatchQueue.main.async {
                            self.menuArray = menu.records
                            self.drinksCollectionView.reloadData()
                        }
                    } catch  {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    @IBAction func goShoppingCart(_ sender: Any) {
        
    }
    
    @objc func changeBanner() {
        var indexPath: IndexPath
        bannerIdx += 1
        if bannerIdx < bannerArray.count {
            indexPath  = IndexPath(item: bannerIdx, section: 0)
            bannerCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        } else {
            bannerIdx = 0
            indexPath  = IndexPath(item: bannerIdx, section: 0)
            bannerCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            changeBanner()
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let cell = sender as! DrinksCollectionViewCell
            let indexPath = drinksCollectionView.indexPath(for: cell)
            let destination = segue.destination as! DetailViewController
            destination.delegate = self
            destination.menu = menuArray[indexPath!.row]
        } else if segue.identifier == "cartSegue" {
            let destination = segue.destination as! ShoppingCartViewController
            destination.detailGroup = detailGroup
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
            return bannerArray.count
        } else {
            return menuArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == drinksCollectionView {
            let drinksCell = collectionView.dequeueReusableCell(withReuseIdentifier: "drinksCell", for: indexPath) as! DrinksCollectionViewCell
            drinksCell.drinksLabel.text = menuArray[indexPath.row].fields.name
            let imageURL = URL(string: "\(menuArray[indexPath.row].fields.imageURL)")!
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        drinksCell.drinksImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
            return drinksCell
            
        } else {
            let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as! BannerCollectionViewCell
            bannerCell.bannerImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
            bannerCell.bannerImageView.image = bannerArray[indexPath.row]
            return bannerCell
        }
    }
    
}
