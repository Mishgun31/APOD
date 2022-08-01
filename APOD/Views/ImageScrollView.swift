//
//  ImageScrollView.swift
//  APOD
//
//  Created by Михаил Мезенцев on 07.07.2022.
//

import UIKit

class ImageScrollView: UIScrollView {
    
    private(set) var imageZoomView: ZoomableImageView!
    
    lazy private var zoomingTap: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleZoomingTap)
        )
        zoomingTap.numberOfTapsRequired = 2
        return zoomingTap
    }()
    
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
        imageZoomView = ZoomableImageView(image: image)
        addSubview(imageZoomView)
        configureFor(imageSize: image.size)
    }
}

// MARK: - Handle image

extension ImageScrollView {
    
    @objc private func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        zoom(atPoint: location, animated: true)
    }
    
    private func configureFor(imageSize: CGSize) {
        contentSize = imageSize
        updateMinZoomScale()
        imageZoomView.addGestureRecognizer(zoomingTap)
        imageZoomView.isUserInteractionEnabled = true
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
    
    private func zoom(atPoint point: CGPoint, animated: Bool) {
        let newScale = (zoomScale == minimumZoomScale)
        ? maximumZoomScale
        : minimumZoomScale
        
        let zoomRect = zoomRect(scale: newScale, center: point)
        zoom(to: zoomRect, animated: animated)
    }
    
    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect()
        
        zoomRect.size.width = bounds.width / scale
        zoomRect.size.height = bounds.height / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        
        return zoomRect
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
