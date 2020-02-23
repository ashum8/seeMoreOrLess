//
//  CommonFormUtils.swift
//  mCAS
//
//  Created by iMac on 22/02/20.
//  Copyright © 2020 Nucleus. All rights reserved.
//

import Foundation

class CommonFormUtils: NSObject {
    
    private static var instance: CommonFormUtils?
    
    static func shared() -> CommonFormUtils{
        if instance == nil {
            instance = CommonFormUtils()
        }
        return instance!
    }
    
    func setupHeadinLabel(title: String, font: UIFont = CustomFont.shared().GETFONT_REGULAR(16), isMandatory: Bool = false)-> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = .darkGray
        
        let formattedString = NSMutableAttributedString()
        if isMandatory {
            formattedString
                .attributedText(title, color: .gray, font: font)
                .attributedText("*",color: Color.RED ,font: font)
        }
        else {
            formattedString
                .attributedText(title, color: .gray, font: font)
        }
        label.attributedText = formattedString
        return label
    }
    
    func setupMultiFormButton(title: String, font: UIFont = CustomFont.shared().GETFONT_REGULAR(16)) -> UIButton {
        let btn = UIButton()
        btn.setCornerRadius()
        btn.layer.borderWidth = 1
        btn.titleLabel?.font = font
        btn.setTitleColor(Color.BLUE, for: .normal)
        btn.layer.borderColor = Color.BLUE.cgColor
        btn.backgroundColor = .white
        btn.setTitle("+ \(title)", for: .normal)
        return btn
    }
    
    func setupCustomTextView(dataObj: FIModelClasses.DynamicVerificationTypeVOList, tag: Int, delegate:CustomTFViewDelegate? = nil) -> UIView {
    
        let view = CustomTextFieldView()
        view.accessibilityIdentifier = dataObj.fieldId
        view.setProperties(placeHolder: "Enter \(dataObj.fieldLabel!)", type: .Text, delegate: delegate, tag: tag, enabled: dataObj.isFieldDisabled == "Y" ? true : false)
        return view
    }
    
    func setupCustomLOVView(dataObj: FIModelClasses.DynamicVerificationTypeVOList, tag: Int, delegate:SelectedLOVDelegate, autoFillValue: String) -> UIView {
    
        let view = LOVFieldView()
        view.accessibilityIdentifier = dataObj.fieldId
        view.setLOVProperties(title: dataObj.fieldLabel!, tag: tag, autoFillValue: autoFillValue, delegate: delegate, optionArray: [], enable: dataObj.isFieldDisabled == "Y" ? true : false)
        return view
    }
    
    
    func setupCustomviews(dataObj: FIModelClasses.DynamicVerificationTypeVOList, tag: Int)-> UIView {
        
        switch dataObj.controlType {
        case "TB":
            let view = CustomTextFieldView()
            view.accessibilityIdentifier = dataObj.fieldId
            view.setProperties(placeHolder: "Enter \(dataObj.fieldLabel!)")
            return view
        case "LOV":
            let view = LOVFieldView()
            view.setLOVProperties(title: dataObj.fieldLabel!, tag: 1000, delegate: self)
            return view
        case "TELE":
            let view = CustomPhoneNumberView()
            view.setProperties(tag: 1212, delegate: self)
            return view
        case "CURR":
            let view = CustomTextFieldView()
            view.setProperties(placeHolder: dataObj.fieldLabel!, type: .Amount, delegate: self, unitText: Constants.CURRENCY_SYMBOL)
            return view
        case "CAL":
            let view = CustomTextFieldView()
            view.setProperties(placeHolder: dataObj.fieldLabel!, type: .DATE, delegate: self)
            return view
        case "MOB":
            let view = CustomMobileNumberView()
            view.setProperties(tag: 1212, delegate: self)
            return view
            
        default:
            return CustomTextFieldView()
        }
    }
}
extension CommonFormUtils: SelectedLOVDelegate {
    func selectedLOVResult(selectedObj: DropDown, btntag: Int) {
        print("")
    }
    
    
}

extension CommonFormUtils: CustomTFViewDelegate {
    func validateFields() {
        print("")
    }
    
    
}
