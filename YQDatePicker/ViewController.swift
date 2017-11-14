//
//  ViewController.swift
//  YQDatePicker
//
//  Created by 王叶庆 on 2017/11/13.
//  Copyright © 2017年 王叶庆. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let datePicker = YQDatePicker()
        datePicker.show(in: view)
        datePicker.doneClosure = { datePicker in
            print(datePicker.date)
        }
        datePicker.widthPercent = 0.8
        datePicker.hideWhenStep = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

