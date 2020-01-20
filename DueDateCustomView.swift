//
//  DateRangeFilterView.swift
//  mCAS
//
//  Created by iMac on 16/12/19.
//  Copyright © 2019 Nucleus. All rights reserved.
//

import UIKit

protocol DueDateCustomViewDeleagte {
    func selectedDueDate(day: String)
}

class DueDateCustomView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet var dueDateView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var delegate: DueDateCustomViewDeleagte?
    
    var selectedDay: String?
    var listArray: [String] = []
    func setProperties(width: CGFloat, height: CGFloat, delegate: DueDateCustomViewDeleagte) {
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        // Do any additional setup after loading the view.
        
        dueDateView.layer.cornerRadius = 8

        titleLabel.font = CustomFont.shared().GETFONT_REGULAR(19)
        
        closeButton.titleLabel?.font = CustomFont.shared().GETFONT_MEDIUM(25)
        self.delegate = delegate
        
        collectionView.register(calendarCollectionCell.self, forCellWithReuseIdentifier: calendarCollectionCell.identifier)
        
        let noOfDays:Int = Date().getDaysInMonth()
        for i in 1...noOfDays {
            if i != 5 && i != 10 && i != 15 {
                listArray.append("\(i)")
            }
        }
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.alpha = 0
    }
    

}

extension DueDateCustomView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calendarCollectionCell.identifier, for: indexPath) as! calendarCollectionCell
        
        cell.backgroundColor = listArray[indexPath.row] == selectedDay ? Constants.BLUE_COLOR : .clear
        cell.textLabel.textColor = listArray[indexPath.row] == selectedDay ? .white : .black
        cell.textLabel.text = listArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? calendarCollectionCell {
            selectedDay = cell.textLabel.text
            collectionView.reloadData()
            delegate?.selectedDueDate(day: selectedDay!)
            closeButton.sendActions(for: .touchUpInside)
        }
        
        
    }
}


class calendarCollectionCell: UICollectionViewCell {

    static var identifier: String = "Cell"

    weak var textLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        let textLabel = UILabel(frame: .zero)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            self.contentView.centerXAnchor.constraint(equalTo: textLabel.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
        ])
        self.textLabel = textLabel
        self.textLabel.font = CustomFont.shared().GETFONT_REGULAR(19)
        self.reset()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }

    func reset() {
        self.textLabel.textAlignment = .center
    }
}
