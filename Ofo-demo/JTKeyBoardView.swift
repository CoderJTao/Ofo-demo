//
//  JTKeyBoardView.swift
//  Ofo-demo
//
//  Created by jiangT on 2017/7/23.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

protocol JTKeyBoardDelegate : class {
    
    func jtKeyBoard(_ keyBoard : JTKeyBoardView, index : Int, isDelet : Bool, isOk: Bool)
    
}

class JTKeyBoardView: UIView {

    let btnTag = 10
    
    public var numbersArr : [Int]?
    
    let deletBtnTag = 33
    let sureBtnTag = 44
    
    public weak var delegate : JTKeyBoardDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let deletBtn = self.viewWithTag(deletBtnTag) as! UIButton
        deletBtn.addTarget(self, action: #selector(deletCLick(_:)), for: .touchUpInside)
        
        let sureBtn = self.viewWithTag(sureBtnTag) as! UIButton
        sureBtn.addTarget(self, action: #selector(sureBtnCLick(_:)), for: .touchUpInside)
        
        numbersArr = [Int]()
    }
    
    @IBAction func numberClick(_ sender: UIButton) {
        
        numbersArr?.append(sender.tag-btnTag)
        
        if (numbersArr?.count)! > 0 {
            
            let sureBtn = self.viewWithTag(sureBtnTag) as! UIButton
            sureBtn.backgroundColor = UIColor(r: 254, g: 219, b: 0)
        }
        
        delegate?.jtKeyBoard(self, index: sender.tag-btnTag, isDelet: false, isOk: false)
    }
    
    
    @objc func deletCLick(_ sender: UIButton) {
        print("删除")
        if (numbersArr?.count)! > 0 {
            numbersArr?.removeLast()
        }
        
        if (numbersArr?.count)! == 0 {
            
            let sureBtn = self.viewWithTag(sureBtnTag) as! UIButton
            sureBtn.backgroundColor = UIColor(red: 213/255, green: 215/255, blue: 215/255, alpha: 1)
        }
        
        delegate?.jtKeyBoard(self, index: 0, isDelet: true, isOk: false)
    }
    
    @objc func sureBtnCLick(_ sender: UIButton) {
        print("确定")
        
        delegate?.jtKeyBoard(self, index: 0, isDelet: false, isOk: true)

    }
    
    

}
