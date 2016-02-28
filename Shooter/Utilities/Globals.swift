//
//  Globals.swift
//  ChromaCatch
//
//  Created by Eric Internicola on 2/28/16.
//  Copyright © 2016 Eric Internicola. All rights reserved.
//

import UIKit

/**
 Gets you a random number (CGFloat) between 0 and 1.
 - Returns: A pseudo-random number between 0 and 1.
 */
func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
}
