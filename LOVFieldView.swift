//
//  LOVFieldView.swift
//  mCAS
//
//  Created by iMac on 11/12/19.
//  Copyright © 2019 Nucleus. All rights reserved.
//

import UIKit

protocol SelectedLOVDelegate {    
    func selectedLOVResult(selectedObj: DropDown, btntag: Int)
}

class LOVFieldView: UIView {
    
    @IBOutlet var LOVContainerView: UIView!
    @IBOutlet weak var LOVButton: UIButton!
    @IBOutlet weak var bgview: UIView!
    
    private var delegate: SelectedLOVDelegate?
    private var dropDownList:[DropDown] = []
    
    private var parentKey: String?
    private var masterName: String!
    private var titleStr: String!
    private var allowLOVSetText: Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LOVFieldView", owner: self, options: nil)
        LOVContainerView.fixInView(self)
    }
    
    func setLOVProperties(masterName: String, title: String, tag: Int, autoFillValue: String? = nil, delegate: SelectedLOVDelegate, optionArray: [DropDown]? = nil, allowLOVSetText: Bool = true, parentKey: String? = nil) {
        
        bgview.setMainViewProperties()
        
        self.delegate = delegate
        self.titleStr = title
        self.allowLOVSetText = allowLOVSetText
        self.parentKey = parentKey
        
        LOVButton.tag = tag
        LOVButton.setTitle(self.titleStr, for: .normal)
        LOVButton.titleLabel?.font = CustomFont.shared().GETFONT_REGULAR(19)
        LOVButton.titleLabel?.numberOfLines = 2
        LOVButton.addTarget(self, action: #selector(lovButtonAction(_:)), for: .touchUpInside)
        
        if let optionArray = optionArray {
            self.dropDownList = optionArray
        }
        else {
            self.masterName = masterName
            
            if let value = autoFillValue {
                autoFillLOV(autoFillValue: value)
            }
        }
    }
    
    private func autoFillLOV(autoFillValue: String) {
//        fetchMasterRecords()
        
        if let selectedObj = self.dropDownList.filter({ (item) -> Bool in
            return (item.name == autoFillValue)
        }).first {
            
            selectedLOV(selectedObj: selectedObj, btn: LOVButton)
        }
    }
    
    private func fetchMasterRecords() {
        if self.dropDownList.isEmpty {
            // fetch the dropdownList according to master name
            CoreDataOperations.shared().fetchRecordsForMaster(masterName: self.masterName, parentKey: self.parentKey) { (records) in
                
                if let records = records {
                    self.dropDownList.append(contentsOf: records)
                }
            }
        }
    }
    
    func resetLOVWithParentKey(key: String) {
        self.parentKey = key
        LOVButton.setAttributedTitle(NSAttributedString(), for: .normal)
        self.dropDownList.removeAll()
    }
    
    func setLOVText(selectedObj: DropDown) {
        self.dropDownList = self.dropDownList.map({(item) -> DropDown in
            item.isSelectedFlag = ((selectedObj.code == item.code) && (selectedObj.name == item.name))
            return item
        })
        
        let arr = getStringArrayFromLabel(in: LOVButton.titleLabel!, text: titleStr!)
        print(arr)
        LOVButton.setLOVSelectedText(line1: titleStr!, line2: selectedObj.name)
    }
    
    func getStringArrayFromLabel(in label: UILabel, text: String) -> [String] {

        /// An empty string's array
        var arrLines = [String]()

        guard let font = label.font else {return arrLines}

        let rect = label.frame

        let myFont: CTFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        let attStr = NSMutableAttributedString(string: text)
        attStr.addAttribute(kCTFontAttributeName as NSAttributedString.Key, value: myFont, range: NSRange(location: 0, length: attStr.length))

        let frameSetter: CTFramesetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
        let path: CGMutablePath = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: rect.size.width, height: 100000), transform: .identity)

        let frame: CTFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        guard let lines = CTFrameGetLines(frame) as? [Any] else {return arrLines}

        for line in lines {
            let lineRef = line as! CTLine
            let lineRange: CFRange = CTLineGetStringRange(lineRef)
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            let lineString: String = (text as NSString).substring(with: range)
            arrLines.append(lineString)
        }
        return arrLines
    }
    
    @objc func lovButtonAction(_ sender: UIButton) {
        
//        fetchMasterRecords()
        
        let storyboard = UIStoryboard.init(name: Storyboard.LOV_LIST, bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "LOVListVC") as? LOVListVC {
            vc.setData(dropDownList: self.dropDownList, delegate: self, title: titleStr ?? "", selectedButton: sender)
            AppDelegate.instance.applicationNavController.pushViewController(vc, animated: true)
        }
    }
}

extension LOVFieldView: LOVListDelegate {
    
    func selectedLOV(selectedObj: DropDown, btn: UIButton) {
        
        if self.allowLOVSetText {
            self.setLOVText(selectedObj: selectedObj)
        }
        delegate?.selectedLOVResult(selectedObj: selectedObj, btntag: btn.tag)
    }
    
}
