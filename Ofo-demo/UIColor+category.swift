//
//  UIColor+category.swift
//  JTReader
//
//  Created by jiangT on 2017/5/3.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}
