//
//  CartViewController.swift
//  BSide
//
//  Created by Apple on 24/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CartViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,GuestDelegate,GIDSignInDelegate , GIDSignInUIDelegate, EmailAndMobileViewDelegate {
    var googleDict = [String :Any]()
    @IBOutlet weak var lblPageTitleCart: UILabel!
    
    @IBOutlet weak var btnClearAll: UIButton!
    @IBOutlet weak var lblYouHave: UILabel!
    @IBOutlet weak var lblItems: UILabel!
    @IBOutlet var cellOne: UITableViewCell!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var viewBox: UIView!
    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet var tblView: UITableView!
    var activityIndicator: ActivityIndicator = ActivityIndicator()
    var hasBoxSelected = true
    var arrViewCart : Array<ViewCartModel> = Array<ViewCartModel>()
    var arrViewProductCart : Array<ViewCartModel> = Array<ViewCartModel>()
    var arrViewBoxCart : Array<ViewCartModel> = Array<ViewCartModel>()
    @IBOutlet weak var tabProduct: UIButton!
    @IBOutlet weak var tabBox: UIButton!
    var tag : Int = 0
    var arrBox = [[String : Any]]()
    var arrProduct : Array<Any> = Array<Any>()
    var arrProduct1 : Array<Any> = Array<Any>()
    var arrProduct2: Array<Any> = Array<Any>()
    var arrProduc3 : Array<Any> = Array<Any>()
    var arrProduct4 : Array<Any> = Array<Any>()
    var totalPrice: Int?
    var boxDetailModel = [BoxDetailModel]()
    var vw  : GuestLoginView?
    override func viewDidLoad() {
        super.viewDidLoad()
//       arrCart = ["Ayu","Ayushi","poja","sonalika"]
        totalPrice = 0
        arrProduct = ["ayushu","najhf", "fhsf", "afasfja", "fafhaklf","ayushu","najhf", "fhsf", "sjfgajkfga", "hfvsjf", "afasfja","ayushu","najhf", "fhsf", "afasfja", "fafhaklf","afasfja","ayushu","najhf", "fhsf", "afasfja", "fafhaklf","ayushu","najhf", "fhsf", "sjfgajkfga", "hfvsjf", "afasfja","ayushu","najhf", "fhsf", "afasfja", "fafhaklf","afasfja","ayushu","najhf", "fhsf", "afasfja", "fafhaklf","ayushu"]
        arrProduct1 = ["najhf","fafhaklf",]
        arrProduct2 = [ "fafhaklf"]
        arrProduc3 = ["fhsf", "sjfgajkfga", "hfvsjf","gfhfffyfy"]
        arrProduct4 = ["ayushu","najhf", "fhsf", "sjfgajkfga", "hfvsjf", "afasfja","lasttttt"]
        arrBox = [["Value1": arrProduct],["Value1": arrProduct1], ["Value1": arrProduct2], ["Value1": arrProduc3], ["Value1": arrProduct4]]
        
        // Do any additional setup after loading the view.
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        customView.backgroundColor = UIColor.red
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        button.setTitle("Submit", for: .normal)
        appDelegate.isFirstTimeLogin = false
        customView.addSubview(button)
        self.tblView.register(UINib(nibName: "CartTableCell", bundle: nil), forCellReuseIdentifier: "CartTableCell")
         self.tblView.register(UINib(nibName: "BoxItemCell", bundle: nil), forCellReuseIdentifier: "BoxItemCell")
        let nibName = UINib(nibName: "SelectedBoxCell", bundle: nil)
        self.tblView.register(nibName, forHeaderFooterViewReuseIdentifier: "SelectedBoxCell")
        UIApplication.shared.statusBarView?.backgroundColor = .white

       tblView.contentInset  = UIEdgeInsets(top: -20, left: 0, bottom: 40, right: 0)
        UIView.appearance().semanticContentAttribute = .forceLeftToRight

        btnCart.layer.cornerRadius = 30
        btnCart.clipsToBounds = true
        btnCart.backgroundColor = Constant.GlobalConstants.AppThemeColor
        Defaults().selectedTab = 0
    }
   
    override func viewWillAppear(_ animated: Bool) {

        self.viewCartApiCall()
        tabProduct.backgroundColor = Constant.GlobalConstants.AppSelectedGenderColor
         tabBox.backgroundColor = Constant.GlobalConstants.AppUnselectedGenderColor
        tblView.reloadData()
        setupLables()
    }
    func setupLables() {
        if Defaults().language == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UIButton().semanticContentAttribute = .forceRightToLeft
        }
        else{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UIButton().semanticContentAttribute = .forceLeftToRight
        }
        
        lblPageTitleCart.text = SET_ALERT_TEXT(key: "Cart") as String
        btnClearAll.setTitle(SET_ALERT_TEXT(key: "Clear_All") as String, for: .normal)
        lblYouHave.text = SET_ALERT_TEXT(key: "You_have") as String
    }
    // MARK: - TableviewMethods
 
    func numberOfSections(in tableView: UITableView) -> Int {
//        return  arrBox.count + 2
//        if tag == 0{
            if arrViewCart.count > 0{
            return 2
            }
            else{
                return 1
            }
            
//        }
//        else if tag == 1{
//            return 2
//        }
       
       return 0
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tag == 0{
//            if arrViewProductCart.count > 0{
//                if section == 0{
//                    self.lblItems.text = "\(self.arrViewProductCart.count)" + " \(SET_ALERT_TEXT(key: "Items") as String)"
//                    return arrViewProductCart.count
//                }
//                else{
//                  return 1
//                }
//            }
//
//            else{
//                 self.lblItems.text = "0" + " \(SET_ALERT_TEXT(key: "Items") as String)"
//                tabProduct.backgroundColor = Constant.GlobalConstants.AppSelectedGenderColor
//                tabBox.backgroundColor = Constant.GlobalConstants.AppUnselectedGenderColor
//                return 0
//            }
//        }
//
//       else if tag == 1{
//            if arrViewBoxCart.count > 0{
//                if section == 0{
//                    return arrViewBoxCart.count
//                }
//                else{
//                    return 1
//                }
//            }
//
//
//
//        }
        
        if arrViewCart.count > 0{
            if section == 0{
                self.lblItems.text = "\(self.arrViewCart.count)" + " \(SET_ALERT_TEXT(key: "Items") as String)"
                return arrViewCart.count
            }
            else{
                return 1
            }
        }
        return 0
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if tag == 0{
        
            tabProduct.backgroundColor = Constant.GlobalConstants.AppSelectedGenderColor
            tabBox.backgroundColor = Constant.GlobalConstants.AppUnselectedGenderColor
             self.lblYouHave.text = "\(SET_ALERT_TEXT(key: "You_have") as String)"
           if indexPath.section == 0{
            let cell = tblView.dequeueReusableCell(withIdentifier: "CartTableCell", for: indexPath) as! CartTableCell
            cell.selectionStyle = .none
            cell.vwCard.backgroundColor = UIColor.clear
            cell.boxHeight.constant = 0
             let urlString : String?
            let arrAddonList = self.arrViewCart[indexPath.row].addedONs
            print("numner of added ons is \(arrAddonList.count)")
            if arrAddonList.count > 0 {
                cell.lblAddedons.isHidden = false
                if Defaults().language == "ar" {
                    cell.lblAddedons.textAlignment = .right
                }
                else{
                    cell.lblAddedons.textAlignment = .left
                }
                cell.lblAddedons.text = "*\(arrAddonList.count ) \((SET_ALERT_TEXT(key: "add_ons_added_with_this_product") as String))"
            } else {
                 cell.lblAddedons.isHidden = true
            }
            if arrViewCart.count > 0 {
                 self.lblItems.text = "\(self.arrViewCart.count)" + " \(SET_ALERT_TEXT(key: "Items") as String)"
                let dict = arrViewCart[indexPath.row]
                cell.pName.text = dict.product_name
                let price = dict.price
                 let priceCalc = CommonHelper.getPriceAfterConversion(value: Double(price ?? 0))
                cell.price.text = "\(priceCalc ?? 0) " + Defaults().currencyType
                let quant = dict.quantity
                urlString = dict.image
                if quant != 0 {
                    cell.lblQuantity.text = "\(quant ?? 0)"
                }
                else{
                    cell.lblQuantity.text = "1"
                }
                var url = "\(Constant.GlobalConstants.KImgBaseUrl)\(arrViewCart[indexPath.row].image ?? "")"
                if dict.product_type == 5 {
                    url = dict.giftwrapUrl ?? ""
//                    let arr = CommonHelper().StringToArray(str: url)
//                    if arr.count > 0 {
//                        url = arr[0] as? String ?? ""
//                    } else {
//                        url = ""
//                    }
                    
                }
                cell.img?.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "Placeholder.png"))
                // hide all box labels
                 cell.vwBorderLine.isHidden = true
                cell.boxImg.isHidden = true
                cell.lblBoxQuant.isHidden = true
                cell.lblBoxTotal.isHidden = true
                cell.lblBoxHeading.isHidden = true
                cell.lblBoxTotalAmount.isHidden = true
                cell.lblBoxQuantity.isHidden = true
                cell.btnBoxPlus.isHidden = true
                cell.btnBoxMinus.isHidden = true
                cell.btnRemoveBox.isHidden = true
                cell.btnMinus.isHidden = false
                cell.btnplus.isHidden = false
                cell.lblQuantity.isHidden = false
                cell.lblQunat.isHidden = false
                cell.btnMinus.isUserInteractionEnabled = true
                cell.btnplus.isUserInteractionEnabled = true
                cell.btnRemove.isUserInteractionEnabled = true
                cell.btnRemove.isHidden = false
                cell.topItemName.constant = 0
                cell.btnRemove.tag = indexPath.row
                cell.btnplus.tag = indexPath.row
                cell.btnMinus.tag = indexPath.row
                cell.btnRemove.addTarget(self, action:#selector(buttonDeletePressed(sender:)), for: .touchUpInside)
                cell.btnplus.addTarget(self, action:#selector(btnQuantityIncrease(sender:)), for: .touchUpInside)
                cell.btnMinus.addTarget(self, action:#selector(btnQuantityDecrease(sender:)), for: .touchUpInside)
//                URLImageCache.sharedCache.downloadImage(toDisplayOnTable: tblView, atIndexPath: indexPath, inImageView: cell.img, fromURLString: urlString ?? "") { (done, found, oldImage, imageInfo) in
//
//                }
//                cell.img?.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "Placeholder.png"))
                cell.btnShowProductDetail.removeTarget(nil, action: nil, for: .allEvents)
                cell.btnShowProductDetail.tag = indexPath.row
                cell.btnShowProductDetail.addTarget(self, action: #selector(BtnProductDetailClicked), for: .touchUpInside)
                let maxQuant = dict.max_quantity
                if maxQuant == 0 {
                    cell.lblSoldOut.isHidden = true
                   cell.lblSoldOut.text = "\(SET_ALERT_TEXT(key: "Sold_out") as String)"
                } else {
                    cell.lblSoldOut.isHidden = true
                }
            }
           cell.lblQunat.text = "\(SET_ALERT_TEXT(key: "Quantity") as String)"
           cell.btnRemove.setTitle("\(SET_ALERT_TEXT(key: "Remove_Item") as String)", for: .normal)
            return  cell
           }
        else {
            return cellOne
        }
//        }
       
//       else { //  if tag == 1
//              self.lblYouHave.text = "\(SET_ALERT_TEXT(key: "You_have") as String)"
//            tabProduct.backgroundColor = Constant.GlobalConstants.AppUnselectedGenderColor
//            tabBox.backgroundColor = Constant.GlobalConstants.AppSelectedGenderColor
//            self.lblItems.text = "\(self.arrViewBoxCart.count)" + " \(SET_ALERT_TEXT(key: "Customised_box﻿") as String)"
//
//            if indexPath.section == 0{
//                let cell = tblView.dequeueReusableCell(withIdentifier: "CartTableCell", for: indexPath) as! CartTableCell
//                cell.selectionStyle = .none
//                cell.vwCard.backgroundColor = UIColor.clear
//                cell.boxHeight.constant = 0
//                var urlString : String?
//                cell.lblAddedons.isHidden = true
//                if arrViewBoxCart.count > 0 {
//                    self.lblItems.text = "\(self.arrViewBoxCart.count)" + " \(SET_ALERT_TEXT(key: "Customised_box﻿") as String)"
//                    let dict = arrViewBoxCart[indexPath.row]
//                    cell.pName.text = dict.product_name
//
//                    let price = dict.price
//                    let priceCalc = CommonHelper.getPriceAfterConversion(value: Double(price ?? 0))
//                    cell.price.text = "\(priceCalc ) " + Defaults().currencyType
//                    let quant = dict.quantity
//                    urlString = dict.image
//                    if dict.product_type == 5 {
//                        urlString = dict.giftwrapUrl
//                        let arr = CommonHelper().StringToArray(str: urlString ?? "[]")
//                        if arr.count > 0 {
//                            urlString = arr[0] as? String ?? ""
//                        } else {
//                            urlString = ""
//                        }
//
//                    }
//                    if quant != 0 {
//                        cell.lblQuantity.text = "\(dict.quantity ?? 0)"
//                    }
//                    else{
//                        cell.lblQuantity.text = "1"
//                    }
//                    let url = "\(Constant.GlobalConstants.KImgBaseUrl)\(arrViewBoxCart[indexPath.row].image ?? "")"
//                    cell.img?.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "Placeholder.png"))
//
//                    // hide all box labels
//                    cell.vwBorderLine.isHidden = true
//                    cell.boxImg.isHidden = true
//                    cell.lblBoxQuant.isHidden = true
//                    cell.lblBoxTotal.isHidden = true
//                    cell.lblBoxHeading.isHidden = true
//                    cell.lblBoxTotalAmount.isHidden = true
//                    cell.lblBoxQuantity.isHidden = true
//                    cell.btnBoxPlus.isHidden = true
//                    cell.btnBoxMinus.isHidden = true
//                    cell.btnRemoveBox.isHidden = true
//                    cell.btnMinus.isHidden = false
//                    cell.btnplus.isHidden = false
//                    cell.lblQuantity.isHidden = false
//                    cell.lblQunat.isHidden = false
//                    cell.btnMinus.isUserInteractionEnabled = true
//                    cell.btnplus.isUserInteractionEnabled = true
//                    cell.btnRemove.isUserInteractionEnabled = true
//                    cell.btnRemove.isHidden = false
//                    cell.topItemName.constant = 0
//                    cell.btnRemove.tag = indexPath.row
//                    cell.btnplus.tag = indexPath.row
//                    cell.btnMinus.tag = indexPath.row
//                    cell.btnRemove.addTarget(self, action:#selector(buttonDeletePressed(sender:)), for: .touchUpInside)
//                    cell.btnplus.addTarget(self, action:#selector(btnQuantityIncrease(sender:)), for: .touchUpInside)
//                    cell.btnMinus.addTarget(self, action:#selector(btnQuantityDecrease(sender:)), for: .touchUpInside)
//                    URLImageCache.sharedCache.downloadImage(toDisplayOnTable: tblView, atIndexPath: indexPath, inImageView: cell.img, fromURLString: urlString ?? "") { (done, found, oldImage, imageInfo) in
//
//                    }
//                    cell.btnShowProductDetail.removeTarget(nil, action: nil, for: .allEvents)
//                    cell.btnShowProductDetail.tag = indexPath.row
//                    cell.btnShowProductDetail.addTarget(self, action: #selector(BtnBoxDetailClicked), for: .touchUpInside)
//                }
//
////            if indexPath.section == 5{
////                return cellOne
////            }
////            else{
////
////             let cell = tblView.dequeueReusableCell(withIdentifier: "CartTableCell", for: indexPath) as! CartTableCell
////                  cell.vwCard.backgroundColor = Constant.GlobalConstants.AppUnselectedGenderColor
//////            if indexPath.row == 0{
//////                cell.boxHeight.constant = 140
//////                cell.vwBorderLine.isHidden = false
//////                cell.boxImg.isHidden = false
//////                cell.lblBoxQuant.isHidden = false
//////                cell.lblBoxTotal.isHidden = false
//////                cell.lblBoxHeading.isHidden = false
//////                cell.lblBoxTotalAmount.isHidden = false
//////                cell.btnBoxPlus.isHidden = false
//////                cell.btnBoxMinus.isHidden = false
//////                 cell.lblBoxQuantity.isHidden = false
//////                cell.btnRemoveBox.isHidden = false
//////
////////                let urlString : String?
//////
////////
////////                    let dict = arrViewCart[indexPath.row]
////////                    cell.pName.text = dict.name
////////                    let price = dict.price
////////                    cell.price.text = "\(price ?? 0)"
////////                    let quant = dict.quantity
////////                    urlString = dict.image
////////                    cell.lblQuantity.text = quant
////////                    URLImageCache.sharedCache.downloadImage(toDisplayOnTable: tblView, atIndexPath: indexPath, inImageView: cell.img, fromURLString: urlString ?? "") { (done, found, oldImage, imageInfo) in
////////
////////                }
//////            }
//////            else{
////                cell.boxHeight.constant = 0
////                cell.boxImg.isHidden = true
////                cell.lblBoxQuant.isHidden = true
////                cell.lblBoxQuantity.isHidden = true
////                cell.lblBoxTotal.isHidden = true
////                cell.lblBoxHeading.isHidden = true
////                cell.lblBoxTotalAmount.isHidden = true
////                cell.btnBoxPlus.isHidden = true
////                cell.btnBoxMinus.isHidden = true
////                cell.btnRemoveBox.isHidden = true
////                cell.vwBorderLine.isHidden = true
////
//////            }
//////            cell.vwBorderLine.isHidden = true
////
////             cell.topItemName.constant = 20
////            cell.lblQuantity.isHidden = true
////            cell.lblQunat.isHidden = true
////            cell.btnMinus.isHidden = true
////            cell.btnplus.isHidden = true
////            cell.btnRemove.isHidden = false
////            cell.btnMinus.isUserInteractionEnabled = false
////            cell.btnplus.isUserInteractionEnabled = false
////            cell.btnRemove.isUserInteractionEnabled = false
////            cell.selectionStyle = .none
//            cell.lblQunat.text = "\(SET_ALERT_TEXT(key: "Quantity") as String)"
//            cell.btnRemove.setTitle("\(SET_ALERT_TEXT(key: "Remove_Item") as String)", for: .normal)
//            return cell
//            } else {
//                return cellOne
//            }
//            }
       
       return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tag == 0{
//            let storyboard = UIStoryboard(name: "ProductDetail", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
//            let productId = arrViewCart[indexPath.row].id
//            controller.productId = productId
//            self.present(controller, animated: true, completion: nil)
            
        }
        else if tag == 1{
            
        }
    }
    
    @objc func buttonDeletePressed(sender:UIButton) {
        if tag == 0 {
            let index = sender.tag
            let dict = arrViewCart[index]
            let productId = dict.id
            let giveaway = dict.is_giveaway
            print(productId)
            var params: [String: Any] = [:]
            //        dict["user_id"] = Defaults().userId
            let isGuestUser = UserDefaults.standard.bool(forKey: "isGuestLogin")
            if isGuestUser == true {
                params["user_id"] = UserDefaults.standard.object(forKey: Constant.GlobalConstants.KGuestID) as? String
            }
            else{
                params["user_id"] = UserDefaults.standard.object(forKey: Constant.GlobalConstants.KUserID) as? Int
            }
             params["product_type"] = dict.product_type
                if dict.product_type == 5 {
                    params["box_number"] = dict.box_no
                }
//             params["type"] = 1
//            if giveaway == 2 {
//                params["giveaway_id"] = productId
//            } else {
                params["cart_id"] = dict.cart_id
//            }
            self.clearCartApiCall(dict: params)
        } else {
            let index = sender.tag
            let dict = arrViewCart[index]
            let readygift = dict.is_readygift
            let productId = dict.id
            print(productId ?? 1)
            
            var params: [String: Any] = [:]
            //        dict["user_id"] = Defaults().userId
            let isGuestUser = UserDefaults.standard.bool(forKey: "isGuestLogin")
            if isGuestUser == true {
                params["user_id"] = UserDefaults.standard.object(forKey: Constant.GlobalConstants.KGuestID) as? String
            }
            else{
                params["user_id"] = UserDefaults.standard.object(forKey: Constant.GlobalConstants.KUserID) as? Int
            }
            params["product_type"] = dict.product_type
            params["type"] = 2
            if dict.product_type == 5 {
                 params["box_number"] = dict.box_no
            } else {
               params["cart_id"] = dict.cart_id
            }
            self.clearCartApiCall(dict: params)
        }
        
    }
    @IBAction func clearAll(_ sender: Any) {
        APPDELEGATE.deleteAllData("Product")
        var params: [String: Any] = [:]
//        if tag == 0 {
//            params["type"] = "1"
//        } else {
//            params["type"] = "2"
//        }
        let isGuestUser = UserDefaults.standard.bool(forKey: "isGuestLogin")
        if isGuestUser == true {
            params["user_id"] = UserDefaults.standard.object(forKey: Constant.GlobalConstants.KGuestID) as? String
        }
        else{
            params["user_id"] = UserDefaults.standard.object(forKey: Constant.GlobalConstants.KUserID) as? Int
        }
        self.clearCartApiCall(dict: params)
    }
    func removeItemsInCartApiCall(dict: [String: Any]) -> Void{

        let rechability = Reachability()
        self.activityIndicator.showActivityIndicator(uiView: self.view)
        if(rechability!.connection != .none) {
            APIServices.sharedInstance.universalPostApi(data: dict , method: Constant.GlobalConstants.removeItems, complition: { (result, error) in
                
                if error == nil {
                    
                    let status = result?[Constant.GlobalConstants.kStatus] as? Int ?? 0
                    let msg = result![Constant.GlobalConstants.KMessage] as! String
                    
                    if status  == 1 {
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.viewCartApiCall()
                        })
                    } else {
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.activityIndicator.hideActivityIndicator(uiView: self.view)
                            Function.shared.displayErrorMessage(message: msg, duration: 2.0)
                        })
                    }
                }
                else
                {
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.activityIndicator.hideActivityIndicator(uiView: self.view)
                        Function.shared.displayErrorMessage(message:SET_ALERT_TEXT(key: "Something_went_wrong" as NSString) as String , duration: 2.0)
                    })
                }
            })
            
        }
        else {
            DispatchQueue.main.async(execute: {() -> Void in
                self.activityIndicator.hideActivityIndicator(uiView: self.view)
            })
            Function.shared.displayErrorMessage(message: SET_ALERT_TEXT(key: "no_connection" as NSString) as String, duration: 2.0)
            
        }
    }
    
    func clearCartApiCall(dict: [String: Any]) -> Void{
        print(dict)
        let rechability = Reachability()
        self.activityIndicator.showActivityIndicator(uiView: self.view)
        if(rechability!.connection != .none) {
            APIServices.sharedInstance.universalPostApi(data: dict , method: Constant.GlobalConstants.clearcart, complition: { (result, error) in
                
                if error == nil {
                    
                    let status = result?[Constant.GlobalConstants.kStatus] as? Int ?? 0
                    let msg = result![Constant.GlobalConstants.KMessage] as! String
                    
                    if status  == 1 {
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.viewCartApiCall()
                        })
                    } else {
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.activityIndicator.hideActivityIndicator(uiView: self.view)
                            Function.shared.displayErrorMessage(message: msg, duration: 2.0)
                        })
                    }
                }
                else
                {
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.activityIndicator.hideActivityIndicator(uiView: self.view)
                        Function.shared.displayErrorMessage(message: SET_ALERT_TEXT(key: "Something_went_wrong" as NSString) as String, duration: 2.0)
                    })
                }
            })
            
        }
        else {
            DispatchQueue.main.async(execute: {() -> Void in
                self.activityIndicator.hideActivityIndicator(uiView: self.view)
            })
            Function.shared.displayErrorMessage(message: SET_ALERT_TEXT(key: "no_connection" as NSString) as String, duration: 2.0)
            
        }
    }
    
    @objc func btnQuantityIncrease(sender:UIButton) {
     
      
        let cell = tblView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? CartTableCell
            let upadatedPrice : Int?
        var dictParams: [String: Any] = [:]
        dictParams["user_id"] = Defaults().userId
        dictParams["type"] = 1
        let rechability = Reachability()
        if(rechability!.connection != .none) {
//            if tag == 0 {
                let dict = arrViewCart[ sender.tag]
                let quant = dict.quantity ?? 0
                var upadatedcount = Int(quant)
    //            let maxQuantity = dict.max_quantity ?? "2"
                if quant < dict.max_quantity ?? 0 {
                        upadatedcount = quant + 1
//                    cell!.lblQuantity.text = "\(upadatedcount )"
//                    dict.quantity = upadatedcount
                        let price = dict.price
        //                let tempPrice = price!  * Int(upadatedcount!)
//                        upadatedPrice  = price
//                        cell?.price.text = "\(upadatedPrice ?? 0) \(Defaults().currencyType)"
        //                dict.price = upadatedPrice!
                        dictParams["cart_id"] = dict.cart_id
                    self.addCartQuantityAPI(params: dictParams, index: sender.tag, type: 1, lbl: cell!.lblQuantity)
                    }
//            } else {
//                let dict = arrViewBoxCart[ sender.tag]
//                let quant = dict.quantity ?? 0
//                var upadatedcount = Int(quant)
//                let maxQuantity = dict.max_quantity ?? 0
//                if quant < maxQuantity {
//                    upadatedcount = quant + 1
//                    cell!.lblQuantity.text = "\(upadatedcount )"
//                    dict.quantity = upadatedcount
////                    let price = dict.price
//                    //                let tempPrice = price!  * Int(upadatedcount!)
////                    upadatedPrice  = price
////                    cell?.price.text = "\(upadatedPrice ?? 0) \(Defaults().currencyType)"
//                    //                dict.price = upadatedPrice!
//                    dictParams["cart_id"] = dict.cart_id
//                    self.addCartQuantityAPI(params: dictParams)
//                }
//            }
            }
            else {
                self.view.makeToast("Please check your internet connection !!!")
            }
           self.getTotalPrice()
           
        }
    
    @objc func btnQuantityDecrease(sender:UIButton) {
       
        let cell = tblView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? CartTableCell
             let upadatedPrice : Int?
        var dictParams: [String: Any] = [:]
        dictParams["user_id"] = Defaults().userId
        dictParams["type"] = 2
        let rechability = Reachability()
        if(rechability!.connection != .none) {
//            if tag == 0 {
                let dict = arrViewCart[sender.tag]
                        let quant = dict.quantity ?? 0
                if Int(quant) > 1 {
                    let upadatedcount = Int(quant)  - 1
                    
//                                cell!.lblQuantity.text = "\(upadatedcount)"
//                                dict.quantity = upadatedcount
//                                let price = dict.price
                                //                let tempPrice = price! * Int(upadatedcount)
//                                upadatedPrice  = price
//                                cell?.price.text = "\(upadatedPrice ?? 0) \(Defaults().currencyType)"
                                //                dict.price = upadatedPrice!
                                dictParams["cart_id"] = dict.cart_id
                    self.addCartQuantityAPI(params: dictParams, index: sender.tag, type: 2, lbl: cell!.lblQuantity)
                    
                    }
//            } else {
//                let dict = arrViewBoxCart[sender.tag]
//                let quant = dict.quantity ?? 0
//                if quant > 1 {
//                    let upadatedcount = Int(quant)  - 1
//                    cell!.lblQuantity.text = "\(upadatedcount)"
//                    dict.quantity = upadatedcount
////                    let price = dict.price
//                    //                let tempPrice = price! * Int(upadatedcount)
////                    upadatedPrice  = price
////                    cell?.price.text = "\(upadatedPrice ?? 0) \(Defaults().currencyType)"
//                    //                dict.price = upadatedPrice!
//                    dictParams["cart_id"] = dict.cart_id
//                    self.addCartQuantityAPI(params: dictParams)
//                }
//            }
        } else {
            self.view.makeToast("Please check your internet connection !!!")
        }
        self.getTotalPrice()
    }
    
    func addCartQuantityAPI(params: [String: Any], index: Int, type: Int, lbl: UILabel) {
        self.activityIndicator.showActivityIndicator(uiView: self.view)
    
        APIServices.sharedInstance.universalPostApi(data: params, method: Constant.GlobalConstants.addCartQuantity) { (result, error) in
            if error == nil {
                
                let status = result?[Constant.GlobalConstants.kStatus] as? Int ?? 0
                let message = result?["message"] as? String ?? SET_ALERT_TEXT(key: "Something_went_wrong" as NSString) as String
                if status  == 1 {
                    DispatchQueue.main.async(execute: {() -> Void in
                        if type == 1 {
                            let dict = self.arrViewCart[ index]
                            let quant = dict.quantity ?? 0
                            var upadatedcount = Int(quant)
                            //            let maxQuantity = dict.max_quantity ?? "2"
                            if quant < dict.max_quantity ?? 0 {
                                upadatedcount = quant + 1
                                lbl.text = "\(upadatedcount )"
                                dict.quantity = upadatedcount
                            }
                            self.getTotalPrice()
                        } else {
                            let dict = self.arrViewCart[index]
                            let quant = dict.quantity ?? 0
                            if Int(quant) > 1 {
                                let upadatedcount = Int(quant)  - 1
                                
                                lbl.text = "\(upadatedcount)"
                                dict.quantity = upadatedcount
                                
                            }
                            self.getTotalPrice()
                        }
                        
                        self.activityIndicator.hideActivityIndicator(uiView: self.view)
                    })
                }
                    
                else {
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.activityIndicator.hideActivityIndicator(uiView: self.view)
                        self.view.makeToast(message)
                    })
                }
            }
            else
            {
                DispatchQueue.main.async(execute: {() -> Void in
                    self.activityIndicator.hideActivityIndicator(uiView: self.view)
                self.view.makeToast(SET_ALERT_TEXT(key: "Something_went_wrong" as NSString) as String)
                })
            }
        }
    }
    
    @IBAction func btnTabSelection(_ sender: UIButton) {
        self.lblYouHave.text = "\(SET_ALERT_TEXT(key: "You_have") as String)"

//        if sender.tag == 0{
            tabProduct.backgroundColor = Constant.GlobalConstants.AppSelectedGenderColor
            tabBox.backgroundColor = Constant.GlobalConstants.AppUnselectedGenderColor
            tag = 0
             self.lblItems.text = "\(self.arrViewCart.count)" + " \(SET_ALERT_TEXT(key: "Items") as String)"
            
            self.getTotalPrice()
//        }
//        else if sender.tag == 1 {
//            tabProduct.backgroundColor = Constant.GlobalConstants.AppUnselectedGenderColor
//            tabBox.backgroundColor = Constant.GlobalConstants.AppSelectedGenderColor
//             tag = 1
//             self.lblItems.text = "0" + " \(SET_ALERT_TEXT(key: "Customised_box﻿") as String)"
//            self.getTotalPrice()
//        }
        tblView.reloadData()
        
    }
    //MARK:- UpdateCoreDataRecords
   
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    @IBAction func btnCartAction(_ sender: Any) {
        let isGuestUser = UserDefaults.standard.bool(forKey: "isGuestLogin")
        if isGuestUser == true {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
        let vw = UINib(nibName: "GuestLoginView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! GuestLoginView
            vw.isFromCart = true
        vw.frame = self.view.frame
        vw.delegate = self
       
        // let view = Bundle.main.loadNibNamed("CustomView", owner: nil, options: nil)!.first as! UIView // does the same as above
//        self.view.frame = self.view.bounds
        self.view.addSubview(vw)
        } else {
            self.addToCartProductFirst()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                let storyBoard = UIStoryboard.init(name: "Initial", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "CheckOutVC") as! CheckOutVC
                if self.tag == 0 {
                     vc.productType = "1"
                } else {
                     vc.productType = "2"
                }
                
                self.present(vc, animated: true, completion: nil)
            })
        }
    }
    func addToCartProductFirst() {
        if tag == 0 {
            for item in self.arrViewProductCart {
                let id = item.id ?? 0
                let is_giveAway = item.is_giveaway ?? 0
                let quantity: Int = item.quantity ?? 0
                var dictParams = Dictionary<String, Any>()
                if is_giveAway == 2 {
                    dictParams["giveaway_id"] = "\(id )"
                } else {
                    dictParams[Constant.GlobalConstants.KProductId] = "\(id )"
                }
                
                
                dictParams["user_id"] = UserDefaults.standard.object(forKey: Constant.GlobalConstants.KUserID) as? Int
                dictParams[Constant.GlobalConstants.KPQuantity] = "\(quantity)"
                dictParams["type"] = 1
                let rechability = Reachability()
                activityIndicator.showActivityIndicator(uiView: self.view)
                
                if(rechability!.connection != .none) {
                    
                    APIServices.sharedInstance.productCustomisation(data: dictParams, complition: { (result, error) in
                        
                        if error == nil {
                            
                            let status = result?[Constant.GlobalConstants.kStatus] as? Int ?? 0
                            
                            
                            if status  == 1 {
                                DispatchQueue.main.async(execute: {() -> Void in
                                    
                                    self.activityIndicator.hideActivityIndicator(uiView: self.view)
                                    
                                })
                                
                                DispatchQueue.main.async(execute: {() -> Void in
                                    
                                    self.activityIndicator.hideActivityIndicator(uiView: self.view)
                                })
                                
                            }
                                
                            else {
                                
                                DispatchQueue.main.async(execute: {() -> Void in
                                    //                                Function.shared.displayErrorMessage(message: Constant.GlobalConstants.KSomethingWentWrong, duration: 2.0)
                                    self.activityIndicator.hideActivityIndicator(uiView: self.view)
                                })
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.activityIndicator.hideActivityIndicator(uiView: self.view)
//                                Function.shared.displayErrorMessage(message: Constant.GlobalConstants.KServerError, duration: 2.0)
                            })
                        }
                    })
                } else {
                    DispatchQueue.main.async(execute: {() -> Void in
                        //                    Function.shared.displayErrorMessage(message: Constant.GlobalConstants.KSomethingWentWrong, duration: 2.0)
                        self.activityIndicator.hideActivityIndicator(uiView: self.view)
                    })
                }
                
            }
        } else if tag == 1 {
            
        }

        
    }
    func didTapButton(index: Int) {
        //        if index == 3{
        //            view?.removeFromSuperview()
        //        }
        //        else
        //            if index == 1{
        ////                vw?.removeFromSuperview()
        //                appDelegate.facebooklogin(controller: self)
        //
        //            }
        //            else if index == 2{
        //                GIDSignIn.sharedInstance().delegate = self
        //                GIDSignIn.sharedInstance().uiDelegate = self
        //                GIDSignIn.sharedInstance()?.signOut()
        //                GIDSignIn.sharedInstance().signIn()
        //                Defaults().introPage = "true"
        //            }
        //            else if index == 4{
        //                appDelegate.proceedToHomeVc()
        //        }
        //
        //        UserDefaults.standard.set(false, forKey: "isGuestLogin")
        if index == 0{
            let storyboard = UIStoryboard(name:"Main", bundle:nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SignUpTVC") as! SignUpTVC
            let obj = UINavigationController(rootViewController: vc)
            appDelegate.window?.rootViewController = obj
            UserDefaults.standard.removeObject(forKey: Constant.GlobalConstants.KAuthToken)
            UserDefaults.standard.set(false, forKey: "isGuestLogin")
            
        }
        else if index == 3{
            
            let storyboard = UIStoryboard(name:"Main", bundle:nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SignInTVC") as!  SignInTVC
            let aObjNavi = UINavigationController(rootViewController: vc)
            appDelegate.window?.rootViewController = aObjNavi
            appDelegate.window?.makeKeyAndVisible()
            UserDefaults.standard.removeObject(forKey: Constant.GlobalConstants.KAuthToken)
            UserDefaults.standard.set(false, forKey: "isGuestLogin")
            
        }
        else if index == 1{
            appDelegate.facebooklogin(controller: self)
            //            UserDefaults.standard.set(false, forKey: "isGuestLogin")
        }
            
        else if index == 2{
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance()?.signOut()
            CommonHelper().logout(selff: self, logoutOption: false)
            GIDSignIn.sharedInstance().signIn()
            Defaults().introPage = "true"
        }
        else if index == 4{
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
            self.vw?.removeFromSuperview()
            
        }
        
    }
    
    // MARK: - googleLOgin
    
    // MARK: - googleLOgin
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken ?? "" // Safe to send to the server
            let fullName = user.profile.name ?? ""
            //      let url = user.profile.imageURL(withDimension: UInt.)
            //            let givenName = user.profile.givenName
            //            let familyName = user.profile.familyName
            let email = user.profile.email ?? ""
            googleDict["id"] = idToken
            googleDict["name"] = fullName
            googleDict["email"] = email
            // googleDict["id"] = idToken
            appDelegate.apiCallSocailMediaSignIn(signUpBy: "google", name: fullName, email: email, token: idToken, id: userId ?? "", mobile: "")
            // ...
        }
    }
    
    func didTapButton(index: Int, email: String, mobile: String) {
        if index == 0{
            self.vw?.removeFromSuperview()
//            appDelegate.apiCallForGuestLoginCross(selff: self)
        }
        else{
            
            let userId  = googleDict["id"] as? String
            let firstName  = googleDict["name"] as? String
            
            //   let picture  = googleDict.object(forKey: "url") as? String
            appDelegate.apiCallSocailMediaSignIn(signUpBy: "google", name: firstName ?? "", email: email ?? "", token: "", id: userId ?? "" , mobile : mobile)
            
        }
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    // Implement these methods only if the GIDSignInUIDelegate is not a subclass of
    // UIViewController.
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error?) {
        activityIndicator.hideActivityIndicator(uiView: self.view)
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    //  // MARK: - Api Calls
    func viewCartApiCall() -> Void {
        
        var dict: [String: Any] = [:]
        //        dict["user_id"] = Defaults().userId
        let isGuestUser = UserDefaults.standard.bool(forKey: "isGuestLogin")
        if isGuestUser == true {
            dict["user_id"] = UserDefaults.standard.object(forKey: Constant.GlobalConstants.KGuestID) as? String
        }
        else{
            dict["user_id"] = UserDefaults.standard.object(forKey: Constant.GlobalConstants.KUserID) as? Int
        }
        let rechability = Reachability()
        self.activityIndicator.showActivityIndicator(uiView: self.view)
        if(rechability!.connection != .none) {
            APIServices.sharedInstance.universalPostApi(data: dict , method: Constant.GlobalConstants.cartItems, complition: { (result, error) in
                
                if error == nil {
                    
                    let status = result?[Constant.GlobalConstants.kStatus] as? Int ?? 0
                    let msg = result![Constant.GlobalConstants.KMessage] as! String
                    
                    if status  == 1 {
                        let response = result!["response"] as? [String : Any] ?? [:]
//                        if response.count > 0 {
                        let tempArray = response["product_list"] as? [[String: Any]] ?? []
                        self.arrViewCart.removeAll()
                        self.arrViewProductCart.removeAll()
                        self.arrViewBoxCart.removeAll()
                        for item in tempArray
                        {
                           let model = ViewCartModel()
                           model.parseCartData(withInfo: item)
                            self.arrViewCart.append(model)
                        }
                        DispatchQueue.main.async(execute: {() -> Void in
                             self.lblYouHave.text = "\(SET_ALERT_TEXT(key: "You_have") as String)"
                            if self.arrViewCart.count > 0{
                                self.arrViewProductCart = self.arrViewCart.filter { (model) -> Bool in
                                    let isReadyGift = model.type
//                                    let isGiveAway = model.is_giveaway
                                    
                                    if isReadyGift == 1 {
                                        return true
                                    } else {
                                        return false
                                    }
                                }
                                self.arrViewBoxCart = self.arrViewCart.filter { (model) -> Bool in
                                    let type = model.type
                                    if type == 2 {
                                        return true
                                    } else {
                                        return false
                                    }
                                }
                                self.lblItems.text = "\(self.arrViewProductCart.count)" + " \(SET_ALERT_TEXT(key: "Items") as String)"
                                self.btnClearAll.isHidden = false
                                self.imgNoData.isHidden = true
                            }
                            else{
                                self.btnClearAll.isHidden = true
                                self.imgNoData.isHidden = false
                                 self.lblItems.text = "0" + " \(SET_ALERT_TEXT(key: "Items") as String)"
                            }
                            
                            self.tblView.reloadData()
                            self.getTotalPrice()
                            self.activityIndicator.hideActivityIndicator(uiView: self.view)
                        })
                        
                        DispatchQueue.main.async(execute: {() -> Void in
                            
                            self.activityIndicator.hideActivityIndicator(uiView: self.view)
                        })
//                        } else {
//                            DispatchQueue.main.async(execute: {() -> Void in
//                                self.arrViewCart.removeAll()
//                                self.arrViewProductCart.removeAll()
//                                self.arrViewBoxCart.removeAll()
//
//                             self.tblView.reloadData()
//                            self.NoItemView()
//                            })
//                        }
                    }
                        
                    else {
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.arrViewCart.removeAll()
                            self.arrViewProductCart.removeAll()
                            self.arrViewBoxCart.removeAll()
                            self.tblView.reloadData()
                            self.NoItemView()
                        })
                    }
                }
                else
                {
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.activityIndicator.hideActivityIndicator(uiView: self.view)
                        Function.shared.displayErrorMessage(message: SET_ALERT_TEXT(key: "Something_went_wrong" as NSString) as String, duration: 2.0)
                    })
                }
            })
            
        }
        else {
            DispatchQueue.main.async(execute: {() -> Void in
                self.activityIndicator.hideActivityIndicator(uiView: self.view)
            })
            Function.shared.displayErrorMessage(message: SET_ALERT_TEXT(key: "no_connection" as NSString) as String, duration: 2.0)
            
        }
    }
    
    
    func NoItemView() {
        
        DispatchQueue.main.async(execute: {() -> Void in
            Function.shared.displayErrorMessage(message: "\(SET_ALERT_TEXT(key: "you_have_no_item_in_your_cart") as String)", duration: 2.0)
            self.activityIndicator.hideActivityIndicator(uiView: self.view)
            self.lblYouHave.text = "\(SET_ALERT_TEXT(key: "You_have") as String)"
            if self.arrViewProductCart.count > 0{
                
                self.lblItems.text = "\(self.arrViewCart.count)" + " \(SET_ALERT_TEXT(key: "Items") as String)"
                
            }
            else{
                self.lblItems.text = "0 " + " \(SET_ALERT_TEXT(key: "Items") as String)"
            }
            self.btnClearAll.isHidden = true
            self.imgNoData.isHidden = false
        })
    }
    @objc func BtnProductDetailClicked(sender: UIButton) {
        
        let obj = self.arrViewCart[sender.tag]
        
        if obj.type == 2 {
            let boxid = arrViewCart[sender.tag].id
            var dict: [String: Any] = [:]
            let isGuestUser = UserDefaults.standard.bool(forKey: "isGuestLogin")
            if isGuestUser == true {
                dict["user_id"] = UserDefaults.standard.object(forKey: Constant.GlobalConstants.KGuestID) as? String
            }
            else{
                dict["user_id"] = UserDefaults.standard.object(forKey: Constant.GlobalConstants.KUserID) as? Int
            }
            let prodType = arrViewCart[sender.tag].product_type
            if prodType == 5 {
                dict["box_number"] = arrViewCart[sender.tag].box_no
            } else {
                dict["product_id"] = arrViewCart[sender.tag].id
            }
            dict["type"] = arrViewCart[sender.tag].type
            dict["product_type"] = arrViewCart[sender.tag].product_type
            
            viewCartBoxDetailApiCall(params: dict)
        } else {
        
            let storyBoard = UIStoryboard(name: "Ashutosh", bundle: nil)
            guard let AddonsDetailVC = storyBoard.instantiateViewController(withIdentifier: "AddonsDetailVC") as? AddonsDetailVC else { return }
            AddonsDetailVC.providesPresentationContextTransitionStyle = true
            AddonsDetailVC.definesPresentationContext = true
            AddonsDetailVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            AddonsDetailVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            AddonsDetailVC.viewCartModel = self.arrViewCart[sender.tag]
            AddonsDetailVC.isFrom = "cart"
    //        AddonsDetailVC.PageTitle = self.arrViewProductCart[indexPath.row].addon_name
    //        AddonsDetailVC.imageUrl = self.arrAddedOns[indexPath.row].thum_image
    //        AddonsDetailVC.descriptionData = self.arrAddedOns[indexPath.row].addon_description
    //        AddonsDetailVC.price = self.arrAddedOns[indexPath.row].price
    //        self.view
            self.present(AddonsDetailVC, animated: true, completion: nil)
            
    //        let storyboard = UIStoryboard(name: "ProductDetail", bundle: nil)
    //        let controller = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
    //        let productId = arrViewProductCart[sender.tag].id
    //        controller.productId = productId
    //        controller.priceFromBack = "\(arrViewProductCart[sender.tag].price ?? 0)"
    //        self.present(controller, animated: true, completion: nil)
        }
    }
    @objc func BtnBoxDetailClicked( sender: UIButton) {
        print("box detail clicked")
        let boxid = arrViewCart[sender.tag].id
        var dict: [String: Any] = [:]
        let isGuestUser = UserDefaults.standard.bool(forKey: "isGuestLogin")
        if isGuestUser == true {
            dict["user_id"] = UserDefaults.standard.object(forKey: Constant.GlobalConstants.KGuestID) as? String
        }
        else{
            dict["user_id"] = UserDefaults.standard.object(forKey: Constant.GlobalConstants.KUserID) as? Int
        }
        let prodType = arrViewCart[sender.tag].product_type
        if prodType == 5 {
             dict["box_number"] = arrViewCart[sender.tag].box_no
        } else {
            dict["product_id"] = arrViewCart[sender.tag].id
        }
        dict["type"] = arrViewCart[sender.tag].type
        dict["product_type"] = arrViewCart[sender.tag].product_type
       
        viewCartBoxDetailApiCall(params: dict)
    }
    
    func viewCartBoxDetailApiCall(params: [String: Any]) -> Void {
        
        let rechability = Reachability()
        self.activityIndicator.showActivityIndicator(uiView: self.view)
        if(rechability!.connection != .none) {
            APIServices.sharedInstance.universalPostApi(data: params , method: Constant.GlobalConstants.cartItems, complition: { (result, error) in
                
                if error == nil {
                    
                    let status = result?[Constant.GlobalConstants.kStatus] as? Int ?? 0
                    let msg = result![Constant.GlobalConstants.KMessage] as! String
                    
                    if status  == 1 {
                        let response = result!["response"] as? [String: Any] ?? [:]
//                        let tempDict = response["product_list"] as? [String: Any] ?? [:]
                            var tempArray = response["products"] as? [[String: Any]] ?? []
                        if tempArray.count == 0 {
                           tempArray = response["product_list"] as? [[String: Any]] ?? []
                        }
                        var boxName = response["product_name"] as? String ?? ""
                        var price = response["price"] as? Int ?? 0
//                        if price == 0 {
//                            let priceIn = response["price"] as? String ?? "0"
//                            if priceIn.contains(".") {
//                                let floatVal = priceIn.CGFloatValue() ?? 00.00
//                                price = Int(floatVal)
//                            } else {
//                                price = Int(priceIn) ?? 0
//                            }
//                        }
                        let prodType = params["product_type"] as? Int ?? 3
                        if  prodType == 5 {
                            price = tempArray[0]["price"] as? Int ?? 0
                            if price == 0 {
                                let priceIn = tempArray[0]["price"] as? String ?? "0"
                                if priceIn.contains(".") {
                                    let floatVal = priceIn.CGFloatValue() ?? 00.00
                                    price = Int(floatVal)
                                } else {
                                    price = Int(priceIn) ?? 0
                                }
                            }
                            boxName = "Box"
                            tempArray = tempArray[0]["products"] as? [[String: Any]] ?? []
                        } else {
                            price = tempArray[0]["price"] as? Int ?? 0
                            if price == 0 {
                                let priceIn = tempArray[0]["price"] as? String ?? "0"
                                if priceIn.contains(".") {
                                    let floatVal = priceIn.CGFloatValue() ?? 00.00
                                    price = Int(floatVal)
                                } else {
                                    price = Int(priceIn) ?? 0
                                }
                            }
                            boxName = tempArray[0]["product_name"] as? String ?? ""
                            tempArray = tempArray[0]["products"] as? [[String: Any]] ?? []
                        }
                             self.boxDetailModel = tempArray.map{ BoxDetailModel(result: $0)}
                   
                            DispatchQueue.main.async(execute: {() -> Void in
                                
                                let storyBoard = UIStoryboard(name: "Ashutosh", bundle: nil)
                                guard let BoxDetailVC = storyBoard.instantiateViewController(withIdentifier: "BoxDetailVC") as? BoxDetailVC else { return }
                                BoxDetailVC.providesPresentationContextTransitionStyle = true
                                BoxDetailVC.definesPresentationContext = true
                                BoxDetailVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                BoxDetailVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                                BoxDetailVC.boxDetailModel = self.boxDetailModel
                                BoxDetailVC.boxName = boxName
                                print(price)
                                BoxDetailVC.price = "\(price)"
                                self.present(BoxDetailVC, animated: true, completion: nil)
                                self.activityIndicator.hideActivityIndicator(uiView: self.view)
                            })
                    }
                        
                    else {
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.arrViewCart.removeAll()
                        })
                    }
                }
                else
                {
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.activityIndicator.hideActivityIndicator(uiView: self.view)
                        Function.shared.displayErrorMessage(message: SET_ALERT_TEXT(key: "Something_went_wrong" as NSString) as String, duration: 2.0)
                    })
                }
            })
            
        }
        else {
            DispatchQueue.main.async(execute: {() -> Void in
                self.activityIndicator.hideActivityIndicator(uiView: self.view)
            })
            Function.shared.displayErrorMessage(message: SET_ALERT_TEXT(key: "no_connection" as NSString) as String, duration: 2.0)
            
        }
    }
    
    
    func getTotalPrice(){
        var totalprice :Double = 0.0
//        if tag == 0 {
//            for item in self.arrViewProductCart {
//                let price = item.price ?? 0
//                let quantity: Double = Double(item.quantity ?? 0)
//                totalprice += quantity*price
//            }
//        } else {
//            for item in self.arrViewBoxCart {
//                let price = item.price ?? 0
//                let quantity: Double = Double(item.quantity ?? 0)
//                totalprice += quantity*price
//            }
//        }
        for item in self.arrViewCart {
            let price = item.price ?? 0
            let quantity: Double = Double(item.quantity ?? 0)
            totalprice += quantity*price
        }
        print(totalprice)
        let priceCalc = CommonHelper.getPriceAfterConversion(value: Double(totalprice ))
        DispatchQueue.main.async {
            self.btnCart.setTitle("\(SET_ALERT_TEXT(key: "Check_out") as String) · \(priceCalc) \(Defaults().currencyType)", for: .normal)
        }
        
    }
}

