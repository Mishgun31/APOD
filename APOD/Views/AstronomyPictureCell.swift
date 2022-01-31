//
//  AstronomyPictureCell.swift
//  APOD
//
//  Created by Михаил Мезенцев on 19.12.2021.
//

import UIKit

class AstronomyPictureCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var astronomyImage: UIImageView!
    
    func configure(with data: AstronomyPicture?) {
        dateLabel.text = data?.date
        titleLabel.text = data?.title
        
        astronomyImage.image = UIImage(named: "SwiftImage")
        
        CacheManager.shared.getImage(with: data?.url ?? "") { image in
            self.astronomyImage.image = image
        }
    }
    
//    private func setImageHeightConstarint(with image: UIImage?) {
//        if let image = image {
//            let imageRatio = image.size.height / image.size.width
//            let newHeight = UIScreen.main.bounds.width * imageRatio
//            imageHeightConstraint.constant = newHeight
//        }
//    }
}

