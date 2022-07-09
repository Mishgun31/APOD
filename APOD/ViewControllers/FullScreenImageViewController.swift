//
//  FullScreenImageViewController.swift
//  APOD
//
//  Created by Михаил Мезенцев on 06.07.2022.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    
    var astronomyPicture: AstronomyPicture!
    
    private var imageScrollView: ImageScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        imageScrollView.set(image: UIImage(named: "photoExample") ?? UIImage())
        
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor)
            .isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            .isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            .isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            .isActive = true
    }
}
