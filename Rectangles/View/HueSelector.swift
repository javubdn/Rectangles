//
//  HueSelector.swift
//  Rectangles
//
//  Created by Javi Castillo Risco on 31/03/2021.
//

import UIKit

class HueSelector: UIView {
    private var slider: UISlider?
    private var hue: CGFloat?

    convenience init(hue: CGFloat?, position: CGPoint) {
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
        let width: CFloat = 150
        let height: CFloat = 80
        self.frame = CGRect(x: 9, y: 9, width: 9, height: 9)
//        frame = CGRect(x: position.x, y: position.y, width: width, height: height)
        backgroundColor = .white

        //Create slider
        slider = UISlider(frame: CGRect(x: 10, y: 10, width: Int(width)-20, height: Int(height)-20))
        slider?.value = Float(hue!)
        addSubview(slider!)

    }

}
