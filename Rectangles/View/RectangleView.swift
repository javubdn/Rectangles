//
//  RectangleView.swift
//  Rectangles
//
//  Created by Javi Castillo Risco on 30/03/2021.
//

import UIKit

protocol RectangleDelegate {

    func createHueSelector(for rectangle: RectangleView)
    func rectangleSelected(_ rectangle: RectangleView)

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
        layer.cornerRadius = 10
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
//        delegate?.createHueSelector(for: self)
        delegate?.rectangleSelected(self)
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        originalPosition = center
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let position = touch.location(in: superview)
        UIView.animate(withDuration: 0.001) {
            self.center = CGPoint(x: position.x, y: position.y)
        }
    }

    //MARK: - Public methods

    func setHue(_ hue: Float) {
        backgroundColor = UIColor(hue: CGFloat(hue), saturation: 1, brightness: 1, alpha: 0.75)
    }

    func setCornerRadius(_ cornerRadius: Float) {
        let minimum = min(frame.width, frame.height)
        let radius = CGFloat(cornerRadius) * (minimum / 2)
        layer.cornerRadius = CGFloat(radius)
    }

}
