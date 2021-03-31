//
//  RectangleView.swift
//  Rectangles
//
//  Created by Javi Castillo Risco on 30/03/2021.
//

import UIKit

protocol RectangleDelegate {

    func createHueSelector(for rectangle: RectangleView)

}

class RectangleView: UIView {

    var delegate: RectangleDelegate?

    private var originalPosition: CGPoint?

    func setLocation(_ location: CGPoint) {
        originalPosition = location
        let MAXSize: CGFloat = 150
        let MINSize: CGFloat = 30
        let diff = MAXSize - MINSize
        let newWidth = CGFloat((arc4random() / UINT32_MAX)) * diff + MINSize
        let newHeight = CGFloat((arc4random() / UINT32_MAX)) * diff + MINSize
        let newX = location.x - newWidth/2
        let newY = location.y - newHeight/2
        frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
    }

}
