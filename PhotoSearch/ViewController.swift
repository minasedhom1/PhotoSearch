//
//  ViewController.swift
//  PhotoSearch
//
//  Created by Mina Sedhom on 1/23/22.
//  Copyright © 2022 Mina Sedhom. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    private var collectionView: UICollectionView?
    
    var results = [Result]()
    
    let searchBar = UISearchBar()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo Search"
        searchBar.delegate = self
        view.addSubview(searchBar)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.placeholder = "Search Photos to download"
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        self.collectionView = collectionView
        
      

    }
    let noResultLabel  = UILabel()

    func setPlaceHolderNoDataFound(status: Bool) {
        if status {
        noResultLabel.frame = CGRect(x: 20, y: 20, width: self.view.frame.size.width, height: 20 )
        noResultLabel.text = "No Results found! Try different search"
        noResultLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        collectionView?.addSubview(noResultLabel)
        } else {
            noResultLabel.removeFromSuperview()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: 50)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55 , width: view.frame.size.width, height: view.frame.size.height - 55)
    }
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.autocorrectionType = .yes
        if let text = searchBar.text {
            results = []
            collectionView?.reloadData()
            fetchPhotos(query: text)
        } else {
            
        }
    }
    
    func fetchPhotos(query: String) {  // should be in data sorurce repo
        guard let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=50&query=\(query)&client_id=fDPwDDhHP1mavJqK4tXU7r-bPWqXCJxUnQfGJy2z6W8".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString) else {
            return
        }
        
        AF.request(url).responseDecodable(of: APIResponse.self) { response in
            //debugPrint(response.value.)
            self.results = response.value?.results ?? []
            
            self.setPlaceHolderNoDataFound(status: self.results.isEmpty)
            self.collectionView?.reloadData()
        }
        
//        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
//            guard let data = data, error == nil else {
//                return
//            }
//            do {
//                let jsonResults = try JSONDecoder().decode(APIResponse.self, from: data)
//                DispatchQueue.main.async {
//                    self?.results = jsonResults.results
//                    self?.collectionView?.reloadData()
//                }
//            } catch {
//                print(error)
//            }
//        }
//        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageURLString = results[indexPath.row].urls.regular
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
                return UICollectionViewCell()
        }
        cell.configure(with: imageURLString)
        return cell
    }

}
// move between screens
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        let imageURLString = results[indexPath.row].urls.full
        let vc = DetailViewController.initWith(imageUrl: imageURLString) //.initFromStoryboard()
        
        //vc.imageUrl = imageURLString  //property injection
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIViewController {
    static func initFromStoryboard() -> Self { // Self type
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? Self
            else {
                fatalError("Make sure your have set the ViewController ID in story board ")
        }
        return vc
    }
}

// user defaults (shared preference in android) - keychain (save user credentials or private data) -
// Database -> sqlite, core data, realm (nosql)
