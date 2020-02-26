//
//  FICustomFormView.swift
//  mCAS
//
//  Created by iMac on 24/02/20.
//  Copyright © 2020 Nucleus. All rights reserved.
//

import UIKit

protocol FIFormViewDelegate {
    func updateHeight()
}

class FICustomFormView: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var formStackView: UIStackView!
    
    private var delegate: FIFormViewDelegate?
    
    private let BASE_TAG = 10000
    
    private var dynamicFieldsValue = [[String: Any]]()
    
    var selectedLOVDic: [String: DropDown] = [:]
    private var fieldData: [FIModelClasses.DynamicVerificationTypeVOList]!
    private var fivData: FIModelClasses.FIVData!
    
    struct MultiFormDataModel {
        let identifier: String
        let view: UIView
        let constraint: NSLayoutConstraint
    }
    
    private var heightConstOfMultiForm = [MultiFormDataModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FICustomFormView", owner: self, options: nil)
        containerView.fixInView(self)
    }
    
    func setProperties(fivData: FIModelClasses.FIVData, fieldData: [FIModelClasses.DynamicVerificationTypeVOList], delegate: FIFormViewDelegate, autoFillValuesArr: [[String: Any]] = []) {
        self.fieldData = fieldData
        self.fivData = fivData
        self.delegate = delegate
        formStackView.translatesAutoresizingMaskIntoConstraints = false
        let groupIDArray = fieldData.map({ $0.groupId }).distinctElements
        
        for (i,item) in groupIDArray.enumerated() {
            let groupId = item
            let arrayByGroupId = fieldData.filter({ $0.groupId == groupId })
            let label = CommonFormUtils.shared().setupHeadingLabel(title: arrayByGroupId.first!.groupDescription!, bgColor: Color.EXTREME_LIGHT_GRAY, isMainHeding: true)
            formStackView.addArrangedSubview(label)
            
            addConstraintsManually(item: label, height: 45.0)
            
            let tagVal = BASE_TAG*(i+1)
            for (index, obj) in arrayByGroupId.enumerated() {
                
                let label = CommonFormUtils.shared().setupHeadingLabel(title: obj.fieldLabel ?? "", isMandatory: (obj.isFieldMandatory ?? "" == "Y") ? true : false)
                formStackView.addArrangedSubview(label)
                addConstraintsManually(item: label, height: 45.0)
                
                let componentTag = tagVal + index
                
                switch obj.controlType {
                case "TB":
                    let view = CommonFormUtils.shared().setupCustomTextView(dataObj: obj, tag: componentTag, delegate: self, autoFillArr: autoFillValuesArr)
                    formStackView.addArrangedSubview(view)
                    addConstraintsManually(item: view, height: 50)
                    
                case "LOV":
                    let view = CommonFormUtils.shared().setupCustomLOVView(dataObj: obj, tag: componentTag, delegate: self, autoFillValue: autoFillValuesArr, lovData: fivData)
                    formStackView.addArrangedSubview(view)
                    addConstraintsManually(item: view, height: 50)
                    
                case "TELE":
                    let view = CommonFormUtils.shared().setupCustomPhoneView(dataObj: obj, tag: componentTag, delegate: self, lovData: fivData, autoFillArr: autoFillValuesArr)
                    formStackView.addArrangedSubview(view)
                    addConstraintsManually(item: view, height: 50)
                    
                case "CURR":
                    let view = CommonFormUtils.shared().setupCurrencyView(dataObj: obj, tag: componentTag, delegate: self, lovData: fivData, autoFillArr: autoFillValuesArr)
                    formStackView.addArrangedSubview(view)
                    addConstraintsManually(item: view, height: 50)
                    
                case "CAL":
                    let view = CommonFormUtils.shared().setupCustomTextView(dataObj: obj, tag: componentTag, delegate: self, type: .DATE, autoFillArr: autoFillValuesArr)
                    formStackView.addArrangedSubview(view)
                    addConstraintsManually(item: view, height: 50)
                    
                case "MOB":
                    let view = CommonFormUtils.shared().setupCustomMobileView(dataObj: obj, tag: componentTag, delegate: self, lovData: fivData, autoFillArr: autoFillValuesArr)
                    formStackView.addArrangedSubview(view)
                    addConstraintsManually(item: view, height: 50)
                    
                case "MUL_ENTRY":
                    
                    let valueView = UIView()
                    valueView.tag = componentTag
                    valueView.accessibilityIdentifier = obj.fieldId! + "View"
                    valueView.layer.masksToBounds = true
                    formStackView.addArrangedSubview(valueView)
                    
                    let const = NSLayoutConstraint(item: valueView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
                    const.priority = UILayoutPriority(rawValue: 999)
                    heightConstOfMultiForm.append(MultiFormDataModel(identifier: valueView.accessibilityIdentifier!, view: valueView, constraint: const))
                    formStackView.addConstraint(const)
                    
                    let btn = CommonFormUtils.shared().setupMultiFormButton(dataObj: obj, tag: componentTag)
                    btn.addTarget(self, action: #selector(multiFormAction(_:)), for: .touchUpInside)
                    formStackView.addArrangedSubview(btn)
                    addConstraintsManually(item: btn, height: 35)
                    let strVal: String = CommonFormUtils.shared().fetchAutoFillString(arrList: autoFillValuesArr, identifier: obj.fieldId!) as String
                    if !strVal.isEmpty {
                        do {
                            let data = strVal.data(using: .utf8)!
                            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                            dynamicFieldsValue.append(["fieldId": obj.fieldId!, "fieldValue": jsonObject as? [[[String: Any]]] ?? []] )
                            DispatchQueue.main.async {
                                self.updateMultiFormValueView(identifier: obj.fieldId!)
                            } 
                        }
                        catch { }
                    }
                    
                    
                default:
                    break
                }
                
                if index == (arrayByGroupId.count - 1) {
                    if #available(iOS 11.0, *) {
                        formStackView.setCustomSpacing(20, after: formStackView.subviews.last!)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }
    }
    
    private func addConstraintsManually(item: NSObject, height: CGFloat) {
        let const = NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: height)
        const.priority = UILayoutPriority(rawValue: 999)
        formStackView.addConstraint(const)
    }
    
    @objc func multiFormAction(_ sender: UIButton) {
        multiFormActionWith(identifier: sender.accessibilityIdentifier!)
    }
    
    private func multiFormActionWith(identifier: String, autoFillValuesArr: [[String: Any]] = [], index: Int? = nil) {
        
        let arr = fieldData.filter({$0.fieldId == identifier})
        let data = arr.first?.multiEntryDynamicFormVOList ?? []
        let st = UIStoryboard.init(name: Storyboard.FI, bundle: nil)
        if let vc = st.instantiateViewController(withIdentifier: "FIVMultiFormVC") as? FIVMultiFormVC {
            vc.setData(fivData: fivData, fieldData: data, delegate: self, identifier: identifier, autoFillValuesArr: autoFillValuesArr, index: index)
            AppDelegate.instance.applicationNavController.pushViewController(vc, animated: true)
        }
    }
    
    func getAllFieldValues() -> [[String : Any]] {
        //       AK Change - Check ~ value
        for view in self.formStackView.subviews {
            let identifier = view.accessibilityIdentifier
            let dataArr = self.fieldData.filter({ $0.fieldId == identifier})
            if let vw = view as? CustomTextFieldView {
                if !dataArr.isEmpty {
                    let mandatory = dataArr.first?.isFieldMandatory == "Y" ? true : false
                    if mandatory && vw.getFieldValue().isEmpty {
                        CommonAlert.shared().showAlert(message: "Please Enter \(dataArr.first?.fieldLabel ?? "")")
                        return []
                    }
                    else {
                        setFieldValue(identifier: identifier!, value:vw.getFieldValue())
                    }
                }
            }
            else if let vw = view as? LOVFieldView {
                if !dataArr.isEmpty {
                    let mandatory = dataArr.first?.isFieldMandatory == "Y" ? true : false
                    if mandatory && (selectedLOVDic["\(vw.tag)"]?.name == nil) {
                        CommonAlert.shared().showAlert(message: "Please Enter \(dataArr.first?.fieldLabel ?? "")")
                        return []
                    }
                    else {
                        setFieldValue(identifier: identifier!, value: (selectedLOVDic["\(vw.tag)"]?.name == nil) ? "" : selectedLOVDic["\(vw.tag)"]!.name)
                    }
                }
            }
            else if let vw = view as? CustomMobileNumberView {
                if !dataArr.isEmpty {
                    let mandatory = dataArr.first?.isFieldMandatory == "Y" ? true : false
                    if mandatory && ((selectedLOVDic["\(vw.tag)"]?.name == nil) || vw.mobileNoTFView.getFieldValue().isEmpty) {
                        CommonAlert.shared().showAlert(message: "Please Enter \(dataArr.first?.fieldLabel ?? "")")
                        return []
                    }
                    else {
                        if let name = selectedLOVDic["\(vw.tag)"]?.name, let code = selectedLOVDic["\(vw.tag)"]?.code {
                            setFieldValue(identifier: identifier!, value: "\(name)~\(code)~\(vw.mobileNoTFView.getFieldValue())")
                        }
                        else {
                            setFieldValue(identifier: identifier!, value: "")
                        }
                    }
                }
            }
            else if let vw = view as? CustomPhoneNumberView {
                if !dataArr.isEmpty {
                    let mandatory = dataArr.first?.isFieldMandatory == "Y" ? true : false
                    if mandatory && ((selectedLOVDic["\(vw.tag)"]?.name == nil) || vw.stdCodeView.getFieldValue().isEmpty || vw.phoneNumberTFView.getFieldValue().isEmpty) {
                        CommonAlert.shared().showAlert(message: "Please Enter \(dataArr.first?.fieldLabel ?? "")")
                        return []
                    }
                    else {
                        
                        if let name = selectedLOVDic["\(vw.tag)"]?.name, let code = selectedLOVDic["\(vw.tag)"]?.code, !vw.stdCodeView.getFieldValue().isEmpty, !vw.phoneNumberTFView.getFieldValue().isEmpty {
                            setFieldValue(identifier: identifier!, value: "\(name)~\(code)~\(vw.stdCodeView.getFieldValue())~\(vw.phoneNumberTFView.getFieldValue())~\(vw.extensionView.getFieldValue())")
                            
                        }
                        else {
                            setFieldValue(identifier: identifier!, value: "")
                        }
                    }
                }
            }
            else if let vw = view as? CustomCurrencyView {
                if !dataArr.isEmpty {
                    let mandatory = dataArr.first?.isFieldMandatory == "Y" ? true : false
                    if mandatory && ((selectedLOVDic["\(vw.tag)"]?.name == nil) || vw.amountTFView.getFieldValue().isEmpty) {
                        CommonAlert.shared().showAlert(message: "Please Enter \(dataArr.first?.fieldLabel ?? "")")
                        return []
                    }
                    else {
                        if let name = selectedLOVDic["\(vw.tag)"]?.name {
                            setFieldValue(identifier: identifier!, value: "\(name)~\(vw.amountTFView.getFieldValue())")
                        }
                        else {
                            setFieldValue(identifier: identifier!, value: "")
                        }
                    }
                }
            }
        }
        
        return dynamicFieldsValue
    }
    
    private func setFieldValue(identifier: String, value: String) {
        self.removeExistingValue(identifier: identifier)
        dynamicFieldsValue.append(["fieldId": identifier, "fieldValue": value])
    }
    
    private func removeExistingValue(identifier: String) {
        dynamicFieldsValue = dynamicFieldsValue.filter({
            return (CommonUtils.shared().getValidatedString(string: $0["fieldId"]) != identifier)
        })
    }
}


extension FICustomFormView: CustomTFViewDelegate {
    func validateFields() {
    }
    
    func textFieldEditing(text: String, tag: Int) -> Bool {
        
        let editingView = formStackView.subviews.filter{$0.tag == tag}.first
        if  let view = editingView?.viewWithTag(tag) as? CustomTextFieldView {
            return getValidationFromData(identifier: view.accessibilityIdentifier ?? "", text: text)
        }
        return true
    }
    
    private func getValidationFromData(identifier: String, text: String) -> Bool {
        let dataArr = self.fieldData.filter({ $0.fieldId == identifier})
        
        if !dataArr.isEmpty {
            let fieldType = dataArr.first?.fieldType
            let fieldLength = dataArr.first?.fieldLength
            var validate = true
            if fieldType == "AN" {
                validate = text.isAlphanumericAndSpace
            }
            else if fieldType == "NUMBER" || fieldType == "ND" {
                validate = text.isNumeric
            }
            else if fieldType == "EMAIL" {
                validate = text.isValidEmail
            }
            else if fieldType == "CHARSPL" {
                validate = text.isCharSpecial
            }
            else if fieldType == "CHAR" {
                validate = text.isAlphabetic
            }
            
            return validate && text.count <= Int(fieldLength ?? "0")!
        }
        return true
    }
}

extension FICustomFormView: SelectedLOVDelegate {
    func selectedLOVResult(selectedObj: DropDown, btntag: Int) {
        selectedLOVDic["\(btntag)"] = selectedObj
    }
}

extension FICustomFormView: FIMultiFormDelegate {
    func filledForm(fillDetailArr: [[String : Any]], identifier: String, index: Int) {
        
        let arr = self.dynamicFieldsValue.filter({CommonUtils.shared().getValidatedString(string: $0["fieldId"]) == identifier})
        
        if arr.isEmpty {
            dynamicFieldsValue.append(["fieldId": identifier, "fieldValue": [fillDetailArr]])
        }
        else {
            //SK Change
            if index != 9999 {
                dynamicFieldsValue = dynamicFieldsValue.map({
                    if CommonUtils.shared().getValidatedString(string: $0["fieldId"]) == identifier {
                        if var arr = $0["fieldValue"] as? [[[String : Any]]] {
                            arr.remove(at: index)
                            var mainArray = [[[String: Any]]]()
                            mainArray = arr
                            mainArray.insert(fillDetailArr, at: index)
                            return ["fieldId": identifier, "fieldValue": mainArray]
                        }
                    }
                    return $0
                })
            }
            else {
                if let obj = arr.first?["fieldValue"] as? [[[String: Any]]] {
                    
                    var mainArray = [[[String: Any]]]()
                    mainArray = obj
                    mainArray.append(fillDetailArr)
                    dynamicFieldsValue = dynamicFieldsValue.filter({CommonUtils.shared().getValidatedString(string: $0["fieldId"]) != identifier})
                    dynamicFieldsValue.append(["fieldId": identifier, "fieldValue": mainArray])
                }
            }
        }
        updateMultiFormValueView(identifier: identifier)
    }
    
    private func updateMultiFormValueView(identifier: String) {
        
        let obj = heightConstOfMultiForm.filter({ $0.identifier == "\(identifier)View"})
        
        if let view = obj.first?.view, let const = obj.first?.constraint {
            let arrMultiFormValue = self.dynamicFieldsValue.filter({CommonUtils.shared().getValidatedString(string: $0["fieldId"]) == identifier})
            
            var height: CGFloat = 0.0
            if !arrMultiFormValue.isEmpty , let subArray = arrMultiFormValue.first?["fieldValue"] as? [[[String : Any]]] {
                
                for (index,item) in subArray.enumerated() {
                    let keyValueView = KeyValueFormView(frame: CGRect(x: 0, y: height, width: view.frame.size.width, height: CGFloat(item.count*32)))
                    
                    keyValueView.setProperties(arrList: item, delegate: self, identifier: "\(identifier)", index: index)
                    view.addSubview(keyValueView)
                    height += CGFloat(item.count*32)
                }
            }
            const.constant = height
            self.delegate?.updateHeight()
        }
    }
}


extension FICustomFormView: KeyValueFormViewDelegate {
    
    func editDeleteFormAction(identifier: String, arrList: [[String : Any]], isRemove: Bool, index: Int) {
        
        if isRemove {
            
            dynamicFieldsValue = dynamicFieldsValue.map({
                if CommonUtils.shared().getValidatedString(string: $0["fieldId"]) == identifier {
                    if var arr = $0["fieldValue"] as? [[[String : Any]]] {
                        arr.remove(at: index)
                        return ["fieldId": identifier, "fieldValue": arr]
                    }
                }
                return $0
            })
            updateMultiFormValueView(identifier: identifier)
        }
        else {
            self.multiFormActionWith(identifier: identifier, autoFillValuesArr: arrList, index: index)
        }
    }
}
