//
//  TutorialViewController.swift
//  GOT
//
//  Created by Kenneth Okereke on 4/1/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit
import PaperOnboarding

class TutorialViewController: UIViewController,  PaperOnboardingDataSource, PaperOnboardingDelegate  {
    
    @IBOutlet weak var onboardingview: OnboardingView!
    
    @IBOutlet weak var getstarted: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingview.dataSource = self
        onboardingview.delegate = self
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let backgroundColorone = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
        let backgroundColortwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
        let backgroundColorthree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descriptionfont = UIFont(name: "AvenirNext-Regular", size: 15)!
        
        return [("Map", "Local Yardsale", "We want to make our users feel comfortable when giving away their items through our app why not have it locally", "", backgroundColortwo, UIColor.white, UIColor.white, titleFont, descriptionfont),
                
                ("Video", "Upload Video", "Enables sellers to sell their items by recording or uploading a video of their choice", "", backgroundColorone, UIColor.white, UIColor.white, titleFont, descriptionfont),
                
                ("Bubble", "Messages", "Send a message to a buyer of your liking", "", backgroundColorthree, UIColor.white, UIColor.white, titleFont, descriptionfont)][index]
        
        
        
        
        
        
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2 {
            UIView.animate(withDuration: 0.4, animations: {
                self.getstarted.alpha = 1
            })
        }
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        
        
        
        if index == 1 {
            
            if self.getstarted.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getstarted.alpha = 0
                })
            }
            
            
            
        }
}
}
