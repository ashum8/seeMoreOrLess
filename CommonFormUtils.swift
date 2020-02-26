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
    //AK change - check
    func setupHeadingLabel(title: String, isMandatory: Bool = false, bgColor: UIColor = .clear, isMainHeding: Bool = false)-> UILabel {
        let label = EdgeInsetLabel()
        label.textColor = .darkGray
        label.backgroundColor = bgColor
        
        if isMainHeding {
            label.font = CustomFont.shared().GETFONT_MEDIUM(19)
            label.leftTextInset = 2.0
        }
        else {
            label.font = CustomFont.shared().GETFONT_REGULAR(19)
            label.topTextInset = 10.0
        }
        let formattedString = NSMutableAttributedString()
        if isMandatory {
            formattedString
                .attributedText(title, color: .gray, font: label.font)
                .attributedText("*",color: Color.RED ,font: label.font)
        }
        else {
            formattedString
                .attributedText(title, color: .gray, font: label.font)
        }
        label.attributedText = formattedString
        return label
    }
    
    func setupMultiFormButton(dataObj: FIModelClasses.DynamicVerificationTypeVOList, tag: Int, font: UIFont = CustomFont.shared().GETFONT_REGULAR(19)) -> UIButton {
        let btn = UIButton()
        btn.setCornerRadius()
        btn.layer.borderWidth = 1
        btn.titleLabel?.font = font
        btn.setTitleColor(Color.BLUE, for: .normal)
        btn.layer.borderColor = Color.BLUE.cgColor
        btn.backgroundColor = .white
        btn.accessibilityIdentifier = dataObj.fieldId
        btn.setTitle("+ \(dataObj.fieldLabel!)", for: .normal)
        return btn
    }
    
    func setupCustomTextView(dataObj: FIModelClasses.DynamicVerificationTypeVOList, tag: Int, delegate:CustomTFViewDelegate? = nil, unitText:String = "", type: FieldType = .Text, autoFillArr: [[String: Any]]) -> UIView {
        
        let view = CustomTextFieldView()
        view.accessibilityIdentifier = dataObj.fieldId
        view.setProperties(placeHolder: "Enter \(dataObj.fieldLabel!)", type: type, delegate: delegate,unitText: unitText, tag: tag, enabled: dataObj.isFieldDisabled == "Y" ? false : true, removeTopMargin: true)
        view.tag = tag
        view.setFieldValue(text: fetchAutoFillString(arrList: autoFillArr, identifier: dataObj.fieldId!))
        return view
    }
    
    //SK Change - autofill value
    func setupCustomLOVView(dataObj: FIModelClasses.DynamicVerificationTypeVOList, tag: Int, delegate:SelectedLOVDelegate, autoFillValue: [[String: Any]], lovData:FIModelClasses.FIVData) -> UIView {
        let view = LOVFieldView()
        view.tag = tag
        view.accessibilityIdentifier = dataObj.fieldId
        view.setLOVProperties(title: dataObj.fieldLabel!, tag: tag, autoFillValue: fetchAutoFillString(arrList: autoFillValue, identifier: dataObj.fieldId!), delegate: delegate, optionArray: genrateLOVDropDownArray(queryType: dataObj.controlQuery!, fiData: lovData), enable: dataObj.isFieldDisabled == "Y" ? false : true, removeTopMargin: true)
        return view
    }
    
    func setupCustomPhoneView(dataObj: FIModelClasses.DynamicVerificationTypeVOList, tag: Int, delegate:SelectedLOVDelegate, lovData:FIModelClasses.FIVData, autoFillArr: [[String: Any]]) -> UIView {
        
        let view = CustomPhoneNumberView()
        view.accessibilityIdentifier = dataObj.fieldId
        view.setProperties(tag: tag, delegate: delegate, optionArray: genrateLOVDropDownArray(queryType: dataObj.controlQuery!, fiData: lovData, isAddDisplayValue: true), removeTopMargin: true, showExtension: true, autoFillValue: fetchAutoFillString(arrList: autoFillArr, identifier: dataObj.fieldId!))
        view.tag = tag
        return view
    }
    
    func setupCustomMobileView(dataObj: FIModelClasses.DynamicVerificationTypeVOList, tag: Int, delegate:SelectedLOVDelegate, lovData:FIModelClasses.FIVData, autoFillArr: [[String: Any]]) -> UIView {
        
        let view = CustomMobileNumberView()
        view.accessibilityIdentifier = dataObj.fieldId
        view.setProperties(tag: tag, delegate: delegate, optionArray: genrateLOVDropDownArray(queryType: dataObj.controlQuery!, fiData: lovData, isAddDisplayValue: true), removeTopMargin: true, autoFillValue: fetchAutoFillString(arrList: autoFillArr, identifier: dataObj.fieldId!))
        view.tag = tag
        return view
    }
    
    func setupCurrencyView(dataObj: FIModelClasses.DynamicVerificationTypeVOList, tag: Int, delegate:SelectedLOVDelegate, lovData:FIModelClasses.FIVData, autoFillArr: [[String: Any]]) -> UIView {
        
        let view = CustomCurrencyView()
        view.accessibilityIdentifier = dataObj.fieldId
        view.setProperties(tag: tag, delegate: delegate, optionArray: genrateLOVDropDownArray(queryType: dataObj.controlQuery!, fiData: lovData), removeTopMargin: true, autoFillValue: fetchAutoFillString(arrList: autoFillArr, identifier: dataObj.fieldId!))
        view.tag = tag
        return view
    }
    
    
    private func genrateLOVDropDownArray(queryType: String, fiData: FIModelClasses.FIVData, isAddDisplayValue: Bool = false) ->[DropDown] {
        var dropdownArray: [DropDown] = []
        if let arrayObj = fiData.verificationMasterDetailVOList, !arrayObj.isEmpty {
            let dictObj = arrayObj.filter({$0.parentKey == queryType})
            if let arrayKeyValue = dictObj.first?.keyValuePairs, !arrayKeyValue.isEmpty {
                if isAddDisplayValue {
                    dropdownArray = arrayKeyValue.map({ DropDown(code: $0.key!, name: $0.value!, listDisplayValue:$0.key!, lovDisplayValue: "\($0.key!) (\($0.value!))")})
                }
                else {
                    dropdownArray = arrayKeyValue.map({ DropDown(code: $0.key!, name: $0.value!)})
                }
            }
        }
        
        return dropdownArray
    }
    
    func fetchAutoFillString(arrList: [[String: Any]], identifier: String) -> String {
        let arr = arrList.filter({CommonUtils.shared().getValidatedString(string: $0["fieldId"]) == identifier})
        if !arr.isEmpty {
            return CommonUtils.shared().getValidatedString(string: arr.first?["fieldValue"])
        }
        return ""
    }
}
