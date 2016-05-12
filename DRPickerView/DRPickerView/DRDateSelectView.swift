//
//  DRDateSelectView.swift
//  DRPickerView
//
//  Created by dengrui on 16/4/19.
//  Copyright © 2016年 dengrui. All rights reserved.
//

import UIKit

private let kItemWith = UIScreen.mainScreen().bounds.width / 6
private let kItemHeight:CGFloat = 40
private let kLabelViewCell = "kLabelViewCell"

enum DateStyle:String {
    case Month = "Month"
    case Year = "Year"
}

class DRDateSelectView: UIView {

    @IBOutlet weak var yearBtn: UIButton!
    
    @IBOutlet weak var monthBtn: UIButton!

    var currentMonthCell:LabelCell?
    /// 计算年、月的日期索引
    var currentDateIndex:Int? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    var selectItemIndex:((index:Int)->())?
    
    var selectYearItemIndex:((index:Int)->())?
    
    var selectYearOrMonthButton:((style: DateStyle) -> ())?
    
    var dateArr = [String]()
    
    var style:DateStyle = .Month {
        didSet {
            switch style {
            case .Month:
                dateArr.removeAll()
                for i in 1...12 {
                    dateArr.append(String(i))
                }
                collectionView.reloadData()
            case .Year:
                dateArr.removeAll()
                let date = NSDate()
                let fmt_y = NSDateFormatter()
                fmt_y.dateFormat = "yyyy"
                let year = Int(fmt_y.stringFromDate(date))
                for i in year! - preYearCount...year! + sufYearCount {
                    dateArr.append(String(i))
                }
                collectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionViewHCons: NSLayoutConstraint!
    
    @IBAction func clickBtns(sender: AnyObject) {
        switch sender.tag {
        case 1:
            self.style = .Month
            monthBtn.selected = true
            yearBtn.selected = false
            
        case 2:
            self.style = .Year
            yearBtn.selected = true
            monthBtn.selected = false

        default:break
        }
        if let selectYearOrMonth = selectYearOrMonthButton {
            selectYearOrMonth(style: self.style)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewHCons.constant = 160
        // 设置 layout 的大小
        layout.itemSize = CGSize(width: kItemWith, height: kItemHeight)
        self.layoutIfNeeded()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(LabelCell.self, forCellWithReuseIdentifier: kLabelViewCell)
    }
    
    class func dateSelectView()->DRDateSelectView {
        return NSBundle.mainBundle().loadNibNamed("DRDateSelectView", owner: nil, options: nil).first as! DRDateSelectView
    }
}

extension DRDateSelectView: UICollectionViewDataSource,UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kLabelViewCell, forIndexPath: indexPath) as! LabelCell

        cell.name = dateArr[indexPath.row]
        cell.nameLabel.textColor = UIColor.whiteColor()
        if currentDateIndex == indexPath.row {
            cell.nameLabel.textColor = UIColor.yellowColor()
        }
        
        return cell
    }
    
    //代理方法－点击年月cell的item
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let currentCell = collectionView.cellForItemAtIndexPath(indexPath) as! LabelCell
        currentCell.nameLabel.textColor = UIColor.yellowColor()
        if style == .Month {

            if let selectItemIndex = selectItemIndex {
                selectItemIndex(index: indexPath.row)
            }
        } else {

            if let selectYearItemIndex = selectYearItemIndex {
                
                selectYearItemIndex(index:indexPath.row)
            }
        }
    }
}

class LabelCell :UICollectionViewCell {
    
    var name:String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var nameLabel:UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFontOfSize(12)
        nameLabel.textAlignment = .Center
        nameLabel.textColor = UIColor.whiteColor()
        return nameLabel
    }()
    
}
