//
//  HomeViewController.swift
//  MilkShop
//
//  Created by macbook_air_1 on 2023/1/30.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var drinksCollectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    let menu = [Menu.Records]()
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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        drinksCollectionView.delegate = self
        drinksCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.collectionViewLayout = setupBannerCollectionView()

        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(changeBanner), userInfo: nil, repeats: true)
    }
    
    func setupBannerCollectionView() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        layout.scrollDirection = .horizontal
        return layout
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
            return bannerArray.count
        } else {
            return menu.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as! BannerCollectionViewCell
        bannerCell.bannerImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
        bannerCell.bannerImageView.image = bannerArray[indexPath.row]
        return bannerCell
    }
    
}
