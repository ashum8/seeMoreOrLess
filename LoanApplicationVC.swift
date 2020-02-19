//
//  LoanApplicationVC.swift
//  mCAS
//
//  Created by iMac on 24/12/19.
//  Copyright © 2019 Nucleus. All rights reserved.
//

import UIKit

class LoanApplicationVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataShownForLabel: UILabel!
    @IBOutlet weak var daysLeftButton: UIButton!
    @IBOutlet weak var noDataCapturedView: CustomNoDataView!
    @IBOutlet weak var daysFilterView: UIView!
    @IBOutlet weak var daysFilterViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchExternalButton: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tagView: TagListView!
    @IBOutlet weak var clearFilterButton: UIButton!
    
    private enum HeaderOptions: String {
        case exSearch = "Search External"
    }
    
    private var dateRangeView: DateRangeFilterView!
    private var daysListArray: [DAYFILTER] = [.SevenDay, .FifteenDay, .ThirtyDay, .Range]
    private var headerOptionArray: [HeaderOptions] = [.exSearch]
    
    //SK Change
    private var listModelArray = [SEModelClasses.ApplicationStatusList]()
    private var filteredListModelArray = [SEModelClasses.ApplicationStatusList]()
    
    private var selectedDay: DAYFILTER = .SevenDay
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Color.LIGHTER_GRAY
        
        noDataCapturedView.setProperties()
        daysFilterView.layer.masksToBounds = true
        filterView.layer.masksToBounds = true
        clearFilterButton.titleLabel?.font = CustomFont.shared().GETFONT_REGULAR(17)
        clearFilterButton.setTitleColor(Color.BLUE, for: .normal)
        
        setButtonTitleAndIcon(text: selectedDay.rawValue, up: false)
        dataShownForLabel.font = CustomFont.shared().GETFONT_REGULAR(17)
        
        tableView.register(UINib.init(nibName: "CasesCell", bundle: Bundle.main), forCellReuseIdentifier: "CasesCell")
        tableView.tableFooterView = UIView()
        
        setTagsViewProperties()
        searchExternalButton.setButtonProperties()
        refreshList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let headerView = AppDelegate.instance.headerView, let bottomView = AppDelegate.instance.bottomTabbarView {
            bottomView.isHidden = true
            headerView.setTitleWithShowBackButton(line1: "Status", showBackButton: true)
            headerView.showHideSearchMikeFilterOption(showSearch: true, delegate: self, showFilter: true, showOption: true, masterName: Entity.PRODUCT_CATEGORY, title: "Product Type", optionDelegate: self, optionArray: headerOptionArray.map({ $0.rawValue }))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let headerView = AppDelegate.instance.headerView {
            //set delegate self as we are using filter to move to next screen
            headerView.showHideSearchMikeFilterOption(showSearch: false, delegate: self)
        }
    }
    
    @IBAction func searchExternalButtonAction(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: Storyboard.STATUS_ENQUIRY, bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "ExternalSearchVC") as? ExternalSearchVC {
            AppDelegate.instance.applicationNavController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setButtonTitleAndIcon(text: String, up: Bool) {
        if up {
            daysLeftButton.setButtonTextAndRightIcon(title: text, image: "list_arrow_up")
        }
        else {
            daysLeftButton.setButtonTextAndRightIcon(title: text, image: "list_arrow_down")
        }
    }
    
    private func setTagsViewProperties() {
        tagView.textFont = CustomFont.shared().GETFONT_REGULAR(15)
        tagView.textColor = .darkGray
        tagView.tagBackgroundColor = Color.LIGHTER_GRAY
        tagView.alignment = .left
        tagView.enableRemoveButton = true
        tagView.removeButtonIconSize = 10
        tagView.removeIconLineWidth = 2
        tagView.removeIconLineColor = .darkGray
        tagView.cornerRadius = 15
        tagView.paddingX = 10
        tagView.paddingY = 10
        tagView.marginX = 10
        tagView.marginY = 10
        tagView.borderWidth = 1
        tagView.borderColor = .lightGray
        tagView.selectedTextColor = .darkGray
        tagView.delegate = self
    }
    
    @objc func refreshList() {
        listModelArray.removeAll()
        fetchCases()
    }
    
    func fetchCases() {
        
        let dates = CommonUtils.shared().fetchFromDateAndToDateForDayFilter(from: self.dateRangeView?.dateFromView.getFieldValue() ?? "", to: self.dateRangeView?.dateToView.getFieldValue() ?? "", selectedDay: selectedDay)
        
        let param : [String:Any] = ["fromDate"   : dates.0,
                                    "toDate"     : dates.1]
        
        Webservices.shared().POST(urlString: ServiceUrl.GET_ALL_CASES_SE_URL, paramaters: param, autoHandleLoader: true, success: { (header ,responseObj) in
            
            if let response = responseObj as? [[String : AnyObject]]
            {
                CommonUtils.shared().JSONtoModel(jsonObject: response, type: [SEModelClasses.ApplicationStatusList].self) { list in
                    
                        self.listModelArray.append(contentsOf: list)
                        self.filteredListModelArray = self.listModelArray
                }
            }
            
            self.setListData()
            
        }, failure: { (error) in
            
            self.setListData()
            
        }, noNetwork: { (error) in
            
            self.setListData()
        })
    }
    
    func setListData(isSearchON: Bool = false) {
        
        daysFilterViewHeight.constant = (isSearchON || !tagView.tagViews.isEmpty) ? 0 : 45
        tableView.isHidden = filteredListModelArray.isEmpty
        noDataCapturedView.isHidden = !filteredListModelArray.isEmpty || isSearchON
        searchExternalButton.isHidden = !filteredListModelArray.isEmpty || isSearchON
        tableView.reloadData()
    }
    
    
    @IBAction func daysLeftButtonClicked(_ sender: Any) {
        
        let listArray = daysListArray.map({ $0.rawValue })
        
        let obj = SimpleListVC.init(nibName: "SimpleListVC", bundle: nil)
        obj.setData(listArray: listArray, selectedValue: self.selectedDay.rawValue, delegate: self)
        
        if let popoverPresentationController = obj.popoverPresentationController {
            self.view.endEditing(true)
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = self.daysLeftButton
            popoverPresentationController.sourceRect = self.daysLeftButton.bounds
            popoverPresentationController.delegate = self
            present(obj, animated: true, completion: nil)
        }
    }
    
    @IBAction func clearFilterButtonAction(_ sender: Any) {
        filterViewHeight.constant = 0
        tagView.removeAllTags()
        setListData()
    }
    
    private func moveToNext(arr: [SEModelClasses.StatusEnquiryRecords]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            let storyboard = UIStoryboard.init(name: Storyboard.STATUS_ENQUIRY, bundle: nil)
            
            if let vc = storyboard.instantiateViewController(withIdentifier: "LoanApplicationDetailVC") as? LoanApplicationDetailVC {
                vc.setDate(data: arr[0])
                AppDelegate.instance.applicationNavController?.pushViewController(vc, animated: true)
            }
        })
    }
    
}

extension LoanApplicationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredListModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CasesCell") as! CasesCell
        
        let model = filteredListModelArray[indexPath.row]
        let customerType = model.applicant?.customerType?.code
        let productTypeCode = model.loanDetail?.productType?.code
        
        if let code = customerType, code == Constants.CUSTOMER_TYPE_INDV {
            cell.label1.text = model.applicant!.firstName! + " " + model.applicant!.lastName!
        }
        else {
            cell.label1.text = model.applicant?.institutionName
        }
        
        cell.label2.text = "\(model.neoReferenceNumber ?? "") \(Constants.SEPERATOR) " + "\(model.loanDetail?.loanAmount ?? 0)".formatCurrency
        
        cell.loanTypeLabel.text = model.loanDetail?.productType?.name
        cell.setProperties(cellIndex: indexPath.row, customerType: customerType, showArrow: true, productTypeCode: productTypeCode)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        getDataFromApplicationNumber(neoRefNumber: filteredListModelArray[indexPath.row].neoReferenceNumber ?? "")
    }
    
    private func getDataFromApplicationNumber(neoRefNumber: String) {
        let params = ["searchParameters"         : ["applicationNumber"   : neoRefNumber]]
        
        Webservices.shared().POST(urlString: ServiceUrl.SEARCH_CASES_SE_URL, paramaters: params, autoHandleLoader: true, success: { (header, responseObj) in
            if let response = responseObj as? [[String: Any]]
            {
                CommonUtils.shared().JSONtoModel(jsonObject: response, type: [SEModelClasses.StatusEnquiryRecords].self) { list in
                    self.moveToNext(arr: list)
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


extension LoanApplicationVC: SearchHeaderDelegate {
    
    func searchOnOff(isSearching: Bool) {
        handleSearch(text: "")
        setListData(isSearchON: isSearching)
    }
    
    func handleSearch(text: String) {
        
        //SK Change
        if !text.isEmpty{
            
            filteredListModelArray = listModelArray.filter {
                let customerType = $0.applicant?.customerType?.code
                if let code = customerType, code == Constants.CUSTOMER_TYPE_INDV {
                    return ($0.applicant!.firstName!.lowercased().contains(text.lowercased())) || ($0.neoReferenceNumber!.lowercased().contains(text.lowercased()))
                }
                else {
                    return ($0.applicant!.institutionName!.lowercased().contains(text.lowercased())) || ($0.neoReferenceNumber!.lowercased().contains(text.lowercased()))
                }
            }
        }
        else {
            filteredListModelArray = listModelArray
        }
        setListData(isSearchON: true)
        tableView.reloadData()
    }
    
    func handleSelectedFilters(filterArray: [DropDown]) {
        tagView.removeAllTags()
        for obj in filterArray {
            tagView.addTag(obj.name)
        }
        updateTagViewHeight()
        
        let arr = filterArray.map({$0.code})
        filteredListModelArray = listModelArray.filter {
            let productType = $0.loanDetail?.productType?.code
            return arr.contains(productType)
        }
        self.setListData()
        tableView.reloadData()
    }
    
    private func updateTagViewHeight() {
        if let lastView = tagView.rowViews.last {
            filterViewHeight.constant = lastView.frame.origin.y + lastView.frame.size.height + 10
        }
        else {
            filterViewHeight.constant = 0
        }
    }
}

extension LoanApplicationVC: TagListViewDelegate {
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        
        self.tagView.removeTagView(tagView)
        updateTagViewHeight()
    }
}


extension LoanApplicationVC: DropdownHeaderDelegate {
    
    func handleSelectedDropDown(index: Int) {
        let selectedItem = self.headerOptionArray[index]
        
        if selectedItem == .exSearch {
            searchExternalButton.sendActions(for: .touchUpInside)
        }
    }
}

extension LoanApplicationVC: SimpleListVCDelegate {
    
    func selectedListOption(index: Int) {
        
        self.dismiss(animated: true) {
            
            let item = self.daysListArray[index]
            
            if item == .Range {
                if self.dateRangeView == nil {
                    self.dateRangeView = .fromNib()
                    self.dateRangeView.setProperties(width: self.view.frame.size.width, height: self.view.frame.size.height, delegate: self)
                    self.view.addSubview(self.dateRangeView)
                }
                
                self.dateRangeView.alpha = 1
            }
            else {
                self.selectedDay = item
                self.setButtonTitleAndIcon(text: self.selectedDay.rawValue, up: false)
                self.refreshList()
            }
        }
    }
}

extension LoanApplicationVC: DateRangeViewDelegate {
    
    func dateRangeFilterCall(fromDate: String, toDate: String) {
        self.selectedDay = .Range
        self.setButtonTitleAndIcon(text: "\(fromDate) - \(toDate)", up: false)
        self.refreshList()
    }
}

extension LoanApplicationVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.delegate = nil
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}



