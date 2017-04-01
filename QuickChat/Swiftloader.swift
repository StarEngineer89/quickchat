//
//  Swiftloader.swift
//  GOT
//
//  Created by Kenneth Okereke on 3/31/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import CoreGraphics

let loaderSpinnerMarginSide : CGFloat = 35.0
let loaderSpinnerMarginTop : CGFloat = 20.0
let loaderTitleMargin : CGFloat = 5.0

public class SwiftLoader: UIView {
    
    private var coverView : UIView?
    private var titleLabel : UILabel?
    private var loadingView : SwiftLoadingView?
    private var animated : Bool?
    private var canUpdated = false
    private var title: String?
    private var isDisplayed: Bool = false
    
    private var config : Config = Config() {
        didSet {
            self.loadingView?.config = config
        }
    }
    
    override public var frame : CGRect {
        didSet {
            self.update()
        }
    }
    
    class var sharedInstance: SwiftLoader {
        struct Singleton {
            static let instance = SwiftLoader(frame: CGRect(x: 0, y: 0, width: Config().size, height: Config().size))
        }
        return Singleton.instance
    }
    
    public class func show(animated: Bool) {
        self.show(title: nil, animated: animated)
    }
    
    public class func show(title: String?, animated : Bool) {
        DispatchQueue.main.async {
            let currentWindow : UIWindow = UIApplication.shared.keyWindow!
            
            let loader = SwiftLoader.sharedInstance
            loader.canUpdated = true
            loader.animated = animated
            loader.title = title
            loader.update()
            loader.isDisplayed = true
            
            let height : CGFloat = UIScreen.main.bounds.size.height
            let width : CGFloat = UIScreen.main.bounds.size.width
            let center : CGPoint = CGPoint(x: width / 2.0, y: height / 2.0)
            loader.center = center
            
            loader.coverView = UIView(frame: currentWindow.bounds)
            loader.coverView?.backgroundColor = UIColor.clear
            
            if (loader.superview == nil) {
                currentWindow.addSubview(loader.coverView!)
                currentWindow.addSubview(loader)
                loader.start()
            } else {
                loader.coverView?.removeFromSuperview()
            }
        }
    }
    
    public class func hide() {
        DispatchQueue.main.async {
            let loader = SwiftLoader.sharedInstance
            
            if loader.isDisplayed == false {
                return
            }
            
            loader.stop()
            loader.isDisplayed = false
        }
    }
    
    public class func setConfig(config : Config) {
        let loader = SwiftLoader.sharedInstance
        loader.config = config
        loader.frame = CGRect(x: 0, y: 0,
                              width: loader.config.size, height: loader.config.size)
    }
    
    /**
     Private methods
     */
    
    private func setup() {
        self.alpha = 0
        self.update()
    }
    
    private func start() {
        self.loadingView?.start()
        
        if (self.animated!) {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.alpha = 1
            }, completion: { (finished) -> Void in
                
            });
        } else {
            self.alpha = 1
        }
    }
    
    private func stop() {
        
        if (self.animated!) {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.alpha = 0
            }, completion: { (finished) -> Void in
                self.removeFromSuperview()
                self.coverView?.removeFromSuperview()
                self.loadingView?.stop()
            });
        } else {
            self.alpha = 0
            self.removeFromSuperview()
            self.coverView?.removeFromSuperview()
            self.loadingView?.stop()
        }
    }
    
    private func update() {
        self.backgroundColor = self.config.backgroundColor
        self.layer.cornerRadius = self.config.cornerRadius
        let loadingViewSize = self.frame.size.width - (loaderSpinnerMarginSide * 2)
        
        if (self.loadingView == nil) {
            self.loadingView = SwiftLoadingView(frame: self.frameForSpinner())
            self.addSubview(self.loadingView!)
        } else {
            self.loadingView?.frame = self.frameForSpinner()
        }
        
        let frameRect = CGRect(x: loaderTitleMargin,
                               y: loaderSpinnerMarginTop + loadingViewSize,
                               width: self.frame.width - loaderTitleMargin*2,
                               height: 42)
        if (self.titleLabel == nil) {
            self.titleLabel = UILabel(frame: frameRect)
            self.addSubview(self.titleLabel!)
            self.titleLabel?.numberOfLines = 1
            self.titleLabel?.textAlignment = .center
            self.titleLabel?.adjustsFontSizeToFitWidth = true
        } else {
            self.titleLabel?.frame = frameRect
        }
        
        self.titleLabel?.font = self.config.titleTextFont
        self.titleLabel?.textColor = self.config.titleTextColor
        self.titleLabel?.text = self.title
        
        self.titleLabel?.isHidden = self.title == nil
    }
    
    func frameForSpinner() -> CGRect {
        let loadingViewSize = self.frame.size.width - (loaderSpinnerMarginSide * 2)
        
        if (self.title == nil) {
            let yOffset = (self.frame.size.height - loadingViewSize) / 2
            return CGRect(x: loaderSpinnerMarginSide, y: yOffset, width: loadingViewSize, height: loadingViewSize)
        }
        return CGRect(x: loaderSpinnerMarginSide, y: loaderSpinnerMarginTop, width: loadingViewSize, height: loadingViewSize)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     *  Loader View
     */
    class SwiftLoadingView : UIView {
        
        private var lineWidth : Float?
        private var lineTintColor : UIColor?
        private var backgroundLayer : CAShapeLayer?
        private var isSpinning : Bool?
        
        var config : Config = Config() {
            didSet {
                self.update()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        /**
         Setup loading view
         */
        
        private func setup() {
            self.backgroundColor = UIColor.clear
            self.lineWidth = fmaxf(Float(self.frame.size.width) * 0.025, 1)
            
            self.backgroundLayer = CAShapeLayer()
            self.backgroundLayer?.strokeColor = self.config.spinnerColor.cgColor
            self.backgroundLayer?.fillColor = self.backgroundColor?.cgColor
            self.backgroundLayer?.lineCap = kCALineCapRound
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
            self.layer.addSublayer(self.backgroundLayer!)
        }
        
        private func update() {
            self.lineWidth = self.config.spinnerLineWidth
            
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
            self.backgroundLayer?.strokeColor = self.config.spinnerColor.cgColor
        }
        
        /**
         Draw Circle
         */
        
        override func draw(_ rect: CGRect) {
            self.backgroundLayer?.frame = self.bounds
        }
        
        private func drawBackgroundCircle(partial : Bool) {
            let startAngle : CGFloat = CGFloat(M_PI) / CGFloat(2.0)
            var endAngle : CGFloat = (2.0 * CGFloat(M_PI)) + startAngle
            
            let center : CGPoint = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
            let radius : CGFloat = (CGFloat(self.bounds.size.width) - CGFloat(self.lineWidth!)) / CGFloat(2.0)
            
            let processBackgroundPath : UIBezierPath = UIBezierPath()
            processBackgroundPath.lineWidth = CGFloat(self.lineWidth!)
            
            if (partial) {
                endAngle = (1.8 * CGFloat(M_PI)) + startAngle
            }
            
            processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            self.backgroundLayer?.path = processBackgroundPath.cgPath
        }
        
        /**
         Start and stop spinning
         */
        
        func start() {
            self.isSpinning? = true
            self.drawBackgroundCircle(partial: true)
            
            let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = NSNumber(value: M_PI * 2.0)
            rotationAnimation.duration = 1;
            rotationAnimation.isCumulative = true;
            rotationAnimation.repeatCount = HUGE;
            self.backgroundLayer?.add(rotationAnimation, forKey: "rotationAnimation")
        }
        
        func stop() {
            self.drawBackgroundCircle(partial: false)
            
            self.backgroundLayer?.removeAllAnimations()
            self.isSpinning? = false
        }
    }
    
    
    /**
     * Loader config
     */
    public struct Config {
        
        /**
         *  Size of loader
         */
        public var size : CGFloat = 100.0
        
        /**
         *  Color of spinner view
         */
        public var spinnerColor = UIColor.white
        
        /**
         *  S
         */
        public var spinnerLineWidth :Float = 1.0
        
        /**
         *  Color of title text
         */
        public var titleTextColor = UIColor.white
        
        /**
         *  Font for title text in loader
         */
        public var titleTextFont : UIFont = UIFont(name: "Avenir", size: 17)!
        
        /**
         *  Background color for loader
         */
        public var backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        
        /**
         *  Corner radius for loader
         */
        public var cornerRadius : CGFloat = 10.0
        
        public init() {}
        
    }
}

