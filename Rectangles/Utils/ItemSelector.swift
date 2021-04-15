//
//  ItemSelector.swift
//  Learning
//
//  Created by Javi Castillo Risco on 10/01/2021.
//

import UIKit

protocol ItemSelectorDelegate {
    func valueChanged(_ selector: ItemSelector)
}

enum SelectorItem {
    case initial
    case final
}

class ItemSelector: UIView {
    var itemComponent: UIButton!
    var emptyTextField: UITextField!
    var pickerView: UIPickerView!
    var listItems: [String]! {
        didSet {
            if listItems.count > 0 {
                itemComponent.setTitle(listItems[0], for: .normal)
            }
        }
    }
    var delegate: ItemSelectorDelegate?
    var currentIndex = 0 {
        didSet {
            if currentIndex < listItems.count {
                itemComponent.setTitle(listItems[currentIndex], for: .normal)
                pickerView.selectRow(currentIndex, inComponent: 0, animated: false)
            }
        }
    }
    var itemId: SelectorItem!

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareView()
    }

    private func prepareView() {
        itemComponent = UIButton()
        itemComponent.layer.borderWidth = 1
        itemComponent.layer.cornerRadius = 5
        itemComponent.setTitleColor(.black, for: .normal)
        itemComponent.addTarget(self, action: #selector(changeItem), for: .touchUpInside)
        addSubview(itemComponent)

        itemComponent.translatesAutoresizingMaskIntoConstraints = false

        let horizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[itemComponent]-0-|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["itemComponent": itemComponent!])

        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[itemComponent]-0-|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["itemComponent": itemComponent!])

        addConstraints(horizontalConstraints+verticalConstraints)

        emptyTextField = UITextField()
        pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        emptyTextField.inputView = pickerView
        let pickerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 320, height: 33))
        pickerButton.adjustsImageWhenHighlighted = false
        pickerButton.backgroundColor = .blue
        pickerButton.titleLabel?.textColor = .white
        pickerButton.setTitle("Aceptar", for: .normal)
        pickerButton.addTarget(self, action: #selector(closePicker), for: .touchUpInside)
        emptyTextField.inputAccessoryView = pickerButton
        addSubview(emptyTextField)
    }

    //MARK: - Actions

    @objc
    func changeItem() {
        emptyTextField.becomeFirstResponder()
    }

    @objc
    func closePicker() {
        emptyTextField.resignFirstResponder()
    }

}

extension ItemSelector: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listItems.count
    }

}

extension ItemSelector: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listItems[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentIndex = row
        delegate?.valueChanged(self)
    }
}
