//
//  JTSegmentControl.swift
//  JTSegmentControlDemo
//
//  Created by xia on 16/11/13.
//  Copyright © 2016年 JT. All rights reserved.
//

import UIKit

fileprivate class JTSliderView : UIView {
    
    fileprivate var color : UIColor? {
        didSet{
            self.backgroundColor = color
        }
    }
}

fileprivate enum JTItemViewState : Int {
    case Normal
    case Selected
}

fileprivate class JTItemView : UIView {
    
    fileprivate let titleLabel = UILabel()
    fileprivate lazy var bridgeView : CALayer = {
        let view = CALayer()
        let width = JTSegmentPattern.bridgeWidth
        view.bounds = CGRect(x: 0.0, y: 0.0, width: width, height: width)
        view.backgroundColor = JTSegmentPattern.bridgeColor.cgColor
        view.cornerRadius = view.bounds.size.width * 0.5
        return view
    }()
    
    fileprivate func showBridge(show:Bool){
        self.bridgeView.isHidden = !show
    }
    
    fileprivate var state : JTItemViewState = .Normal {
        didSet{
            updateItemView(state: state)
        }
    }
    
    fileprivate var font : UIFont?{
        didSet{
            if state == .Normal {
                self.titleLabel.font = font
            }
        }
    }
    fileprivate var selectedFont : UIFont?{
        didSet{
            if state == .Selected {
                self.titleLabel.font = selectedFont
            }
        }
    }
    
    fileprivate var text : String?{
        didSet{
            self.titleLabel.text = text
        }
    }
    
    fileprivate var textColor : UIColor?{
        didSet{
            if state == .Normal {
                self.titleLabel.textColor = textColor
            }
        }
    }
    fileprivate var selectedTextColor : UIColor?{
        didSet{
            if state == .Selected {
                self.titleLabel.textColor = selectedTextColor
            }
        }
    }
    
    fileprivate var itemBackgroundColor : UIColor?{
        didSet{
            if state == .Normal {
                self.backgroundColor = itemBackgroundColor
            }
        }
    }
    fileprivate var selectedBackgroundColor : UIColor?{
        didSet{
            if state == .Selected {
                self.backgroundColor = selectedBackgroundColor
            }
        }
    }
    
    fileprivate var textAlignment = NSTextAlignment.center {
        didSet{
            self.titleLabel.textAlignment = textAlignment
        }
    }
    
    private func updateItemView(state:JTItemViewState){
        switch state {
        case .Normal:
            self.titleLabel.font = self.font
            self.titleLabel.textColor = self.textColor
            self.backgroundColor = self.itemBackgroundColor
        case .Selected:
            self.titleLabel.font = selectedFont
            self.titleLabel.textColor = self.selectedTextColor
            self.backgroundColor = self.selectedBackgroundColor
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        titleLabel.frame = bounds
//        titleLabel.center = self.center
        titleLabel.textAlignment = .center
//        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //
        
        addSubview(titleLabel)
        
        bridgeView.isHidden = true
        layer.addSublayer(bridgeView)
        
        layer.masksToBounds = true
    }
    
    fileprivate override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.sizeToFit()
        
        titleLabel.center.x = bounds.size.width * 0.5
        titleLabel.center.y = bounds.size.height * 0.5
        
        let width = bridgeView.bounds.size.width
        let x:CGFloat = titleLabel.frame.maxX - 2.0
        bridgeView.frame = CGRect(x: x, y: bounds.midY - width, width: width, height: width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc public protocol JTSegmentControlDelegate {
    @objc optional func didSelected(segement:JTSegmentControl, index: Int)
}

open class JTSegmentControl: UIControl {
    
    fileprivate struct Constants {
        static let height : CGFloat = 40.0
    }
    
    open weak var delegate : JTSegmentControlDelegate?
    
    open func segementWidth() -> CGFloat {
        return bounds.size.width / (CGFloat)(itemViews.count)
    }
    open var selectedIndex = 0 {
        willSet{
            let originItem = self.itemViews[selectedIndex]
            originItem.state = .Normal
            
            let selectItem = self.itemViews[newValue]
            selectItem.state = .Selected
        }
    }
    
    //MARK - color set
    open var itemTextColor = JTSegmentPattern.itemTextColor{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.textColor = itemTextColor
            }
        }
    }
    
    open var itemSelectedTextColor = JTSegmentPattern.itemSelectedTextColor{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.selectedTextColor = itemSelectedTextColor
            }
        }
    }
    open var itemBackgroundColor = JTSegmentPattern.itemBackgroundColor{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.itemBackgroundColor = itemBackgroundColor
            }
        }
    }
    
    open var itemSelectedBackgroundColor = JTSegmentPattern.itemSelectedBackgroundColor{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.selectedBackgroundColor = itemSelectedBackgroundColor
            }
        }
    }
    
    open var sliderViewColor = JTSegmentPattern.sliderColor{
        didSet{
            self.sliderView.color = sliderViewColor
        }
    }
    
    //MAR - font
    open var font = JTSegmentPattern.textFont{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.font = font
            }
        }
    }
    
    open var selectedFont = JTSegmentPattern.selectedTextFont{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.selectedFont = selectedFont
            }
        }
    }
    
    open var items : [String]?{
        didSet{
            guard items != nil && items!.count > 0 else {
                fatalError("Items cannot be empty")
            }
            
            self.removeAllItemView()
            
            
            for title in items! {
                let view = self.createItemView(title: title)
                self.itemViews.append(view)
                self.contentView.addSubview(view)
            }
            self.selectedIndex = 0
            
            self.contentView.bringSubview(toFront: self.sliderView)
        }
    }
    
    open func showBridge(show:Bool, index:Int){
        
        guard index < itemViews.count && index >= 0 else {
            return
        }
        
        itemViews[index].showBridge(show: show)
    }
    
    fileprivate func removeAllItemView() {
        itemViews.forEach { (label) in
            label.removeFromSuperview()
        }
        itemViews.removeAll()
    }
    
    private func createItemView(title:String) -> JTItemView {
        return createItemView(title: title,
                              font: self.font,
                              selectedFont: self.selectedFont,
                              textColor: self.itemTextColor,
                              selectedTextColor: self.itemSelectedTextColor,
                              backgroundColor: self.itemBackgroundColor,
                              selectedBackgroundColor: self.itemSelectedBackgroundColor
        )
    }
    
    private func createItemView(title:String, font:UIFont, selectedFont:UIFont, textColor:UIColor, selectedTextColor:UIColor, backgroundColor:UIColor, selectedBackgroundColor:UIColor) -> JTItemView {
        let item = JTItemView()
        item.text = title
        item.textColor = textColor
        item.textAlignment = .center
        item.font = font
        item.selectedFont = selectedFont
        
        item.itemBackgroundColor = backgroundColor
        item.selectedTextColor = selectedTextColor
        item.selectedBackgroundColor = selectedBackgroundColor
        
        item.state = .Normal
        return item
    }
    
    fileprivate lazy var scrollView = UIScrollView()
    fileprivate lazy var contentView = UIView()
    fileprivate lazy var sliderView : JTSliderView = JTSliderView()
    fileprivate var itemViews = [JTItemView]()
    
    fileprivate var numberOfSegments : Int {
        return itemViews.count
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    fileprivate func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(sliderView)
        sliderView.color = sliderViewColor
        
        scrollView.frame = bounds
        contentView.frame = scrollView.bounds
        
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addTapGesture()
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSegement(tapGesture:)))
        
        contentView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapSegement(tapGesture:UITapGestureRecognizer) {
        let index = selectedTargetIndex(gesture: tapGesture)
        move(to: index)
    }
    
    open func move(to index:Int){
        move(to: index, animated: true)
    }
    
    open func move(to index:Int, animated:Bool) {
        
        let position = centerX(with: index)
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.sliderView.center.x = position
            })
        }else{
            self.sliderView.center.x = position
        }
        
        delegate?.didSelected?(segement: self, index: index)
        selectedIndex = index
    }
    
    fileprivate func updateDisplay(selectedIndex:Int) {
        
    }
    
    fileprivate func centerX(with index:Int) -> CGFloat {
        return (CGFloat(index) + 0.5)*segementWidth()
    }
    
    private func selectedTargetIndex(gesture: UIGestureRecognizer) -> Int {
        let location = gesture.location(in: contentView)
        var index = Int(location.x / sliderView.bounds.size.width)
        if index < 0 {
            index = 0
        }
        if index > numberOfSegments - 1 {
            index = numberOfSegments - 1
        }
        return index
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        guard itemViews.count > 0 else {
            return
        }
        
        var i=0
        
        var x:CGFloat = 0.0
        let y:CGFloat = 0.0
        let width:CGFloat = bounds.size.width / (CGFloat)(itemViews.count)
        let height:CGFloat = bounds.size.height
        
        sliderView.frame = CGRect(x: width * (CGFloat)(selectedIndex), y: contentView.bounds.size.height - JTSegmentPattern.sliderHeight, width: width, height: JTSegmentPattern.sliderHeight)
        
        for label in itemViews {
            x = width * (CGFloat)(i)
            label.frame = CGRect(x: x, y: y, width: width, height: height)
            i += 1;
        }
    }
}
