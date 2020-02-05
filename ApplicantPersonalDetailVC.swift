//
//  ApplicantPersonalDetailVC.swift
//  mCAS
//
//  Created by iMac on 21/01/20.
//  Copyright © 2020 Nucleus. All rights reserved.
//

import UIKit

class ApplicantPersonalDetailVC: UIViewController {
    
    @IBOutlet weak var headerTitleView: SourcingTitleView!
    @IBOutlet weak var salutationLOV: LOVFieldView!
    @IBOutlet weak var firstNameView: CustomTextFieldView!
    @IBOutlet weak var middleNameView: CustomTextFieldView!
    @IBOutlet weak var middleNameViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lastNameView: CustomTextFieldView!
    @IBOutlet weak var lastNameViewHeight: NSLayoutConstraint!
    @IBOutlet weak var genderLOV: LOVFieldView!
    @IBOutlet weak var genderLOVHeight: NSLayoutConstraint!
    @IBOutlet weak var dateOfBirthView: CustomTextFieldView!
    @IBOutlet weak var dateOfBirthViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fathersNameView: CustomTextFieldView!
    @IBOutlet weak var fathersNameViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mothersMaidenNameView: CustomTextFieldView!
    @IBOutlet weak var mothersMaidenNameViewHeight: NSLayoutConstraint!
    @IBOutlet weak var maritalStatusLOV: LOVFieldView!
    @IBOutlet weak var maritalStatusLOVHeight: NSLayoutConstraint!
    @IBOutlet weak var noOfDependantView: CustomStepperView!
    @IBOutlet weak var noOfDependantViewHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryLOV: LOVFieldView!
    @IBOutlet weak var categoryLOVHeight: NSLayoutConstraint!
    @IBOutlet weak var citizenshipLOV: LOVFieldView!
    @IBOutlet weak var citizenshipLOVHeight: NSLayoutConstraint!
    @IBOutlet weak var residentialStatusLOV: LOVFieldView!
    @IBOutlet weak var residentialStatusLOVHeight: NSLayoutConstraint!
    @IBOutlet weak var emailView: CustomTextFieldView!
    @IBOutlet weak var mobileNoView: CustomMobileNumberView!
    @IBOutlet weak var phoneNoView: CustomPhoneNumberView!
    @IBOutlet weak var languageLOV: LOVFieldView!
    @IBOutlet weak var buttonView: NextBackButtonView!
//        corporate
    @IBOutlet weak var incorporationDateView: CustomTextFieldView!
    @IBOutlet weak var incorporationDateViewHeight: NSLayoutConstraint!
    @IBOutlet weak var natureOfBusinessLOV: LOVFieldView!
    @IBOutlet weak var natureOfBusinessLOVHeight: NSLayoutConstraint!
    @IBOutlet weak var constitutionLOV: LOVFieldView!
    @IBOutlet weak var constitutionLOVHeight: NSLayoutConstraint!
    @IBOutlet weak var industryClassificationLOV: LOVFieldView!
    @IBOutlet weak var industryClassificationLOVHeight: NSLayoutConstraint!
    @IBOutlet weak var industryLOV: LOVFieldView!
    @IBOutlet weak var industryLOVHeight: NSLayoutConstraint!
    
    private let TAG_SALUTATION = 1000
    private let TAG_GENDER = 1001
    private let TAG_MARITAL = 1002
    private let TAG_CATEGORY = 1003
    private let TAG_CITIZENSHIP = 1004
    private let TAG_RESIDENTIAL_STATUS = 1005
    private let TAG_LANGUAGE = 1006
    private let TAG_COUNTRY_CODE_PHONE = 1007
    private let TAG_COUNTRY_CODE_MOBILE = 1008
    
    private let TAG_NATURE_OF_BUSINESS = 1009
    private let TAG_CONSTITUTION = 1010
    private let TAG_INDUSTRY_CLASS = 1011
    private let TAG_INDUSTRY = 1012
    
    private let TAG_NAME = 10000
    
    private var selectedLOVDic: [String: DropDown] = [:]
    private var customerType: ApplicantType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        if customerType == .Corporate {
            headerTitleView.setProperties(title: "Corporate")
            middleNameViewHeight.constant = 0
            lastNameViewHeight.constant = 0
            genderLOVHeight.constant = 0
            dateOfBirthViewHeight.constant = 0
            fathersNameViewHeight.constant = 0
            mothersMaidenNameViewHeight.constant = 0
            maritalStatusLOVHeight.constant = 0
            noOfDependantViewHeight.constant = 0
            categoryLOVHeight.constant = 0
            citizenshipLOVHeight.constant = 0
            residentialStatusLOVHeight.constant = 0
            
            incorporationDateViewHeight.constant = 65
            natureOfBusinessLOVHeight.constant = 65
            constitutionLOVHeight.constant = 65
            industryClassificationLOVHeight.constant = 65
            industryLOVHeight.constant = 65
                    
            salutationLOV.setLOVProperties(masterName: "", title: "Applicant Type", tag: TAG_SALUTATION, delegate: self)
            natureOfBusinessLOV.setLOVProperties(masterName: Entity.BUSINESS_NATURE, title: "Nature Of Business", tag: TAG_NATURE_OF_BUSINESS, delegate: self)
            constitutionLOV.setLOVProperties(masterName: Entity.CONSTITUTION, title: "Constitution", tag: TAG_CONSTITUTION, delegate: self)
            industryClassificationLOV.setLOVProperties(masterName: Entity.INDUSTRY_CLAS, title: "Industry Classification", tag: TAG_INDUSTRY_CLASS, delegate: self)
            industryLOV.setLOVProperties(masterName: Entity.INDUSTRY, title: "Industry", tag: TAG_INDUSTRY, delegate: self)
            languageLOV.setLOVProperties(masterName: Entity.PREFERRED_LANGUAGE, title: "Preferred Language Of Communication", tag: TAG_LANGUAGE, delegate: self)
            
            firstNameView.setProperties(placeHolder: "Institution Name", delegate: self, tag: TAG_NAME)
            incorporationDateView.setProperties(placeHolder: "Incorporation Date", type: .DATE, delegate: self)
            
        }
        else {
            headerTitleView.setProperties(title: "Personal")
            
            firstNameView.setProperties(placeHolder: "First Name", delegate: self, tag: TAG_NAME)
            middleNameView.setProperties(placeHolder: "Middle Name", delegate: self, tag: TAG_NAME)
            lastNameView.setProperties(placeHolder: "Last Name", delegate: self, tag: TAG_NAME)
            dateOfBirthView.setProperties(placeHolder: "Date Of Birth", type: .DOB, delegate: self)
            fathersNameView.setProperties(placeHolder: "Father's Full Name", delegate: self, tag: TAG_NAME)
            mothersMaidenNameView.setProperties(placeHolder: "Mother's Maiden Name", delegate: self, tag: TAG_NAME)
            
            salutationLOV.setLOVProperties(masterName: Entity.SALUTATION, title: "Salutation", tag: TAG_SALUTATION, delegate: self)
            genderLOV.setLOVProperties(masterName: Entity.GENDER, title: "Gender", tag: TAG_GENDER, delegate: self)
            maritalStatusLOV.setLOVProperties(masterName: Entity.MARITAL, title: "Marital Status", tag: TAG_MARITAL, delegate: self)
            
            categoryLOV.setLOVProperties(masterName: Entity.CUSTOMER_CATEGORY, title: "Category", tag: TAG_CATEGORY, delegate: self)
            citizenshipLOV.setLOVProperties(masterName: Entity.CITIZEN, title: "Citizenship", tag: TAG_CITIZENSHIP, delegate: self)
            residentialStatusLOV.setLOVProperties(masterName: Entity.RESIDENT_TYPE, title: "Residential Status", tag: TAG_RESIDENTIAL_STATUS, delegate: self)
            languageLOV.setLOVProperties(masterName: Entity.PREFERRED_LANGUAGE, title: "Preferred Language Of Communication", tag: TAG_LANGUAGE, delegate: self)
                        
            noOfDependantView.setProperties(title: "No. of Dependants")
        }
        
        emailView.setProperties(placeHolder: "Email Id", type: .Email, delegate: self)
        mobileNoView.setProperties(tag: TAG_COUNTRY_CODE_MOBILE, delegate: self)
        phoneNoView.setProperties(tag: TAG_COUNTRY_CODE_PHONE, delegate: self)
        buttonView.setProperties(doneBtnTitle: "Continue", delegate: self)
                validateFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let headerView = AppDelegate.instance.headerView, let bottomView = AppDelegate.instance.bottomTabbarView {
            headerView.showHideStepHeader(isHide: false, title: "Add Applicant")
            bottomView.isHidden = true
        }
    }
    
    func setData(type: ApplicantType) {
           self.customerType = type
       }
    
}

extension ApplicantPersonalDetailVC: CustomTFViewDelegate {
    
    func validateFields() {
        
        var isEnabled = true
//        Add TAG_SALUTATION validation
        if customerType == .Corporate {
            isEnabled = !(firstNameView.getFieldValue().isEmpty || incorporationDateView.getFieldValue().isEmpty  || selectedLOVDic["\(TAG_NATURE_OF_BUSINESS)"] == nil || selectedLOVDic["\(TAG_CONSTITUTION)"] == nil || selectedLOVDic["\(TAG_INDUSTRY_CLASS)"] == nil || selectedLOVDic["\(TAG_INDUSTRY)"] == nil || !emailView.getFieldValue().isValidEmail || selectedLOVDic["\(TAG_COUNTRY_CODE_MOBILE)"] == nil || !mobileNoView.mobileNoTFView.getFieldValue().isValidPhone || selectedLOVDic["\(TAG_COUNTRY_CODE_PHONE)"] == nil || phoneNoView.stdCodeView.getFieldValue().isEmpty || phoneNoView.phoneNumberTFView.getFieldValue().isEmpty || selectedLOVDic["\(TAG_LANGUAGE)"] == nil )
        }
        else {
            isEnabled = !(selectedLOVDic["\(TAG_SALUTATION)"] == nil || firstNameView.getFieldValue().isEmpty || lastNameView.getFieldValue().isEmpty  || selectedLOVDic["\(TAG_GENDER)"] == nil || dateOfBirthView.getFieldValue().isEmpty || fathersNameView.getFieldValue().isEmpty || mothersMaidenNameView.getFieldValue().isEmpty || selectedLOVDic["\(TAG_MARITAL)"] == nil || noOfDependantView.textFieldView.getFieldValue().isEmpty || selectedLOVDic["\(TAG_CATEGORY)"] == nil || selectedLOVDic["\(TAG_CITIZENSHIP)"] == nil || selectedLOVDic["\(TAG_RESIDENTIAL_STATUS)"] == nil || !emailView.getFieldValue().isValidEmail || selectedLOVDic["\(TAG_COUNTRY_CODE_MOBILE)"] == nil || !mobileNoView.mobileNoTFView.getFieldValue().isValidPhone || selectedLOVDic["\(TAG_COUNTRY_CODE_PHONE)"] == nil || phoneNoView.stdCodeView.getFieldValue().isEmpty || phoneNoView.phoneNumberTFView.getFieldValue().isEmpty || selectedLOVDic["\(TAG_LANGUAGE)"] == nil )
        }
        
        buttonView.nextButton.setEnableDisableButtonColor(isEnable: isEnabled)
    }
    
    func textFieldEditing(text: String, tag: Int) -> Bool {
        
        switch tag {
        case TAG_NAME:
            return text.validateStringWithRegex(regx: "^[a-zA-Z .]{1,100}$")
        default:
            return true
        }
    }
    
}


extension ApplicantPersonalDetailVC: NextBackButtonDelegate {
    func nextButtonAction() {
        let storyboard = UIStoryboard.init(name: Storyboard.SOURCING, bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "IdentificationListVC") as? IdentificationListVC {
            vc.setData(type: customerType)
            AppDelegate.instance.applicationNavController?.pushViewController(vc, animated: true)
        }
    }
    
    func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ApplicantPersonalDetailVC: SelectedLOVDelegate {
    
    func selectedLOVResult(selectedObj: DropDown, btntag: Int) {
        selectedLOVDic["\(btntag)"] = selectedObj
        validateFields()
    }
}
