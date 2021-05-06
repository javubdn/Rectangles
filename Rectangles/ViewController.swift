//
//  ViewController.swift
//  Rectangles
//
//  Created by Javi Castillo Risco on 29/03/2021.
//

import UIKit

class ViewController: UIViewController {

    private var selectedRectangle: RectangleView?

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var hueSlider: UISlider!
    @IBOutlet weak var cornerRadiusSlider: UISlider!
    @IBOutlet weak var optionDCView: ItemSelector!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    private func prepareView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(simpleTap))
        mainView.addGestureRecognizer(tap)
        optionDCView.listItems = ["Duplicate", "Invert", "Reduce", "Selector"]
        optionDCView.delegate = self
    }

    //MARK: - Actions

    @objc
    private func simpleTap(recognizer: UITapGestureRecognizer) {
        //Creation rectangle
        let MAXSize: CGFloat = 150
        let MINSize: CGFloat = 40
        let diff = MAXSize - MINSize
        let newWidth = CGFloat(arc4random()) / CGFloat(UINT32_MAX) * diff + MINSize
        let newHeight = CGFloat(arc4random()) / CGFloat(UINT32_MAX) * diff + MINSize
        let newX = recognizer.location(in: view).x - newWidth/2
        let newY = recognizer.location(in: view).y - newHeight/2
        let frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        let newRectangle = RectangleView(frame: frame)
        newRectangle.delegate = self
        view.addSubview(newRectangle)
        rectangleSelected(newRectangle)
    }

    @IBAction func hueSliderChanged(_ sender: UISlider) {
        selectedRectangle?.setHue(sender.value)
    }

    @IBAction func cornerRadiusSliderChanged(_ sender: UISlider) {
        selectedRectangle?.setCornerRadius(sender.value)
    }
}

extension ViewController: RectangleDelegate {

    func rectangleSelected(_ rectangle: RectangleView) {
        selectedRectangle = rectangle
        let currentColor = rectangle.backgroundColor
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        currentColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        hueSlider.value = Float(hue)
        if let selectedRectangle = selectedRectangle {
            let cornerRadius: CGFloat = selectedRectangle.layer.cornerRadius
            let minimum = min(selectedRectangle.bounds.width, selectedRectangle.bounds.height)
            cornerRadiusSlider.value = Float(cornerRadius / (minimum / 2))
            switch selectedRectangle.action {
            case .duplicate:
                optionDCView.currentIndex = 0
            case .rotate:
                optionDCView.currentIndex = 1
            case .reduce:
                optionDCView.currentIndex = 2
            case .selector:
                optionDCView.currentIndex = 3
            }
        }
    }

}

extension ViewController: ItemSelectorDelegate {

    func valueChanged(_ selector: ItemSelector) {
        if selector.currentIndex == 0 {
            selectedRectangle?.setAction(.duplicate)
        } else if selector.currentIndex == 1 {
            selectedRectangle?.setAction(.rotate)
        } else if selector.currentIndex == 2 {
            selectedRectangle?.setAction(.reduce)
        } else if selector.currentIndex == 3 {
            selectedRectangle?.setAction(.selector)
        }

    }

}
