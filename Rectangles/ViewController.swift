//
//  ViewController.swift
//  Rectangles
//
//  Created by Javi Castillo Risco on 29/03/2021.
//

import UIKit

class ViewController: UIViewController {

    private var hueSelector: HueSelector?
    private var selectedRectangle: RectangleView?
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    private func prepareView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(simpleTap))
        view.addGestureRecognizer(tap)
    }

    //MARK: - Helpers

    private func removeCurrentHueSelector() {
        guard hueSelector != nil else {
            return
        }
        hueSelector?.removeFromSuperview()
        hueSelector = nil
    }


    //MARK: - Actions

    @objc
    private func simpleTap(recognizer: UITapGestureRecognizer) {
        //Creation rectangle
        let newRectangle = RectangleView()
        newRectangle.setLocation(recognizer.location(in: view))
        newRectangle.delegate = self
        view.addSubview(newRectangle)

        //Remove HueSelector
        removeCurrentHueSelector()
    }

}

extension ViewController: RectangleDelegate {

    func createHueSelector(for rectangle: RectangleView) {
        selectedRectangle = rectangle
        let currentColor = rectangle.backgroundColor
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        currentColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        removeCurrentHueSelector()
        hueSelector = HueSelector(hue: Float(hue), position: view.center)
        hueSelector?.delegate = self
        view.addSubview(hueSelector!)
    }

}

extension ViewController: HueDelegate {

    func hueChanged(_ newHue: Float) {
        selectedRectangle?.setHue(newHue)
    }

}
