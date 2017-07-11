//
//  TestViewController.swift
//  vs-metal
//
//  Created by SATOSHI NAKAJIMA on 6/20/17.
//  Copyright © 2017 SATOSHI NAKAJIMA. All rights reserved.
//

import UIKit
import MetalKit

class TestViewController: UIViewController {
    var context:VSContext = VSContext(device: MTLCreateSystemDefaultDevice()!)
    var runtime:VSRuntime?
    lazy var session:VSCaptureSession = VSCaptureSession(context: self.context)
    lazy var renderer:VSRenderer = VSRenderer(context:self.context)

    override func viewDidLoad() {
        super.viewDidLoad()

        if let mtkView = self.view as? MTKView {
            mtkView.device = context.device
            mtkView.delegate = self
            mtkView.transform = (session.cameraPosition == .front) ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform.identity
            context.pixelFormat = mtkView.colorPixelFormat
            
            // This is an alternative way to create a script object (Beta)
            let script = VSScript()
                            .gaussian_blur(sigma: 3.0)
                            .halftone(radius: 10.0, scale: 1.0, color1: [0.0, 0.0, 0.0], color2: [1.0, 1.0, 0.0])
                            .anti_alias()
            runtime = script.compile(context: context)

            session.start()
        }
    }
}

extension TestViewController : MTKViewDelegate {
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    public func draw(in view: MTKView) {
        if context.hasUpdate {
            try? runtime?.encode(commandBuffer:context.makeCommandBuffer(), context:context).commit()
            try? renderer.encode(commandBuffer:context.makeCommandBuffer(), view:view).commit()
            context.flush()
        }
    }
}



