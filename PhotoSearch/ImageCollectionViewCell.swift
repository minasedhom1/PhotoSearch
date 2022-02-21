//
//  ImageCollectionViewCell.swift
//  PhotoSearch
//
//  Created by Mina Sedhom on 1/26/22.
//  Copyright © 2022 Mina Sedhom. All rights reserved.
//

import UIKit
import SDWebImage
class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImageCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // download image from url - SD web image - kingfisher in cocoaPods or swift package(newer)
    func configure(with urlSring: String) {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: URL(string: urlSring), placeholderImage: UIImage(named: "placeholder"))
//        guard let url = URL(string: urlSring) else {
//            return
//        }
//        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
//            guard let data = data, error == nil else {
//                return
//            }
//            DispatchQueue.main.async {
//                let image = UIImage(data: data)
//                self?.imageView.image = image
//            }
//        }.resume()
   }
}


