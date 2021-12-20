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
        Networker.shared.fetchImage(with: data?.url ?? "") { imageData in
            self.astronomyImage.image = UIImage(data: imageData)
        }
    }
}
