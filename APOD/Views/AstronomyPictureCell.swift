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
    @IBOutlet weak var videoIconImage: UIImageView!
    
    @IBOutlet weak var backgroundCellView: UIView!
    
    private var imageRequest: Cancellable?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        astronomyImage.image = nil
        videoIconImage.isHidden = true
        imageRequest?.cancel()
    }
    
    func configure(with data: AstronomyPicture?) {
        setupAppearance()
        astronomyImage.image = UIImage(systemName: "photo")
        dateLabel.text = data?.date
        titleLabel.text = data?.title
        
        var imageUrl = data?.url
        
        if data?.thumbnailUrl != nil {
            imageUrl = data?.thumbnailUrl
            videoIconImage.isHidden = false
        }
        
        imageRequest = CacheManager.shared.getImage(with: imageUrl ?? "") {
            [weak self] imageData in
            
            self?.astronomyImage.image = UIImage(data: imageData)
        }
    }
    
    private func setupAppearance() {
        backgroundCellView.layer.cornerRadius = 15
        backgroundCellView.setupShadow(
            radius: 5,
            opacity: 0.5,
            offset: CGSize(width: 1, height: 1),
            darkModeColor: .white,
            lightModeColor: .black
        )
    }
}
