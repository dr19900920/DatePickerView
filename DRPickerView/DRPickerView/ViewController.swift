//
//  ViewController.swift
//  DRPickerView
//
//  Created by dengrui on 16/4/19.
//  Copyright © 2016年 dengrui. All rights reserved.
//

import UIKit

let preYearCount: Int = 5
let sufYearCount: Int = 6

class ViewController: UIViewController,DRPickerViewDataSource, DRPickerViewDelegate {
    
    @IBOutlet weak var pickerView: DRPickerView!
    var bottomBtn:UIButton?
    var monthArr = [String]()
    var yearArr = [String]()
    var dataSource : [String]?
    var currentDateIndex : Int?
    var currentYearIndex:Int?
    var currentMonthIndex:Int?
    
    
    var leftCell:UICollectionViewCell?
    var rightCell:UICollectionViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = NSDate()
        let fmt_y = NSDateFormatter()
        fmt_y.dateFormat = "yyyy"
        let year = Int(fmt_y.stringFromDate(date))
        
        let fmt_m = NSDateFormatter()
        fmt_m.dateFormat = "MM"
        let month = Int(fmt_m.stringFromDate(date))
        
        currentYearIndex = preYearCount
        
        
        for i in year! - preYearCount...year! + sufYearCount {
            
            yearArr.append("\(i)年")
            
            for j in 1...12 {
                monthArr.append("\(i)年\(j)月")
                if j == month {
                    currentMonthIndex = currentYearIndex! * 12 + j - 1
                }
            }
        }
        
        self.dataSource = monthArr
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.pickerView.font = UIFont(name: "HelveticaNeue-Light", size: 13)!
        self.pickerView.highlightedFont = UIFont(name: "HelveticaNeue", size: 13)!
        self.pickerView.pickerViewStyle = .Wheel
        self.pickerView.backgroundColor = UIColor.blackColor()
        
        self.pickerView.selectItem(currentMonthIndex!)
        self.pickerView.reloadData()
        let bottomBtn = UIButton(frame: CGRect(x: UIScreen.mainScreen().bounds.width / 2 - 15, y: 64 + 45 - 15, width: 30, height: 15))
        bottomBtn.setImage(UIImage(named: "展开1"), forState: .Normal)
        bottomBtn.addTarget(self, action: "showDate", forControlEvents: .TouchUpInside)
        self.bottomBtn = bottomBtn
        view.insertSubview(bottomBtn, aboveSubview: self.pickerView)
        view.addSubview(dismissBtn)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func showDate() {
        if dismissBtn.hidden == false {
            dismissBtn.hidden = true
            
            bottomBtn?.transform = CGAffineTransformRotate((bottomBtn?.transform)!, CGFloat(M_PI))
            
            self.pickerView.collectionView.scrollEnabled = true
            self.pickerView.collectionView.userInteractionEnabled = true
            
        } else {
            dismissBtn.hidden = false
            bottomBtn?.transform = CGAffineTransformRotate((bottomBtn?.transform)!, CGFloat(M_PI))
            self.pickerView.collectionView.scrollEnabled = false
            self.pickerView.collectionView.userInteractionEnabled = false
            
            if dateSelectView.style == .Month {
                
                let monthString = (self.monthArr[currentMonthIndex!] as NSString).substringFromIndex(5)
                let monthIndex = monthString.stringByReplacingOccurrencesOfString("月", withString: "")
                dateSelectView.currentDateIndex = Int(monthIndex)! - 1
                
            } else{
                dateSelectView.currentDateIndex = currentYearIndex
            }
            
            dateSelectView.selectYearOrMonthButton = {[weak self](style) in
                if style == .Month {
                    
                    let monthString = (self!.monthArr[self!.currentMonthIndex!] as NSString).substringFromIndex(5)
                    let monthIndex = monthString.stringByReplacingOccurrencesOfString("月", withString: "")
                    self!.dateSelectView.currentDateIndex = Int(monthIndex)! - 1
                } else{
                    
                    self!.dateSelectView.currentDateIndex = self!.currentYearIndex
                }
            }
        }
        
    }
    
    
    // MARK: - DRPickerViewDataSource
    
    func numberOfItemsInPickerView(pickerView: DRPickerView) -> Int {
        
        return self.dataSource!.count ?? 0
    }
    
    /*
    
    Image Support
    -------------
    Please comment '-pickerView:titleForItem:' entirely and
    uncomment '-pickerView:imageForItem:' to see how it works.
    
    */
    func pickerView(pickerView: DRPickerView, titleForItem item: Int) -> String {
        return self.dataSource?[item] ?? ""
    }
    
    // MARK: - DRPickerViewDelegate
    
    func pickerView(pickerView: DRPickerView, didSelectItem item: Int) {
        //年
        if self.dataSource?.count == 12 {
            currentYearIndex = item
            
        }
            //年月
        else {
            currentMonthIndex = item
        }
        
    }
    
    func pickerView(pickerView: DRPickerView, configureLabel label: UILabel, forItem item: Int) {
        label.textColor = UIColor.lightGrayColor()
        label.highlightedTextColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.blackColor()
    }
    
    func dismissClick() {
        dismissBtn.hidden = true
        dateSelectView.currentMonthCell?.nameLabel.textColor = UIColor.whiteColor()
        bottomBtn?.transform = CGAffineTransformRotate((bottomBtn?.transform)!, CGFloat(M_PI))
        self.pickerView.collectionView.scrollEnabled = true
        self.pickerView.collectionView.userInteractionEnabled = true
    }
    
    private lazy var dateSelectView:DRDateSelectView = {
        let v = DRDateSelectView.dateSelectView()
        v.style = .Month
        v.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 205)
        v.selectItemIndex = {[weak self](index)->()in
            self?.dataSource = self?.monthArr
            let itemIndex = (self?.currentMonthIndex)! / 12 * 12
            self?.pickerView.selectItem(index + itemIndex)
            
            self?.pickerView.reloadData()
            self?.dismissBtn.hidden = true
            self?.bottomBtn?.transform = CGAffineTransformRotate((self?.bottomBtn?.transform)!, CGFloat(M_PI))
            self?.pickerView.collectionView.scrollEnabled = true
            self?.pickerView.collectionView.userInteractionEnabled = true
        }
        v.selectYearItemIndex = {[weak self](index)->()in
            self?.dataSource = self?.yearArr
            self?.pickerView.selectItem(index)
            self?.currentMonthIndex = index * 12
            
            self?.pickerView.reloadData()
            self?.dismissBtn.hidden = true
            self?.bottomBtn?.transform = CGAffineTransformRotate((self?.bottomBtn?.transform)!, CGFloat(M_PI))
            self?.pickerView.collectionView.scrollEnabled = true
            self?.pickerView.collectionView.userInteractionEnabled = true
        }
        
        return v
    }()
    
    private lazy var dismissBtn:UIButton = {
        let b = UIButton()
        b.hidden = true
        b.frame = CGRect(x: 0, y: 109, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - 109)
        b.addTarget(self, action: "dismissClick", forControlEvents: .TouchUpInside)
        b.addSubview(self.dateSelectView)
        return b
    }()
}

