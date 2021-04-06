//
//  HueSelector.swift
//  Rectangles
//
//  Created by Javi Castillo Risco on 31/03/2021.
//

import UIKit

protocol HueDelegate {

    func hueChanged(_ newHue: Float)

}

class HueSelector: UIView {
    private var slider: UISlider?
    private var hue: Float?
    var delegate: HueDelegate?

    convenience init(hue: Float?, position: CGPoint) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.hue = hue
        prepareHueSelector(with: position)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareSelector()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareSelector()
    }

    private func prepareSelector() {

    }

    private func prepareHueSelector(with position: CGPoint) {
        let width = 150
        let height = 80
        self.frame = CGRect(x: Int(position.x - CGFloat(width/2)), y: Int(position.y - CGFloat(height/2)), width: width, height: height)
        backgroundColor = .white

        //Create slider
        slider = UISlider(frame: CGRect(x: 10, y: 10, width: width-20, height: height-20))
        slider?.value = Float(hue!)
        slider?.addTarget(self, action:#selector(sliderValueChanged), for: .valueChanged)

        addSubview(slider!)

    }

    @objc
    private func sliderValueChanged() {
        hue = slider?.value
        delegate?.hueChanged(hue!)
    }

}
