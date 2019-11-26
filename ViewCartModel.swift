//
//  ViewCartModel.swift
//  BSide
//
//  Created by Ayushi on 09/05/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ViewCartModel: NSObject {
    
    var id: Int?
    var title: String?
    var type: Int?
    var is_giveaway: Int?
    var is_readygift: Int?
    var product_name: String?
    var price: Double?
    var quantity: Int?
    var max_quantity: Int?
    var desc: String?
    var produt_size: String?
    var image: String?
    var country_name: String?
    var currency: String?
    var addedONs = [ViewCartAddedOnsModel]()
    var cart_id: Int?
   
    
    
    
    
    var color                : String?
    var giftwrapUrl          : String?
    var custom_image           : String?
    var is_customized         : Int?
    var box_no               : Int?
//    keys for ready gift set section
    
    var readygiftId          : String?
    var readygiftName           : String?
    var readygiftQuantity           : Int?
    var readygiftPrice           : String?
    var readygiftImage           : String?
    var product_type: Int?
    
    
    func parseCartData(withInfo Info:[String : Any]) -> Void {
        
        
        let arrList = Info["addons"] as? [[String: Any]] ?? []
        self.addedONs = arrList.map{ ViewCartAddedOnsModel(result: $0) }
        
        self.id = Info["id"] as? Int ?? 0
        self.title = Info["title"] as? String ?? ""
        self.type = Info["type"] as? Int ?? 1
        self.is_giveaway = Info["is_giveaway"] as? Int ?? 1
        self.is_readygift = Info["is_readygift"] as? Int ?? 1
        self.product_name = Info["product_name"] as? String ?? ""
        self.product_type = Info["product_type"] as? Int ?? 1
        self.cart_id = Info["cart_id"] as? Int ?? 0
        var price = Info["price"] as? Double ?? 0.0
        if price == 0.0 {
            let priceIn = Info["price"] as? String ?? "0"
            if priceIn.contains(".") {
              let floatVal = priceIn.CGFloatValue() ?? 00.00
                price = Double(floatVal)
            } else {
                 price = Double(priceIn) ?? 0.0
            }
           
        }
        self.price = price
        self.quantity = Info["quantity"] as? Int ?? 0
        self.max_quantity = Info["max_quantity"] as? Int ?? 0
        self.desc = Info["description"] as? String ?? ""
        self.produt_size = Info["produt_size"] as? String ?? ""
        self.image = Info["image"] as? String ?? ""
        self.country_name = Info["country_name"] as? String ?? ""
        self.currency = Info["currency"] as? String ?? ""
        if self.product_type == 5 {
            self.product_name = "Box"
            self.box_no = Info["box_number"] as? Int ?? 0
            self.giftwrapUrl = Info["wrap"] as? String ?? ""
        }
        if Info.keys.count != 0 {
                if (Info[KIsTopCatgories] as? String) != nil{
                    self.color = (Info[KIsTopCatgories] as? String)
                }
                if (Info["is_customized"] as? Int) != nil{
                    self.is_customized = (Info["is_customized"] as? Int)
                }
            }
            
        }
    }

class ViewCartAddedOnsModel: NSObject {
    var id                   : Int?
    var produtName                 : String?
    var desc              : String?
    var thum_image                : String?
    var price                : String?

    
    init(result : [String : Any]) {
        self.id             = result["id"] as? Int ?? 0
        self.produtName       = result["addonName"] as? String ?? ""
        self.desc         = result["desc"] as? String ?? ""
         self.thum_image         = result["thum_image"] as? String ?? ""
         self.price         = result["price"] as? String ?? ""
    }

}
