//
//  VSRenderer.swift
//  vs-metal
//
//  Created by satoshi on 6/21/17.
//  Copyright © 2017 SATOSHI NAKAJIMA. All rights reserved.
//

import Foundation
import MetalKit
import MetalPerformanceShaders

class VSProcessor: NSObject, MTKViewDelegate {
    private let context:VSContext
    private let renderer:VSRenderer?
    private let commandQueue: MTLCommandQueue
    
    private var nodes = [VSNode]()
    
    // width/height are texture's, not view's
    init(context:VSContext, view:MTKView) {
        self.context = context
        commandQueue = context.device.makeCommandQueue()
        renderer = VSRenderer(context:context)

        super.init()
        
        let url = Bundle.main.url(forResource: "test2", withExtension: "js")!
        if let script = VSScript.make(url: url) {
            for item in script.pipeline {
                if let name=item["name"] as? String {
                    if let node = context.makeNode(name: name, params: item["attr"] as? [String:Any]) {
                        nodes.append(node)
                    }
                }
            }
        } else {
            print("VSProcessor: ### ERROR ### failed to load script")
        }
        
        view.delegate = self
    }

    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // nothing to do
    }

    public func draw(in view: MTKView) {
        if context.isEmpty {
            print("VSS:draw texture not updated")
            return
        }
        let cmCompute:MTLCommandBuffer = {
            let commandBuffer = commandQueue.makeCommandBuffer()
            for node in nodes {
                node.encode(commandBuffer:commandBuffer, context:context)
                context.flush()
            }
            return commandBuffer
        }()

        let texture = context.pop()
        let cmRender:MTLCommandBuffer = {
            let commandBuffer = commandQueue.makeCommandBuffer()
            renderer!.encode(commandBuffer:commandBuffer, texture:texture, view:view)
            return commandBuffer
        }()
        
        cmCompute.commit()
        cmRender.commit()
    }
}
