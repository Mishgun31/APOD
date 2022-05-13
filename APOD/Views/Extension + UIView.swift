//
//  Extension + UIView.swift
//  APOD
//
//  Created by Михаил Мезенцев on 29.04.2022.
//

import UIKit

extension UIView {
    func setColorsFor(darkMode darkColor: UIColor, lightMode lightColor: UIColor) -> UIColor {
        UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return darkColor
            default:
                return lightColor
            }
        }
    }
    
    func setupShadow(radius: CGFloat,
                     opacity: Float,
                     offset: CGSize,
                     darkModeColor: UIColor,
                     lightModeColor: UIColor) {
        
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        
        layer.shadowColor = setColorsFor(
            darkMode: darkModeColor,
            lightMode: lightModeColor
        ).cgColor
    }
}
