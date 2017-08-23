//
//  WrongVC.swift
//  Ofo-demo
//
//  Created by jiangT on 2017/7/19.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class WrongVC: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setAnimations()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setAnimations () {
        
        for i in 0..<4 {
            let btn = self.view.viewWithTag(1+i)
            btn?.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        }
        
        let btn1 = self.view.viewWithTag(1)
        beginAnimation(btn: btn1 as! UIButton)
        
        let btn2 = self.view.viewWithTag(2)
        self.perform(#selector(beginAnimation(btn:)), with: btn2, afterDelay: 0.08)
        
        let btn3 = self.view.viewWithTag(3)
        self.perform(#selector(beginAnimation(btn:)), with: btn3, afterDelay: 0.16)
        
        let btn4 = self.view.viewWithTag(4)
        self.perform(#selector(beginAnimation(btn:)), with: btn4, afterDelay: 0.24)
    }
    
    func beginAnimation (btn : UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            btn.transform = .identity
        }, completion: { (Bool) in
            
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeClick(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.view.alpha = 0.001
        }) { (Bool) in
            self.dismiss(animated: false, completion: { 
                
            })
        }
        
    }


}
