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
    private var topLeftCornerView = UIView(frame: CGRect(x: -20, y: -20, width: 40, height: 40))
    private var topRightCornerView = UIView(frame: CGRect(x: 0, y: -20, width: 40, height: 40))
    private var bottomLeftCornerView = UIView(frame: CGRect(x: -20, y: 0, width: 40, height: 40))
    private var bottomRightCornerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

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

        topRightCornerView.center.x = bounds.maxX
        topRightCornerView.backgroundColor = .black
        topRightCornerView.isHidden = !externalFieldActive
        topRightCornerView.layer.cornerRadius = 10
        addSubview(topRightCornerView)

        let panTopRightGesture = UIPanGestureRecognizer(target: self, action: #selector(moveTopRightRectangle))
        topRightCornerView.addGestureRecognizer(panTopRightGesture)

        bottomLeftCornerView.center.y = bounds.maxY
        bottomLeftCornerView.backgroundColor = .black
        bottomLeftCornerView.isHidden = !externalFieldActive
        bottomLeftCornerView.layer.cornerRadius = 10
        addSubview(bottomLeftCornerView)

        let panBottomLeftGesture = UIPanGestureRecognizer(target: self, action: #selector(moveBottomLeftRectangle))
        bottomLeftCornerView.addGestureRecognizer(panBottomLeftGesture)

        bottomRightCornerView.center.x = bounds.maxX
        bottomRightCornerView.center.y = bounds.maxY
        bottomRightCornerView.backgroundColor = .black
        bottomRightCornerView.isHidden = !externalFieldActive
        bottomRightCornerView.layer.cornerRadius = 10
        addSubview(bottomRightCornerView)

        let panBottomRightGesture = UIPanGestureRecognizer(target: self, action: #selector(moveBottomRightRectangle))
        bottomRightCornerView.addGestureRecognizer(panBottomRightGesture)

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
            let translation = recognizer.translation(in: superview)
            frame.origin.x += translation.x
            frame.origin.y += translation.y
            recognizer.setTranslation(.zero, in: self)
        default:
            break
        }
    }

    @objc
    private func moveTopLeftRectangle(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: superview)
            if frame.size.width > translation.x {
                frame.origin.x += translation.x
                frame.size.width -= translation.x
            }
            if frame.size.height > translation.y {
                frame.origin.y += translation.y
                frame.size.height -= translation.y
            }
            recognizer.setTranslation(.zero, in: self)
            topRightCornerView.center.x = bounds.maxX
            bottomLeftCornerView.center.y = bounds.maxY
            bottomRightCornerView.center.x = bounds.maxX
            bottomRightCornerView.center.y = bounds.maxY
        default:
            break
        }
    }

    @objc
    private func moveTopRightRectangle(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: superview)
            if translation.x < 0 {
                if frame.size.width > abs(translation.x) {
                    frame.size.width += translation.x
                } else {
                    frame.size.width = 0
                }
            } else {
                frame.size.width += translation.x
            }

            if frame.size.height > translation.y {
                frame.origin.y += translation.y
                frame.size.height -= translation.y
            }
            recognizer.setTranslation(.zero, in: self)
            topRightCornerView.center.x = bounds.maxX
            bottomLeftCornerView.center.y = bounds.maxY
            bottomRightCornerView.center.x = bounds.maxX
            bottomRightCornerView.center.y = bounds.maxY
        default:
            break
        }
    }

    @objc
    private func moveBottomLeftRectangle(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: superview)
            if frame.size.width > translation.x {
                frame.origin.x += translation.x
                frame.size.width -= translation.x
            }
            if translation.y < 0 {
                if frame.size.height > abs(translation.y) {
                    frame.size.height += translation.y
                } else {
                    frame.size.height = 0
                }
            } else {
                frame.size.height += translation.y
            }
            recognizer.setTranslation(.zero, in: self)
            topRightCornerView.center.x = bounds.maxX
            bottomLeftCornerView.center.y = bounds.maxY
            bottomRightCornerView.center.x = bounds.maxX
            bottomRightCornerView.center.y = bounds.maxY
        default:
            break
        }
    }

    @objc
    private func moveBottomRightRectangle(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: superview)
            if translation.x < 0 {
                if frame.size.width > abs(translation.x) {
                    frame.size.width += translation.x
                } else {
                    frame.size.width = 0
                }
            } else {
                frame.size.width += translation.x
            }
            if translation.y < 0 {
                if frame.size.height > abs(translation.y) {
                    frame.size.height += translation.y
                } else {
                    frame.size.height = 0
                }
            } else {
                frame.size.height += translation.y
            }
            recognizer.setTranslation(.zero, in: self)
            topRightCornerView.center.x = bounds.maxX
            bottomLeftCornerView.center.y = bounds.maxY
            bottomRightCornerView.center.x = bounds.maxX
            bottomRightCornerView.center.y = bounds.maxY
        default:
            break
        }
    }

    @objc
    private func doubleTapDone(recognizer: UITapGestureRecognizer) {
        switch action {
        case .rotate:
            frame = CGRect(x: frame.minX, y: frame.minY, width: frame.height, height: frame.width)
            topRightCornerView.center.x = bounds.maxX
            bottomLeftCornerView.center.y = bounds.maxY
            bottomRightCornerView.center.x = bounds.maxX
            bottomRightCornerView.center.y = bounds.maxY
        case .duplicate:
            frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width * 2, height: frame.height * 2)
            topRightCornerView.center.x = bounds.maxX
            bottomLeftCornerView.center.y = bounds.maxY
            bottomRightCornerView.center.x = bounds.maxX
            bottomRightCornerView.center.y = bounds.maxY
        case .reduce:
            frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width / 2, height: frame.height / 2)
            topRightCornerView.center.x = bounds.maxX
            bottomLeftCornerView.center.y = bounds.maxY
            bottomRightCornerView.center.x = bounds.maxX
            bottomRightCornerView.center.y = bounds.maxY
        case .selector:
            externalFieldActive = !externalFieldActive
            topLeftCornerView.isHidden = !externalFieldActive
            topRightCornerView.isHidden = !externalFieldActive
            bottomLeftCornerView.isHidden = !externalFieldActive
            bottomRightCornerView.isHidden = !externalFieldActive
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

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if topLeftCornerView.point(inside: convert(point, to: topLeftCornerView), with: event) && externalFieldActive {
            return topLeftCornerView
        }
        if topRightCornerView.point(inside: convert(point, to: topRightCornerView), with: event) && externalFieldActive {
            return topRightCornerView
        }
        if bottomLeftCornerView.point(inside: convert(point, to: bottomLeftCornerView), with: event) && externalFieldActive {
            return bottomLeftCornerView
        }
        if bottomRightCornerView.point(inside: convert(point, to: bottomRightCornerView), with: event) && externalFieldActive {
            return bottomRightCornerView
        }
        if self.point(inside: convert(point, to: self), with: event) {
            return self
        }

        return super.hitTest(point, with: event)
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
        if action != .selector {
            externalFieldActive = false
            topLeftCornerView.isHidden = !externalFieldActive
            topRightCornerView.isHidden = !externalFieldActive
            bottomLeftCornerView.isHidden = !externalFieldActive
            bottomRightCornerView.isHidden = !externalFieldActive
        }
    }

}
