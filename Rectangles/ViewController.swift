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

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    private func prepareView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(simpleTap))
        mainView.addGestureRecognizer(tap)
    }

    //MARK: - Actions

    @objc
    private func simpleTap(recognizer: UITapGestureRecognizer) {
        //Creation rectangle
        let newRectangle = RectangleView()
        newRectangle.setLocation(recognizer.location(in: view))
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
            let minimum = min(selectedRectangle.frame.width, selectedRectangle.frame.height)
            cornerRadiusSlider.value = Float(cornerRadius / (minimum / 2))
        }
    }

}
