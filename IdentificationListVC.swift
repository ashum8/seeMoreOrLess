//
//  IdentificationListVC.swift
//  mCAS
//
//  Created by iMac on 23/01/20.
//  Copyright © 2020 Nucleus. All rights reserved.
//

import UIKit

class IdentificationListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var noDataCapturedLabel: UILabel!
    @IBOutlet weak var noDataCapturedView: UIView!
    @IBOutlet weak var buttonView: NextBackButtonView!
    @IBOutlet weak var headerTitleView: SourcingTitleView!
    
    private enum DetailOptions: String {
        case viewDetail = "View/Edit Details"
        case delete = "Delete"
    }
    
    private struct IdentityDataModel {
        var identityTitle: String
        var identityNumber: String
    }
    
    private var identityModelArray = [IdentityDataModel]()
    private var cellOptionArray: [DetailOptions] = [.viewDetail, .delete]
    private var customerType: ApplicantType!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        
        identityModelArray.append(IdentityDataModel(identityTitle: "Aadhar No.", identityNumber: "AXFSRC780947536"))
        identityModelArray.append(IdentityDataModel(identityTitle: "PAN Card", identityNumber: "AXFSRC780947536"))
        identityModelArray.append(IdentityDataModel(identityTitle: "Aadhar No.", identityNumber: "AXFSRC780947536"))
        identityModelArray.append(IdentityDataModel(identityTitle: "PAN Card", identityNumber: "AXFSRC780947536"))
        identityModelArray.append(IdentityDataModel(identityTitle: "Aadhar No.", identityNumber: "AXFSRC780947536"))
        
        headerTitleView.setProperties(title: "Identification")
        
        self.view.backgroundColor = Color.LIGHTER_GRAY
        
        addButton.setPlusButtonProperties()
        
        noDataCapturedLabel.font = CustomFont.shared().GETFONT_REGULAR(19)
        
        tableView.register(UINib(nibName: "SourcingCommonListCell", bundle: nil), forCellReuseIdentifier: "SourcingCommonListCell")
        tableView.tableFooterView = UIView()
        
        buttonView.setProperties(showBack: true, doneBtnTitle: "Skip", delegate: self)
    }
    
    func setData(type: ApplicantType) {
        self.customerType = type
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let headerView = AppDelegate.instance.headerView {
            headerView.showHideStepHeader(isHide: false, title: "Add Applicant")
        }
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: Storyboard.SOURCING, bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "AddIdentificationVC") as? AddIdentificationVC {
            AppDelegate.instance.applicationNavController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension IdentificationListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return identityModelArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SourcingCommonListCell", for: indexPath) as! SourcingCommonListCell
        
        cell.setProperties(optionArray: cellOptionArray.map({ $0.rawValue }), cellIndex: indexPath.row, delegate: self)
        cell.label1.text = identityModelArray[indexPath.row].identityTitle
        cell.label2.text = identityModelArray[indexPath.row].identityNumber
        
        return cell
    }
    
    
}

extension IdentificationListVC : NextBackButtonDelegate {
    func nextButtonAction() {
        if customerType == .Corporate {
            let storyboard = UIStoryboard.init(name: Storyboard.SOURCING, bundle: nil)
            
            if let vc = storyboard.instantiateViewController(withIdentifier: "SourcingAddressListVC") as? SourcingAddressListVC {
                vc.setData(type: customerType)
                AppDelegate.instance.applicationNavController?.pushViewController(vc, animated: true)
            }
        }
        else {
            let storyboard = UIStoryboard.init(name: Storyboard.SOURCING, bundle: nil)
            
            if let vc = storyboard.instantiateViewController(withIdentifier: "EmploymentListVC") as? EmploymentListVC {
                AppDelegate.instance.applicationNavController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension IdentificationListVC : CommonListCellDelegate {
    
    func selectedIndex(index: Int, cellIndex: Int) {
        let item = self.cellOptionArray[index]
        if item == .viewDetail {
            let storyboard = UIStoryboard.init(name: Storyboard.SOURCING, bundle: nil)
            
            if let vc = storyboard.instantiateViewController(withIdentifier: "AddIdentificationVC") as? AddIdentificationVC {
                AppDelegate.instance.applicationNavController?.pushViewController(vc, animated: true)
            }
            
        }
        else if item == .delete {
            identityModelArray.remove(at: cellIndex)
            tableView.reloadData()
        }
    }
}
