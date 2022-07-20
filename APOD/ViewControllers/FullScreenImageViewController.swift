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
    private var isViewModeOn = false {
        didSet {
            switchViewAppearance()
        }
    }
    
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
    
    override var prefersStatusBarHidden: Bool {
        isViewModeOn
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        imageScrollView.addGestureRecognizer(singleTap)
        imageScrollView.addGestureRecognizer(doubleTap)
        
        singleTap.delegate = self
        doubleTap.delegate = self
        
        imageScrollView.imageZoomView.delegate = self
    }
    
    @objc private func handleSingleTap() {
        isViewModeOn.toggle()
    }
    
    @objc private func handleDoubleTap() {
        isViewModeOn.toggle()
    }
        
    private func setupViews() {
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        imageScrollView.set(image: UIImage(named: "photoExample") ?? UIImage())
        imageScrollView.contentInsetAdjustmentBehavior = .never
        
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor)
            .isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            .isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            .isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            .isActive = true
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
}

// MARK: - Gesture Recognizer Delegate

extension FullScreenImageViewController: UIGestureRecognizerDelegate {

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
