//
//  YQDatePicker.swift
//  YQDatePicker
//
//  Created by 王叶庆 on 2017/11/13.
//  Copyright © 2017年 王叶庆. All rights reserved.
//

import UIKit

public typealias YQDatePickerClosure = ((_ datePicker: YQDatePicker) -> Void)

@IBDesignable
public class YQDatePicker: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    lazy private var bgView: UIView = {
//        let effect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
//        let view = UIVisualEffectView(effect: effect)
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.3
        return view
    }()
    
    lazy private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.date = Date()
        return picker
    }()
    
    lazy private var container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    private var cancelItem: UIBarButtonItem?
    
    lazy fileprivate var topTool: UIToolbar = {
        let tool = UIToolbar()
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        let done  = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        space.width = 10
        tool.items = [space, cancel, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), done, space]
        tool.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)
        cancelItem = cancel
        return tool
    }()
    
    lazy private var bottomTool: UIToolbar = {
        let tool = UIToolbar()
        let previous = UIBarButtonItem(title: "前一天", style: .plain, target: self, action: #selector(previousAction))
        let next = UIBarButtonItem(title: "后一天", style: .plain, target: self, action: #selector(nextAction))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        space.width = 10
        tool.items = [space, previous, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), next, space]
        tool.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)
        return tool
    }()
    
    @IBInspectable
    public var date: Date = Date() {
        didSet {
            if datePicker.date.timeIntervalSince1970 != date.timeIntervalSince1970 {
                datePicker.date = date
            }
        }
    }
    @IBInspectable
    public var minimumDate: Date? {
        didSet {
            datePicker.minimumDate = minimumDate
        }
    }
    
    @IBInspectable
    public var maximumDate: Date? {
        didSet {
            datePicker.maximumDate = maximumDate
        }
    }
    
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    @IBInspectable
    public var widthPercent: CGFloat = 0.7 {
        didSet {
            guard let constraint = widthConstraint else {
                return
            }
            removeConstraint(constraint)
            addConstraint(NSLayoutConstraint(item: container, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: widthPercent, constant: 0))
        }
    }
    
    @IBInspectable
    public var heightPercent: CGFloat = 0.48 {
        didSet {
            guard let constraint = heightConstraint else {
                return
            }
            removeConstraint(constraint)
            addConstraint(NSLayoutConstraint(item: container, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: heightPercent, constant: 0))
        }
    }
    
//    public var isHiddenCancel: Bool = false {
//        didSet {
//
//        }
//    }
    public var cancelClosure: YQDatePickerClosure?
    public var doneClosure: YQDatePickerClosure!
    public var hideWhenStep: Bool = true
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor.clear
        let views =  ["bgView" : bgView, "datePicker" : datePicker, "container" : container, "topTool" : topTool, "bottomTool" : bottomTool]

        addSubview(bgView)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bgView]-0-|", options: NSLayoutFormatOptions.alignAllLeading, metrics: nil, views:views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[bgView]-0-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: views))
        
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: container, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: container, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        widthConstraint = NSLayoutConstraint(item: container, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: widthPercent, constant: 0)
        addConstraint(widthConstraint!)
        heightConstraint = NSLayoutConstraint(item: container, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: heightPercent, constant: 0)
        addConstraint(heightConstraint!)

        container.addSubview(topTool)
        topTool.translatesAutoresizingMaskIntoConstraints = false
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[topTool]-0-|", options: .alignAllLeading, metrics: nil, views: views))
        container.addConstraint(NSLayoutConstraint(item: topTool, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1, constant: 0))
        
        container.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[datePicker]-0-|", options: .alignAllLeading, metrics: nil, views: views))
        container.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .top, relatedBy: .equal, toItem: topTool, attribute: .bottom, multiplier: 1, constant: 0))
        
        container.addSubview(bottomTool)
        bottomTool.translatesAutoresizingMaskIntoConstraints = false
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bottomTool]-0-|", options: .alignAllLeading, metrics: nil, views: views))
        container.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .bottom, relatedBy: .equal, toItem: bottomTool, attribute: .top, multiplier: 1, constant: 0))

        container.addConstraint(NSLayoutConstraint(item: bottomTool, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1, constant: 0))
        
    }
    
    public func show(`in` view: UIView? = UIApplication.shared.windows.last) {
        guard let v = view else {
            return
        }
        v.addSubview(self)
        let views = ["datePicker" : self]
        translatesAutoresizingMaskIntoConstraints = false
        v.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[datePicker]-0-|", options: NSLayoutFormatOptions.alignAllLeading, metrics: nil, views:views))
        v.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[datePicker]-0-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: views))
    }
    

    public func hide() {
        cancelClosure = nil
        doneClosure = nil
        removeFromSuperview()
    }
}

//MARK: Action
extension YQDatePicker {
    @objc func cancelAction() {
        defer {
            hide()
        }
        date = datePicker.date
        guard let closure = cancelClosure else {
            return
        }
        closure(self)
    }
    
    @objc func doneAction() {
        defer {
            hide()
        }
        date = datePicker.date
        guard let closure = doneClosure else {
            return
        }
        closure(self)
    }
    
    @objc func previousAction() {
        date = date.addingTimeInterval(-24 * 60 * 60)
        if hideWhenStep {
            guard let closure = doneClosure else {
                return
            }
            closure(self)
             hide()
        }
        
    }
    
    @objc func nextAction() {
        date = date.addingTimeInterval(24 * 60 * 60)
        if hideWhenStep {
            guard let closure = doneClosure else {
                return
            }
            closure(self)
            hide()
        }
    }
}
