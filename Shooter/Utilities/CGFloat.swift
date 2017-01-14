//
//  CGFloat.swift
//  Shooter
//
//  Created by Eric Internicola on 1/13/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit

extension CGFloat {

    static var random: CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }

}
