//
//  ViewController.swift
//  JTSegmentControlDemo
//
//  Created by xia on 16/11/14.
//  Copyright © 2016年 JT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var segmentControl : JTSegmentControl?
    
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK - init JTSegement
        let frame = CGRect(x: 10.0, y: 200.0, width: self.view.bounds.size.width - 20.0, height: 44.0)
        segmentControl = JTSegmentControl(frame: frame)
        view.addSubview(segmentControl!)
        segmentControl?.delegate = self
        segmentControl?.items = ["first", "second", "third", "fouth"]
        segmentControl?.showBridge(show: true, index: 1)
        
        
        //MARK - test display
        self.label.text = "this is index:" + String(segmentControl!.selectedIndex)
        self.label.sizeToFit()
        label.center.x = self.view.center.x
        label.center.y = self.view.center.y + 50.0
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        view.addSubview(label)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
//        self.segmentControl?.itemTextColor = UIColor.red
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController : JTSegmentControlDelegate {
    
    func didSelected(segement: JTSegmentControl, index: Int) {
        print("current index \(index)")
        self.label.text = "this is index:"+String(index)
        
        segement.showBridge(show: false, index: index)
    }
}

