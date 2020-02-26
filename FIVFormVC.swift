//
//  FIVFormVC.swift
//  mCAS
//
//  Created by iMac on 20/02/20.
//  Copyright © 2020 Nucleus. All rights reserved.
//

import UIKit


class FIVFormVC: UIViewController {
    
    @IBOutlet weak var applicationDetailView: UIView!
    @IBOutlet weak var applicationDetailViewHeight: NSLayoutConstraint!
    @IBOutlet weak var detailSatckView: UIStackView!
    @IBOutlet weak var buttonView: NextBackButtonView!
    
    @IBOutlet weak var formView: FICustomFormView!
    @IBOutlet weak var formViewHeight: NSLayoutConstraint!
    @IBOutlet weak var staticFieldStackView: UIStackView!
    @IBOutlet weak var staticFieldStackViewHeight: NSLayoutConstraint!
    
    private struct FIUserDetail  {
        let title: String
        let imageName: String
    }
    
    private var userDetailArray: [FIUserDetail] = []
    private var selectedLOVDic: [String: DropDown] = [:]
    private var fivData: FIModelClasses.FIVData!
    private var dataObj: FIModelClasses.LoanVerificationCategoryVOList!
    private var fieldData: [FIModelClasses.DynamicVerificationTypeVOList]!
    private var buttonIdentifier: String!
    
    private let BASE_TAG = 10000
    private let NO_OF_ATTEMPT_TAG = 1000
    private let REMARKS_TAG = 1001
    private let RESULT_TAG = 1002
    
    private var attemptsView = CustomTextFieldView()
    private var remarksView = CustomTextFieldView()
    
    private var dynamicFieldsValue = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDetailView()
        setDynamicForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let headerView = AppDelegate.instance.headerView {
            
            var title = ""
            if let dataArr = fivData?.loanFieldVerificationDetailVOList, !dataArr.isEmpty, let name = dataArr.first?.loanVerificationCategoryVOList?.first?.customerName {
                title = name
            }
            let navArray = AppDelegate.instance.applicationNavController.viewControllers
            let lastVC = navArray[navArray.count-2]
            headerView.showHideStepHeader(isHide: false, title: title, landingPage: lastVC)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let headerView = AppDelegate.instance.headerView {
            headerView.setTitleWith(showBack: false)
            headerView.showHideWhiteHeader(isHide: true)
        }
    }
    
    func setData(fivData: FIModelClasses.FIVData, fieldData: [FIModelClasses.DynamicVerificationTypeVOList], data: FIModelClasses.LoanVerificationCategoryVOList? = nil) {
        self.fivData = fivData
        self.dataObj = data
        self.fieldData = fieldData
    }
    
    private func setupDetailView(showAll: Bool = true) {
        
        buttonView.setProperties(showNext: true, nextBtnTitle: "Continue", delegate: self)
        applicationDetailView.backgroundColor = Color.BLUE
        userDetailArray.removeAll()
        if showAll {
            userDetailArray.append(FIUserDetail(title: self.dataObj.applicationId ?? "", imageName: "address_icon"))
            userDetailArray.append(FIUserDetail(title: self.dataObj.verificationNameKey ?? "", imageName: "address_icon"))
        }
        
        if let addressVO = dataObj.customerAddressVO, let addrsArray = addressVO.fivAddressDetailVOList, !addrsArray.isEmpty, let firstAddress = addrsArray.first {
            
            userDetailArray.append(FIUserDetail(title: "\(firstAddress.address ?? ""),\(firstAddress.city  ?? ""),\(firstAddress.state  ?? ""),\(firstAddress.country  ?? ""),\(firstAddress.zipCode  ?? "")", imageName: "address_icon"))
        }
        
        for (_, item) in userDetailArray.enumerated() {
            let view = CustomUserDetailView()
            view.setProperties(title:item.title, imageName: item.imageName)
            detailSatckView.addArrangedSubview(view)
        }
        
        applicationDetailViewHeight.constant = CGFloat(userDetailArray.count*38 + 40)
    }
    
    private func setDynamicForm() {
        
        var autoFillArr : [[String : Any]] = []

        if let arr = self.dataObj.fiData, !arr.isEmpty {
            
            for item in arr {
                autoFillArr.append(["fieldId": item.fieldId ?? "", "fieldValue": item.fieldValue ?? ""])
            }
        }
        
        formView.setProperties(fivData: fivData, fieldData: self.fieldData, delegate: self, autoFillValuesArr: autoFillArr)
        updateHeight()
//       AK Change - Check
        var height = 0.0
        let headingLabel = CommonFormUtils.shared().setupHeadingLabel(title: "Decision", bgColor: Color.EXTREME_LIGHT_GRAY, isMainHeding: true)
        staticFieldStackView.addArrangedSubview(headingLabel)
        addConstraintsManually(item: headingLabel, height: 45)
        height += 45
        
        //No. Of Attempts
        let label = CommonFormUtils.shared().setupHeadingLabel(title: "No. Of Attempts", isMandatory: true)
        staticFieldStackView.addArrangedSubview(label)
        addConstraintsManually(item: label, height: 45)
        height += 45
        
        attemptsView = CustomTextFieldView()
        attemptsView.setProperties(placeHolder: "Enter Value", delegate: self, tag:NO_OF_ATTEMPT_TAG, removeTopMargin: true)
        let attempts = CommonFormUtils.shared().fetchAutoFillString(arrList: autoFillArr, identifier: "Attempts")
        attemptsView.setFieldValue(text: attempts)
        
        staticFieldStackView.addArrangedSubview(attemptsView)
        addConstraintsManually(item: attemptsView, height: 50)
        height += 50
        
        //remarks
        let label1 = CommonFormUtils.shared().setupHeadingLabel(title: "Remarks")
        staticFieldStackView.addArrangedSubview(label1)
        addConstraintsManually(item: label1, height: 45)
        height += 45
        
        remarksView = CustomTextFieldView()
        remarksView.setProperties(placeHolder: "Enter Value", delegate: self, tag:REMARKS_TAG, removeTopMargin: true)
        remarksView.setFieldValue(text: CommonUtils.shared().getValidatedString(string: self.dataObj.remarks))
        
        staticFieldStackView.addArrangedSubview(remarksView)
        addConstraintsManually(item: remarksView, height: 50)
        height += 50
        
        //result
        let label2 = CommonFormUtils.shared().setupHeadingLabel(title: "Result", isMandatory: true)
        staticFieldStackView.addArrangedSubview(label2)
        addConstraintsManually(item: label2, height: 45)
        height += 45
        
        let view2 = LOVFieldView()
        var resultArr = [DropDown]()
        resultArr.append(DropDown(code: "SEL", name: "Select"))
        resultArr.append(DropDown(code: "NEUTRAL", name: "Neutral"))
        resultArr.append(DropDown(code: "POSITIVE", name: "Positive"))
        resultArr.append(DropDown(code: "NEGATIVE", name: "Negative"))
        view2.setLOVProperties(title: "Result", tag: RESULT_TAG, autoFillValue: CommonFormUtils.shared().fetchAutoFillString(arrList: autoFillArr, identifier: "Attempts"), delegate: self, optionArray: resultArr, removeTopMargin: true)
        
        view2.tag = RESULT_TAG
        staticFieldStackView.addArrangedSubview(view2)
        addConstraintsManually(item: view2, height: 50)
        height += 50
        
        staticFieldStackViewHeight.constant = CGFloat(height)   
    }
    
    private func addConstraintsManually(item: NSObject, height: CGFloat) {
        
        let const = NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: height)
        const.priority = UILayoutPriority(rawValue: 999)
        staticFieldStackView.addConstraint(const)
        
    }
    
    @IBAction func showHideDetailButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        detailSatckView.removeAllSubviews()
        setupDetailView(showAll: !sender.isSelected)
    }
    
    private func saveFormData() {

        dynamicFieldsValue = dynamicFieldsValue.map({
            if let arrObj = $0["fieldValue"] as? [[[String: Any]]] {
                return ["fieldId": CommonUtils.shared().getValidatedString(string: $0["fieldId"]), "fieldValue": CommonUtils.shared().JSONToString(jsonObject: arrObj)]
            }
            return $0
        })
        let params: [String: Any] = ["applicationId"        : self.dataObj.applicationId!,
                                     "customerId"           : self.dataObj.applicationId!,
                                     "loanFIVId"            : "",
                                     "loanFIVSequenceId"    : "",
                                     "verificationType"     : self.dataObj.verificationNameKey!,
                                     "decision"             : attemptsView.getFieldValue(),
                                     "remarks"              : remarksView.getFieldValue(),
                                     "createdBy"            : "",
                                     "investigationType"    : "",
                                     "fivAddress"           : userDetailArray.last?.title ?? "",
                                     "dynamicFieldSets"     : dynamicFieldsValue]
        print(params)
        Webservices.shared().POST(urlString: ServiceUrl.SAVE_DATA_FI_URL, paramaters: params, autoHandleLoader: true, success: { (header, responseObj) in
            if let response = responseObj as? [String: Any]
            {
                if let isCompleted = response["completed"] as? Int, isCompleted == 1 {
                    CommonAlert.shared().showAlert(message: "Fiv Data Sync Successfully.", okAction: { _ in
                        self.dataObj.fiData = self.dynamicFieldsValue.map( {FIModelClasses.FIFillData(fieldId: CommonUtils.shared().getValidatedString(string: $0["fieldId"]), fieldValue: CommonUtils.shared().getValidatedString(string: $0["fieldValue"]))} )
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                
            }
        }, failure: { (error) in
            
            if let error = error {
                CommonAlert.shared().showAlert(message: NSLocalizedString(error, comment: ""))
            }
            
        }, noNetwork: { (error) in
            
        })
    }
    
}


extension FIVFormVC: NextBackButtonDelegate {
    
    func nextButtonAction() {
        dynamicFieldsValue = formView.getAllFieldValues()
        
        if !dynamicFieldsValue.isEmpty {
            if attemptsView.getFieldValue().isEmpty {
                CommonAlert.shared().showAlert(message: "Please Enter no of attempts")
                return
            }
            else if selectedLOVDic["\(RESULT_TAG)"] == nil {
                CommonAlert.shared().showAlert(message: "Please Enter result")
                return
            }
            dynamicFieldsValue.append(["fieldId": "Attempts", "fieldValue": attemptsView.getFieldValue()])
            CommonAlert.shared().showAlert(message: "Are you sure you want to save?", okTitle: "Yes", cancelTitle: "No", okAction: { _ in
                self.saveFormData()
            })
        }
    }
    
    private func removeExistingValue(identifier: String) {
        dynamicFieldsValue = dynamicFieldsValue.filter({
            return (CommonUtils.shared().getValidatedString(string: $0["fieldId"]) != identifier)
        })
    }
}

extension FIVFormVC: SelectedLOVDelegate {
    func selectedLOVResult(selectedObj: DropDown, btntag: Int) {
        selectedLOVDic["\(btntag)"] = selectedObj
    }
}


extension FIVFormVC: CustomTFViewDelegate {
    func validateFields() {
    }
    
    func textFieldEditing(text: String, tag: Int) -> Bool {
        
        if tag == NO_OF_ATTEMPT_TAG {
            return text.count == 1 && text.isNumeric
        }
        else if tag == REMARKS_TAG {
            return text.count < Constants.REMARKS_LENGTH && text.isAlphanumericAndSpace
        }

        return true
    }
}

extension FIVFormVC: FIFormViewDelegate {
    
    func updateHeight() {
        formViewHeight.constant = formView.formStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }
}
