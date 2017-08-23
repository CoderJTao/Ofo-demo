//
//  JTScanVC.swift
//  Ofo-demo
//
//  Created by jiangT on 2017/7/21.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import swiftScan

class JTScanVC: LBXScanViewController {

    var isFlashOn = false
    
    
    @IBOutlet var logoImg: UIImageView!
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet var functionView: UIView!
    
    @IBOutlet var flashBtn: UIButton!
    
    @IBOutlet var handBtn: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        
        self.view.transform = CGAffineTransform.init(translationX: 0, y: UIScreen.main.bounds.size.height-300)
        UIView.animate(withDuration: 0.2) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.bringSubview(toFront: logoImg)
        view.bringSubview(toFront: closeBtn)
        view.bringSubview(toFront: functionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        scanStyle?.anmiationStyle = .netGrid
        scanStyle?.animationImage = UIImage(named: "CodeScan.bundle/qrcode_Scan_weixin_Line")
        scanStyle?.colorRetangleLine = UIColor(r: 254, g: 219, b: 0)
        scanStyle?.photoframeAngleStyle = .inner
        scanStyle?.colorAngle = UIColor(r: 254, g: 219, b: 0)
        scanStyle?.photoframeLineW = 8
        scanStyle?.photoframeAngleW = 45
        scanStyle?.photoframeAngleH = 45
        
        handBtn.clipsToBounds = true
        handBtn.layer.cornerRadius = 25
        flashBtn.clipsToBounds = true
        flashBtn.layer.cornerRadius = 25
        
    }

    
    @IBAction func handBtnClick(_ sender: UIButton) {
        print("手动输入车牌")
        
        self.dismiss(animated: false) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HandNumber"), object: nil)
        }
    }
    
    
    
    @IBAction func flashBtnClick(_ sender: UIButton) {
        print("打开手电")
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            isFlashOn = true
            
        } else {
            
            isFlashOn = false
            
        }
        
    }
    
    
    @IBAction func closeClick(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.15, animations: {
            self.view.transform = CGAffineTransform.init(translationX: 0, y: UIScreen.main.bounds.size.height-300)
            self.view.alpha = 0.05
        }) { (Bool) in
            
            self.dismiss(animated: false) {
                
            }
            
        }
    }
    
    
    override func handleCodeResult(_ arrayResult: [LBXScanResult]) {
        
        
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
