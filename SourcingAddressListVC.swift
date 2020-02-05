//
//  SourcingAddressListVC.swift
//  mCAS
//
//  Created by iMac on 24/01/20.
//  Copyright © 2020 Nucleus. All rights reserved.
//

import UIKit

class SourcingAddressListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var noDataCapturedLabel: UILabel!
    @IBOutlet weak var noDataCapturedView: UIView!
    @IBOutlet weak var buttonView: NextBackButtonView!
    @IBOutlet weak var headerTitleView: SourcingTitleView!
    
    private struct EmploymentDataModel {
        var title: String
        var type: String
    }
    private var customerType: ApplicantType!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        
        headerTitleView.setProperties(title: "Address")
        
        self.view.backgroundColor = Color.LIGHTER_GRAY
        
        addButton.setPlusButtonProperties()
        
        noDataCapturedLabel.font = CustomFont.shared().GETFONT_REGULAR(19)
        
        tableView.tableFooterView = UIView()
        
        buttonView.setProperties(showBack: true, doneBtnTitle: "Skip", delegate: self)
        
        setListData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let headerView = AppDelegate.instance.headerView {
            headerView.showHideStepHeader(isHide: false, title: "Add Applicant")
        }
    }
    
    private func setListData() {
        
        tableView.isHidden = true
        noDataCapturedView.isHidden = !tableView.isHidden
        self.tableView.reloadData()
    }
    
    func setData(type: ApplicantType) {
        self.customerType = type
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        
        let st = UIStoryboard.init(name: Storyboard.SOURCING, bundle: nil)
        
        if let vc = st.instantiateViewController(withIdentifier: "AddAddressVC") as? AddAddressVC  {
            AppDelegate.instance.applicationNavController.pushViewController(vc , animated: true)
        }
        
    }
    
}

extension SourcingAddressListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SourcingCommonListCell", for: indexPath) as! SourcingCommonListCell
        
        
        return cell
    }
    
}

extension SourcingAddressListVC : NextBackButtonDelegate {
    func nextButtonAction() {
        
        if customerType == .Corporate {
            
        }
        else {
            let st = UIStoryboard.init(name: Storyboard.SOURCING, bundle: nil)
            
            if let vc = st.instantiateViewController(withIdentifier: "IncomeListVC") as? IncomeListVC {
                AppDelegate.instance.applicationNavController.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

