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
    
    @IBOutlet weak var backgroundCellView: UIView!
    
    private var imageRequest: Cancellable?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        astronomyImage.image = nil
        imageRequest?.cancel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundCellView.layer.shadowPath = UIBezierPath(
            roundedRect: backgroundCellView.bounds,
            cornerRadius: 5
        ).cgPath
    }
    
    func configure(with data: AstronomyPicture?) {
        backgroundCellView.layer.cornerRadius = 15
        backgroundCellView.setupShadow(
            radius: 5,
            opacity: 0.5,
            offset: CGSize(width: 1, height: 1),
            darkModeColor: .white,
            lightModeColor: .black
        )
        
        dateLabel.text = data?.date
        titleLabel.text = data?.title
        self.astronomyImage.image = UIImage(systemName: "photo")
        
        imageRequest = CacheManager.shared.getImage(with: data?.url ?? "") {
            [weak self] imageData in
            
            self?.astronomyImage.image = UIImage(data: imageData)
        }
    }
}
