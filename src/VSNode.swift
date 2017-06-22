//
//  VSNode.swift
//  vs-metal
//
//  Created by SATOSHI NAKAJIMA on 6/22/17.
//  Copyright © 2017 SATOSHI NAKAJIMA. All rights reserved.
//

import Foundation
import Metal

protocol VSNode {
    func encode(commandBuffer:MTLCommandBuffer, context:VSContext)
}
