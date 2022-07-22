//
//  FullScreenImageViewController.swift
//  APOD
//
//  Created by Михаил Мезенцев on 06.07.2022.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        isViewModeOn
    }
     
    var astronomyPicture: AstronomyPicture!
    
    private var imageScrollView: ImageScrollView!
    
    private var isViewModeOn = false {
        didSet {
            switchViewAppearance()
        }
    }
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var singleTap: UITapGestureRecognizer = {
        let singleTap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleSingleTap)
        )
        return singleTap
    }()
    
    private lazy var doubleTap: UITapGestureRecognizer = {
        let doubleTap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleDoubleTap)
        )
        doubleTap.numberOfTapsRequired = 2
        return doubleTap
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        imageScrollView.addGestureRecognizer(singleTap)
        imageScrollView.addGestureRecognizer(doubleTap)
        
        singleTap.delegate = self
        doubleTap.delegate = self
    }
    
    @IBAction func actionButtonPressed(_ sender: UIBarButtonItem) {
        guard let photoForSharing = imageScrollView.imageZoomView.image else {
            return
        }
        
        let activityController = UIActivityViewController(
            activityItems: [photoForSharing],
            applicationActivities: nil
        )
        
        present(activityController, animated: true)
    }
}

// MARK: - Private methods, Work with views

extension FullScreenImageViewController {
    
    private func setupViews() {
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        imageScrollView.contentInsetAdjustmentBehavior = .never
        
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor)
            .isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            .isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            .isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            .isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        
        loadImage()
    }
    
    private func switchViewAppearance() {
        if isViewModeOn {
            navigationController?.isNavigationBarHidden = true
            view.backgroundColor = .black
        } else {
            navigationController?.isNavigationBarHidden = false
            view.backgroundColor = .systemBackground
        }
    }
    
    private func loadImage() {
        let hdImageUrl = astronomyPicture.hdurl ?? ""
        
        let _ = CacheManager.shared.getImage(with: hdImageUrl) {
            [weak self] imageData in
            
            if let hdImage = UIImage(data: imageData) {
                self?.imageScrollView.set(image: hdImage)
            } else {
                let systemImage = UIImage(systemName: "photo") ?? UIImage()
                self?.imageScrollView.set(image: systemImage)
            }
            
            self?.imageScrollView.imageZoomView.delegate = self
            self?.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - Gesture Recognizer Delegate, Handling gestures

extension FullScreenImageViewController: UIGestureRecognizerDelegate {
    
    @objc private func handleSingleTap() {
        isViewModeOn.toggle()
    }
    
    @objc private func handleDoubleTap() {
        isViewModeOn.toggle()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if gestureRecognizer == singleTap && otherGestureRecognizer == doubleTap {
            return true
        }
        return false
    }
}

// MARK: - Zoomable Image Delegate

extension FullScreenImageViewController: ZoomableImageDelegate {
    
    func didFrameChange() {
        if !isViewModeOn {
            isViewModeOn.toggle()
        }
    }
}
