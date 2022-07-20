//
//  ZoomableImageView.swift
//  APOD
//
//  Created by Михаил Мезенцев on 18.07.2022.
//

import UIKit

protocol ZoomableImageDelegate {
    func didFrameChange()
}

class ZoomableImageView: UIImageView {
    
    override var frame: CGRect {
        didSet {
            delegate?.didFrameChange()
        }
    }
    
    var delegate: ZoomableImageDelegate?
}
