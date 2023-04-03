//
//  Nib.swift
//  IMusic
//
//  Created by Никита Егоров on 03.11.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)!.first as! T
    }
}
