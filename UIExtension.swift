//
//  ImageExtension.swift
//  mCAS
//
//  Created by Mac on 21/02/19.
//  Copyright © 2019 Nucleus. All rights reserved.
//

import Foundation



// for phone validation
extension String {
    
    var isValidPhone: Bool {
        
        let regularExpressionForPhone = "^[6-9]\\d{9}$"
        let phone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
        return phone.evaluate(with: self)
    }
    
}


// changes for questions view
extension customViewTest: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        answerView.layer.borderColor = Constants.BLUE_COLOR.cgColor
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        answerView.layer.borderColor = UIColor.lightGray.cgColor
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        delegate?.handleTextFieldValue(text: "\(textField.text ?? "")", tag: textField.tag)
    }
}


extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String, color: UIColor) -> NSMutableAttributedString {
        
        let attrs: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String, font: UIFont = CustomFont.getfont_REGULAR(17)) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: font]
        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(normalString)
        
        return self
    }
}

