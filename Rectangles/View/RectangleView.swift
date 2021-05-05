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

    private enum Movement {
        case positive
        case negative
        case zero
    }

    var delegate: RectangleDelegate?
    private var originalPosition: CGPoint = .zero

    var action: Action = .selector
    private var externalFieldActive: Bool = false
    private var topLeftCornerView = UIView(frame: CGRect(x: -10, y: -10, width: 20, height: 20))
    private var topRightCornerView = UIView(frame: CGRect(x: 0, y: -10, width: 20, height: 20))
    private var bottomLeftCornerView = UIView(frame: CGRect(x: -10, y: 0, width: 20, height: 20))
    private var bottomRightCornerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))

    private var topExtensionView = UIView(frame: CGRect(x: 10, y: -10, width: 0, height: 20))
    private var leftExtensionView = UIView(frame: CGRect(x: -10, y: 10, width: 20, height: 0))
    private var rightExtensionView = UIView(frame: CGRect(x: 0, y: 10, width: 20, height: 0))
    private var bottomExtensionView = UIView(frame: CGRect(x: 10, y: 0, width: 0, height: 20))

    private var currentWidth: CGFloat = 0
    private var currentHeight: CGFloat = 0

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

        topLeftCornerView.layer.cornerRadius = 10
        topLeftCornerView.layer.maskedCorners = [.layerMinXMinYCorner]

        topRightCornerView.layer.cornerRadius = 10
        topRightCornerView.layer.maskedCorners = [.layerMaxXMinYCorner]

        bottomLeftCornerView.layer.cornerRadius = 10
        bottomLeftCornerView.layer.maskedCorners = [.layerMinXMaxYCorner]

        bottomRightCornerView.layer.cornerRadius = 10
        bottomRightCornerView.layer.maskedCorners = [.layerMaxXMaxYCorner]

        let externalViews = [topLeftCornerView, topRightCornerView, bottomLeftCornerView, bottomRightCornerView, topExtensionView, leftExtensionView, rightExtensionView, bottomExtensionView]

        for externalView in externalViews {
            externalView.backgroundColor = .black
            addSubview(externalView)
            let panExtensionGesture = UIPanGestureRecognizer(target: self, action: #selector(move))
            externalView.addGestureRecognizer(panExtensionGesture)
        }

        updateResizerViews()
        updateResizerVisibility()

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

        addInteraction(UIContextMenuInteraction(delegate: self))

        addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotateRectangle)))

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
            let translation = recognizer.translation(in: self)
//            frame.origin.x += translation.x
//            frame.origin.y += translation.y
//            recognizer.setTranslation(.zero, in: self)

            if recognizer.state == .began || recognizer.state == .changed {
                transform = transform.translatedBy(x: translation.x, y: translation.y)
                recognizer.setTranslation(.zero, in: self)
            }
        default:
            break
        }
    }

    @objc
    private func move(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: self)
            switch recognizer.view {
            case topLeftCornerView:
                moveExtensionView(translation: translation, horizontal: .negative, vertical: .negative)
            case topRightCornerView:
                moveExtensionView(translation: translation, horizontal: .positive, vertical: .negative)
            case bottomLeftCornerView:
                moveExtensionView(translation: translation, horizontal: .negative, vertical: .positive)
            case bottomRightCornerView:
                moveExtensionView(translation: translation, horizontal: .positive, vertical: .positive)
            case topExtensionView:
                moveExtensionView(translation: translation, horizontal: .zero, vertical: .negative)
            case leftExtensionView:
                moveExtensionView(translation: translation, horizontal: .negative, vertical: .zero)
            case rightExtensionView:
                moveExtensionView(translation: translation, horizontal: .positive, vertical: .zero)
            case bottomExtensionView:
                moveExtensionView(translation: translation, horizontal: .zero, vertical: .positive)
            default:
                break
            }
            recognizer.setTranslation(.zero, in: self)
            updateResizerViews()
        default:
            break
        }
    }

    @objc
    private func doubleTapDone(recognizer: UITapGestureRecognizer) {
        switch action {
        case .rotate:
            frame = CGRect(x: frame.minX, y: frame.minY, width: frame.height, height: frame.width)
            updateResizerViews()
        case .duplicate:
            frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width * 2, height: frame.height * 2)
            updateResizerViews()
        case .reduce:
            frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width / 2, height: frame.height / 2)
            updateResizerViews()
        case .selector:
            externalFieldActive = !externalFieldActive
            updateResizerVisibility()
        }
    }

    @objc
    private func rotateRectangle(recognizer: UIRotationGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            transform = transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
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
        if topExtensionView.point(inside: convert(point, to: topExtensionView), with: event) && externalFieldActive {
            return topExtensionView
        }
        if leftExtensionView.point(inside: convert(point, to: leftExtensionView), with: event) && externalFieldActive {
            return leftExtensionView
        }
        if rightExtensionView.point(inside: convert(point, to: rightExtensionView), with: event) && externalFieldActive {
            return rightExtensionView
        }
        if bottomExtensionView.point(inside: convert(point, to: bottomExtensionView), with: event) && externalFieldActive {
            return bottomExtensionView
        }
        if self.point(inside: convert(point, to: self), with: event) {
            return self
        }

        return super.hitTest(point, with: event)
    }

    //MARK: - Helper methods

    private func randomColor() -> UIColor {
        let hue: CGFloat = CGFloat(arc4random() % 100) / 100.0
        return UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 0.75)
    }

    private func updateResizerViews() {
        topRightCornerView.center.x = bounds.maxX
        bottomLeftCornerView.center.y = bounds.maxY
        bottomRightCornerView.center.x = bounds.maxX
        bottomRightCornerView.center.y = bounds.maxY
        topExtensionView.frame.size.width = frame.width > 20 ? frame.width - 20 : 0
        leftExtensionView.frame.size.height = frame.height > 20 ? frame.height - 20 : 0
        rightExtensionView.center.x = bounds.maxX
        rightExtensionView.frame.size.height = frame.height > 20 ? frame.height - 20 : 0
        bottomExtensionView.center.y = bounds.maxY
        bottomExtensionView.frame.size.width = frame.width > 20 ? frame.width - 20 : 0
    }

    private func updateResizerVisibility() {
        topLeftCornerView.isHidden = !externalFieldActive
        topRightCornerView.isHidden = !externalFieldActive
        bottomLeftCornerView.isHidden = !externalFieldActive
        bottomRightCornerView.isHidden = !externalFieldActive
        topExtensionView.isHidden = !externalFieldActive
        leftExtensionView.isHidden = !externalFieldActive
        rightExtensionView.isHidden = !externalFieldActive
        bottomExtensionView.isHidden = !externalFieldActive
    }

    private func moveExtensionView(translation: CGPoint, horizontal: Movement, vertical: Movement) {
        currentWidth = bounds.size.width
        currentHeight = bounds.size.height

        if horizontal == .positive {
            transform =  transform.scaledBy(x: (currentWidth + translation.x)/currentWidth, y: 1.0)
            transform = transform.translatedBy(x: translation.x/2, y: 0.0)
        } else if horizontal == .negative {
            transform =  transform.scaledBy(x: (currentWidth - translation.x)/currentWidth, y: 1.0)
            transform = transform.translatedBy(x: translation.x/2, y: 0.0)
        }

        if vertical == .positive {
            transform =  transform.scaledBy(x: 1.0, y: (currentHeight + translation.y)/currentHeight)
            transform = transform.translatedBy(x: 0.0, y: translation.y/2)
        } else if vertical == .negative {
            transform =  transform.scaledBy(x: 1.0, y: (currentHeight - translation.y)/currentHeight)
            transform = transform.translatedBy(x: 0.0, y: translation.y/2)
        }


//        if horizontal == .positive {
//            if translation.x < 0 && frame.size.width <= abs(translation.x) {
//                frame.size.width = 0
//            } else {
//                frame.size.width += translation.x
//            }
//        } else if horizontal == .negative {
//            if frame.size.width > translation.x {
//                frame.origin.x += translation.x
//                frame.size.width -= translation.x
//            }
//        }
//
//        if vertical == .positive {
//            if translation.y < 0 && frame.size.height <= abs(translation.y) {
//                frame.size.height = 0
//            } else {
//                frame.size.height += translation.y
//            }
//        } else if vertical == .negative {
//            if frame.size.height > translation.y {
//                frame.origin.y += translation.y
//                frame.size.height -= translation.y
//            }
//        }
//        recalculateCornerRadius()
    }

    private func recalculateCornerRadius() {
        let cornerRadius: CGFloat = layer.cornerRadius
        let proportion = cornerRadius/min(currentWidth, currentHeight)
        let minimum = min(frame.width, frame.height)
        let radius = proportion * minimum
        layer.cornerRadius = CGFloat(radius)
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
            updateResizerVisibility()
        }
    }

}

extension RectangleView: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), attributes: .destructive) { _ in
            self.removeFromSuperview()
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "Acciones", children: [delete])
        }
    }
}
