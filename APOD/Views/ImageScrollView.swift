//
//  ImageScrollView.swift
//  APOD
//
//  Created by Михаил Мезенцев on 07.07.2022.
//

import UIKit

class ImageScrollView: UIScrollView {
    
    private var imageZoomView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(image: UIImage) {
        imageZoomView = UIImageView(image: image)
        addSubview(imageZoomView)
        configureFor(imageSize: image.size)
    }
    
    private func configureFor(imageSize: CGSize) {
        contentSize = imageSize
        updateMinZoomScale()
    }
    
    private func updateMinZoomScale() {
        let viewSize = bounds.size
        let imageSize = imageZoomView.bounds.size
        
        let widthScale = viewSize.width / imageSize.width
        let heightScale = viewSize.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        minimumZoomScale = minScale
        zoomScale = minScale
    }
    
    private func centerImage() {
        let viewSize = bounds.size
        var imageFrame = imageZoomView.frame
        
        let xOffset = max(0, (viewSize.width - imageFrame.width) / 2)
        let yOffset = max(0, (viewSize.height - imageFrame.height) / 2)
        
        imageFrame.origin.x = xOffset
        imageFrame.origin.y = yOffset
        
        imageZoomView.frame = imageFrame
    }
}

// MARK: - ScrollView Delegate

extension ImageScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageZoomView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
