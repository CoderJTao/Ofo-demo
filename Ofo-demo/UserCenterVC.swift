//
//  UserCenterVC.swift
//  Ofo-demo
//
//  Created by jiangT on 2017/7/18.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class UserCenterVC: UIViewController {
    
    let kScreenW : CGFloat = UIScreen.main.bounds.width
    let kScreenH : CGFloat = UIScreen.main.bounds.height

    
    @IBOutlet var topView: UIView!
    @IBOutlet var containView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    func setAnimation () {
        
        topView.transform = CGAffineTransform.init(translationX: 0, y: -150)
        containView.transform = CGAffineTransform.init(translationX: 0, y: kScreenH - 50)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.topView.transform = .identity
            self.containView.transform = .identity
            
        }) { (Bool) in
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeClick(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.topView.transform = CGAffineTransform.init(translationX: 0, y: -150)
            self.containView.transform = CGAffineTransform.init(translationX: 0, y: self.kScreenH - 50)
            
        }) { (Bool) in
            self.dismiss(animated: false) {
                
            }
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
