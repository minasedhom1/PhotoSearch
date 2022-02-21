//
//  DetailViewController.swift
//  PhotoSearch
//
//  Created by Mina Sedhom on 1/26/22.
//  Copyright © 2022 Mina Sedhom. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var imageUrl: String?
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBAction func saveImageToLibrary(_ sender: UIBarButtonItem) {
        let imageSaver = ImageSaver()
        
        imageSaver.completion = { status in  // raw value enum.succes = 1 , and associated value enum.success(value)
            switch status {
            case .success:
                let alert = UIAlertController(title: "Photo Saved!", message: "Please check your photo album." , preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true)
                self.saveButton.isEnabled = false
                self.saveButton.tintColor = .clear
               // self.navigationController?.navigationItem.rightBarButtonItems?
                print("Success!")
            case .failure(let error):
                print("Oops: \(error.localizedDescription)")
            }
        }

        guard let uiImage = imageView.image else {
            return
        }
        imageSaver.writeToPhotoAlbum(image: uiImage)
    }
    
    static func initWith(imageUrl: String) -> Self {
        let vc = self.initFromStoryboard()
        vc.imageUrl = imageUrl
        return vc
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       // fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//        imageView.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage(named: "placeholder"))
        imageView.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in self.saveButton.isEnabled = true })
        
        scrollView.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(gestureRecognizer:)))
        tapRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func onDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
        
        if scrollView.zoomScale > 1.0 {
            print(scrollView.zoomScale)
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
            return
        }
            
            let scale = min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)
            
            if scale != scrollView.zoomScale {
            let point = gestureRecognizer.location(in: imageView)
            
            let scrollSize = scrollView.frame.size
            let size = CGSize(width: scrollSize.width / scale,
                              height: scrollSize.height / scale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            scrollView.zoom(to:CGRect(origin: origin, size: size), animated: true)
            print(CGRect(origin: origin, size: size))
             }
    }

    func configure(with urlSring: String) {
        guard let url = URL(string: urlSring) else {
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.imageView.image = image
                // Enable save button
                
            }
        }.resume()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

}
