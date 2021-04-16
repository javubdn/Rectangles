//
//  RectangleView.swift
//  Rectangles
//
//  Created by Javi Castillo Risco on 30/03/2021.
//

import UIKit

protocol RectangleDelegate {

    func rectangleSelected(_ rectangle: RectangleView)

}

enum Action {
    case duplicate
    case rotate
    case reduce
}

class RectangleView: UIView {

    var delegate: RectangleDelegate?

    private var originalPosition: CGPoint?
    var action: Action = .duplicate

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
        delegate?.rectangleSelected(self)
    }

    @objc
    private func doubleTapDone(recognizer: UITapGestureRecognizer) {
        switch action {
        case .rotate:
            frame = CGRect(x: frame.minX, y: frame.minY, width: frame.height, height: frame.width)
        case .duplicate:
            frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width * 2, height: frame.height * 2)
        case .reduce:
            frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width / 2, height: frame.height / 2)
        }

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

    func setAction(_ action: Action) {
        self.action = action
    }

}
