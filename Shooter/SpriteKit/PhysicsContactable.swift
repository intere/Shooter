//
//  PhysicsContactable.swift
//  Shooter
//
//  Created by Eric Internicola on 1/13/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import SpriteKit


/// Delineates that the implementer of this protocol will handle a physics contact with another node type
protocol PhysicsContactable {

    /// Handles contact with another node type.
    ///
    /// - Parameter node: The node to handle contact with
    func handleContactWith(node: SKNode)
}
