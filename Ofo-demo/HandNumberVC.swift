//
//  HandNumberVC.swift
//  Ofo-demo
//
//  Created by jiangT on 2017/7/21.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import APNumberPad

class HandNumberVC: UIViewController, JTKeyBoardDelegate, UITextFieldDelegate {

    @IBOutlet var contentView: UIView!
    var myNumberView: JTKeyBoardView!
    
    
    @IBOutlet var messageLbl: UILabel!
    
    @IBOutlet var showLbl: UILabel!
    @IBOutlet var numberTF: UITextField!
    @IBOutlet var useBtn: UIButton!
    
    
    @IBOutlet var warnView: UIView!
    @IBOutlet var warnContentView: UIView!
    
    @IBOutlet var dismissWarnViewBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        numberTF.becomeFirstResponder()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        useBtn.clipsToBounds = true
        useBtn.layer.cornerRadius = 18
        
        messageLbl.clipsToBounds = true
        messageLbl.layer.cornerRadius = 10
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(contengViewTap))
        contentView.addGestureRecognizer(tap)
        
        numberTF.clipsToBounds = true
        numberTF.layer.borderWidth = 2
        numberTF.layer.borderColor = UIColor(r: 254, g: 219, b: 0).cgColor
        numberTF.layer.cornerRadius = 18
        
//        myNumberView = JTKeyBoardView.init(frame: CGRect(x: 0, y: 0, width: 375, height: 200))
        let av = Bundle.main.loadNibNamed("JTKeyBoardView", owner: nil, options: nil)?.first as! JTKeyBoardView
        myNumberView = av
        myNumberView.delegate = self
        
        numberTF.inputView = myNumberView
    }

    
    @objc func contengViewTap() {
        
        if numberTF.isFirstResponder {
            numberTF.resignFirstResponder()
            
            UIView.animate(withDuration: 0.15, animations: {
                self.contentView.transform = CGAffineTransform.identity
            })
        }
        
    }
    
// MARK:- 立即用车
    @IBAction func useBikeNowClick(_ sender: UIButton) {
        
        numberTF.resignFirstResponder()
        UIView.animate(withDuration: 0.15, animations: {
            self.contentView.transform = CGAffineTransform.identity
        })
        
        if (self.numberTF.text == "66666666"){
            //正确
            self.dismiss(animated: false, completion: { 
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PasswordShow"), object: nil)
            })
            
            
        } else {
            //错误   弹出提示
            warnView.frame = self.view.bounds
            self.view.addSubview(warnView)
            dismissWarnViewBtn.clipsToBounds = true
            dismissWarnViewBtn.layer.cornerRadius = 5
            dismissWarnViewBtn.layer.borderColor = UIColor(r: 179, g: 179, b: 179).cgColor
            dismissWarnViewBtn.layer.borderWidth = 1
            warnContentView.clipsToBounds = true
            warnContentView.layer.cornerRadius = 12
        }
    }
    
// MARK:- 关闭提示
    @IBAction func dismissWarnViewClick(_ sender: UIButton) {
        
        warnView.removeFromSuperview()
        
        numberTF.becomeFirstResponder()
        
    }
    
    
    
    
// MARK:- JTKeyBoardDelegate
    func jtKeyBoard(_ keyBoard: JTKeyBoardView, index: Int, isDelet: Bool, isOk: Bool) {
        
        if keyBoard.numbersArr?.count == 0 {
            showLbl.text = "输入车牌号，获取解锁码"
        } else if (keyBoard.numbersArr?.count)! < 4 {
            showLbl.text = "车牌号一般为4~8位的数字"
        } else {
            showLbl.text = "温馨提示：若输错车牌号，将无法打开车锁"
        }
        
        if (keyBoard.numbersArr?.count)! > 0 {
            UIView.animate(withDuration: 0.15, animations: {
                self.useBtn.backgroundColor = UIColor(r: 254, g: 219, b: 0)

            })
        } else {
            UIView.animate(withDuration: 0.15, animations: {
                self.useBtn.backgroundColor = UIColor.lightGray

            })
        }
        
        if isDelet {
            //删除一个数字
            var str = numberTF.text

            if str != "" {
                str?.remove(at: (str?.index(before: (str?.endIndex)!))!)
                numberTF.text = str
            }
            
            return
        }
        
        if isOk {
            //输入完成确定
            
            return
        }
        
        //输入了一个数字
        print("输入了一个 " +  String(index))
        
        var str = numberTF.text
        str = str! + String(index)
        
        numberTF.text = str
    }
    
    
    @IBAction func closeClick(_ sender: UIButton) {
        
        self.numberTF.resignFirstResponder()
        
        UIView.animate(withDuration: 0.15, animations: {
            self.contentView.transform = CGAffineTransform.identity
        }) { (Bool) in
            self.dismiss(animated: false) {
                
            }
        }
    }
    
    
// MARK:- UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        UIView.animate(withDuration: 0.3) {
            self.contentView.transform = CGAffineTransform.init(translationX: 0, y: -200)
        }
        
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK:-手电筒
    @IBAction func flashClick(_ sender: UIButton) {
    }
    
// MARK:- 声音
    @IBAction func voiceClick(_ sender: UIButton) {
    }
   
// MARK:- 扫码
    @IBAction func scanClick(_ sender: UIButton) {
//        self.dismiss(animated: false) {
//            
//        }
    }
    
    

}
