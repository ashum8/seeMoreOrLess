//
//  SourcingLoanDetailVC.swift
//  mCAS
//
//  Created by iMac on 20/01/20.
//  Copyright © 2020 Nucleus. All rights reserved.
//

import UIKit

class SourcingLoanDetailVC: UIViewController {
    
    @IBOutlet weak var branchLOV: LOVFieldView!
    @IBOutlet weak var productTypeLOV: LOVFieldView!
    @IBOutlet weak var schemeLOV: LOVFieldView!
    @IBOutlet weak var loanPurposeLOV: LOVFieldView!
    @IBOutlet weak var agentLOV: LOVFieldView!
    @IBOutlet weak var loanAmountTFView: CustomTextFieldView!
    @IBOutlet weak var tenureTFView: CustomTextFieldView!
    @IBOutlet weak var rateTFView: CustomTextFieldView!
    @IBOutlet weak var buttonView: CustomButtonView!
    @IBOutlet weak var dueDayTitleLabel: UILabel!
    @IBOutlet weak var firstRadioButton: CustomRadioButtonView!
    @IBOutlet weak var secondRadioButton: CustomRadioButtonView!
    @IBOutlet weak var thirdRadioButton: CustomRadioButtonView!
    @IBOutlet weak var fourthRadioButton: CustomRadioButtonView!
    @IBOutlet weak var DayOfMonthView: UIView!
    @IBOutlet weak var dueDateValueLabel: UILabel!
    @IBOutlet weak var DueDateTitleLabel: UILabel!
    
    
    
    private let TAG_BRANCH = 1000
    private let TAG_PRODUCTTYPE = 1001
    private let TAG_SCHEME = 1002
    private let TAG_LOANPURPOSE = 1003
    private let TAG_AGENT = 1004
    
    var selectedLOVDic: [String: DropDown] = [:]
    private var dueDatePopView: DueDateCustomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    
    func setupView() {
        
//        branchLOV.setLOVProperties(masterName: Constants.ENTITY_PHONE_COUNTRYCODE, title: "Branch", tag: TAG_BRANCH, autoFillValue: "", delegate: self)
//        productTypeLOV.setLOVProperties(masterName: Constants.ENTITY_PHONE_COUNTRYCODE, title: "ProductType", tag: TAG_PRODUCTTYPE, autoFillValue: "", delegate: self)
//        schemeLOV.setLOVProperties(masterName: Constants.ENTITY_PHONE_COUNTRYCODE, title: "Scheme", tag: TAG_SCHEME, autoFillValue: "", delegate: self)
//        loanPurposeLOV.setLOVProperties(masterName: Constants.ENTITY_PHONE_COUNTRYCODE, title: "Loan Purpose", tag: TAG_LOANPURPOSE, autoFillValue: "", delegate: self)
//        
//        agentLOV.setLOVProperties(masterName: Constants.ENTITY_PHONE_COUNTRYCODE, title: "Sales Agent", tag: TAG_AGENT, autoFillValue: "", delegate: self)
        
        
        loanAmountTFView.setProperties(placeHolder: "Loan Amount Requested", type: .Amount, delegate: self)
        tenureTFView.setProperties(placeHolder: "Tenure", type: .Number, delegate: self)
        rateTFView.setProperties(placeHolder: "Rate of interest", type: .Number, delegate: self)
        
        buttonView.setProperties(doneBtnTitle: "Save Details", delegate: self)

        dueDayTitleLabel.font = CustomFont.shared().GETFONT_REGULAR(19)
        dueDateValueLabel.font = CustomFont.shared().GETFONT_REGULAR(19)
        DueDateTitleLabel.font = CustomFont.shared().GETFONT_REGULAR(19)
        
        firstRadioButton.setProperties(title: "5th", delegate: self)
        secondRadioButton.setProperties(title: "10th", delegate: self)
        thirdRadioButton.setProperties(title: "15th", delegate: self)
        fourthRadioButton.setProperties(title: "Others", delegate: self)
        fourthRadioButton.setButtonState(isSelected: true)
        
        DayOfMonthView.setMainViewProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         
         if let headerView = AppDelegate.instance.headerView, let bottomView = AppDelegate.instance.bottomTabbarView {
             headerView.showHideStepHeaderView(isHide: false, title: "Loan Details", step: "")
             bottomView.isHidden = true
         }
     }
    
    func unSelectAllRadioButton() {
        firstRadioButton.setButtonState(isSelected: false)
        secondRadioButton.setButtonState(isSelected: false)
        thirdRadioButton.setButtonState(isSelected: false)
        fourthRadioButton.setButtonState(isSelected: false)
    }
    @IBAction func dueDatesButtonAction(_ sender: Any) {
        
        if self.dueDatePopView == nil {
            self.dueDatePopView = .fromNib()
            self.dueDatePopView.setProperties(width: self.view.frame.size.width, height: self.view.frame.size.height, delegate: self)
            self.view.addSubview(self.dueDatePopView)
        }

        self.dueDatePopView.alpha = 1
    }
}

extension SourcingLoanDetailVC: SelectedLOVDelegate {
    
    func selectedLOVResult(selectedObj: DropDown, btntag: Int) {
        selectedLOVDic["\(btntag)"] = selectedObj
        
    }
}

extension SourcingLoanDetailVC: CustomTFViewDelegate {
    func validateFields() {
        print("customTextFieldDelegate")
    }
}

extension SourcingLoanDetailVC: CustomButtonViewDelegate {
    
    func nextButtonAction() {
        print("save details call")
    }

}

extension SourcingLoanDetailVC: CustomRBViewDelegate {
    func selectedRadioButton(view: CustomRadioButtonView) {
       unSelectAllRadioButton()
        view.radioButton.isSelected = true
    }

}

extension SourcingLoanDetailVC: DueDateCustomViewDeleagte {
    func selectedDueDate(day: String) {
        dueDateValueLabel.text = "\(day)th"
    }

}

//extension SourcingLoanDetailVC:
