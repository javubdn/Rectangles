//
//  CustomSlider.swift
//  Rectangles
//
//  Created by Javi Castillo Risco on 09/04/2021.
//

import UIKit

class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 20))
    }
}
