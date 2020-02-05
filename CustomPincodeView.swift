//
//  CustomPincodeView.swift
//  mCAS
//
//  Created by iMac on 05/02/20.
//  Copyright © 2020 Nucleus. All rights reserved.
//

import UIKit

class CustomPincodeView: UIView {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var textField: JVFloatLabeledTextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textFieldView: UIView!
    
    private var arrList = [DropDown]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CustomPincodeView", owner: self, options: nil)
        containerView.fixInView(self)
    }
    
    func setProperties() {
        
        textFieldView.setTextFieldViewProperties()
        textField.placeholder = "Pincode"
        textField.delegate = self
        textField.keyboardType = .numberPad
    }
    
    func getFieldValue() -> String {
        return textField.text!
    }
    
    func setFieldValue(text: String? = "") {
        textField.text = text
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        
        arrList.append(DropDown(code: "DELHI", name: "110096"))
        let storyboard = UIStoryboard.init(name: Storyboard.LOV_LIST, bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "LOVListVC") as? LOVListVC {
            vc.setData(dropDownList: arrList, delegate: self, title: "Pincode" ?? "", selectedButton: sender)
            AppDelegate.instance.applicationNavController.pushViewController(vc, animated: true)
        }
    }
    
}

extension CustomPincodeView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldView.layer.borderColor = Color.BLUE.cgColor
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textFieldView.layer.borderColor = UIColor.lightGray.cgColor
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let stringValue = (textField.text ?? "") + string
        
        return stringValue.isNumeric && stringValue.count <= 6
        
    }
}

extension CustomPincodeView: LOVListDelegate {
    
    func selectedLOV(selectedObj: DropDown) {
        textField.text = selectedObj.name
    }
    
}
