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
    case selector
}

class RectangleView: UIView {

    var delegate: RectangleDelegate?
    private var originalPosition: CGPoint = .zero

    var action: Action = .selector
    private var externalFieldActive: Bool = false
    private var topLeftCornerView = UIView(frame: CGRect(x: -10, y: -10, width: 20, height: 20))

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

        topLeftCornerView.backgroundColor = .black
        topLeftCornerView.isHidden = !externalFieldActive
        topLeftCornerView.layer.cornerRadius = 10
        addSubview(topLeftCornerView)

        let panTopLeftGesture = UIPanGestureRecognizer(target: self, action: #selector(moveTopLeftRectangle))
        topLeftCornerView.addGestureRecognizer(panTopLeftGesture)


        //Add actions
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(simpleTapDone))
        addGestureRecognizer(tap)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveRectangle))
        addGestureRecognizer(panGesture)

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
    private func moveRectangle(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let traslation = recognizer.translation(in: superview)
            frame.origin.x += traslation.x
            frame.origin.y += traslation.y
            recognizer.setTranslation(.zero, in: self)
        default:
            break
        }
    }

    @objc
    private func moveTopLeftRectangle(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let traslation = recognizer.translation(in: superview)
            if frame.size.width > traslation.x {
                frame.origin.x += traslation.x
                frame.size.width -= traslation.x
            }
            if frame.size.height > traslation.y {
                frame.origin.y += traslation.y
                frame.size.height -= traslation.y
            }
            recognizer.setTranslation(.zero, in: self)
        default:
            break
        }
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
        case .selector:
            externalFieldActive = !externalFieldActive
            topLeftCornerView.isHidden = !externalFieldActive
        }
    }

    @objc
    private func selectedExternalField(recognizer: UITapGestureRecognizer) {
        print(recognizer)
    }

    private func randomColor() -> UIColor {
        let hue: CGFloat = CGFloat(arc4random() % 100) / 100.0
        return UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 0.75)
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

    func setAction(_ action: Action) {
        self.action = action
    }

}
