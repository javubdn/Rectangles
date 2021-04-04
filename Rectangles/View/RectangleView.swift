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

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareRectangle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareRectangle()
    }

    private func prepareRectangle() {
        backgroundColor = randomColor()

        //Add actions
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(simpleTapDone))
        addGestureRecognizer(tap)

        let doubleTap = UITapGestureRecognizer()
        doubleTap.addTarget(self, action: #selector(doubleTapDone))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
    }

    @objc
    private func simpleTapDone(recognizer: UITapGestureRecognizer) {
        superview?.bringSubviewToFront(self)
        delegate?.createHueSelector(for: self)
    }

    @objc
    private func doubleTapDone(recognizer: UITapGestureRecognizer) {

    }

    func setLocation(_ location: CGPoint) {
        originalPosition = location
        let MAXSize: CGFloat = 150
        let MINSize: CGFloat = 30
        let diff = MAXSize - MINSize
        let newWidth = CGFloat(arc4random()) / CGFloat(UINT32_MAX) * diff + MINSize
        let newHeight = CGFloat(arc4random()) / CGFloat(UINT32_MAX) * diff + MINSize
        let newX = location.x - newWidth/2
        let newY = location.y - newHeight/2
        self.frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
    }

    private func randomColor() -> UIColor {
        let hue: CGFloat = CGFloat(arc4random() % 100) / 100.0
        return UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 0.75)
    }

}
