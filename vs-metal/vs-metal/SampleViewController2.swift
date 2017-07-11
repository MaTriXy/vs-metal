//
//  SampleViewController1.swift
//  vs-metal
//
//  Created by SATOSHI NAKAJIMA on 6/20/17.
//  Copyright © 2017 SATOSHI NAKAJIMA. All rights reserved.
//

import UIKit
import MetalKit

class SampleViewController2: UIViewController {
    var context:VSContext = VSContext(device: MTLCreateSystemDefaultDevice()!)
    var runtime:VSRuntime?
    lazy var session:VSCaptureSession = VSCaptureSession(context: self.context)
    lazy var renderer:VSRenderer = VSRenderer(context:self.context)

    override func viewDidLoad() {
        super.viewDidLoad()

        if let mtkView = self.view as? MTKView {
            mtkView.device = context.device
            mtkView.delegate = self
            context.pixelFormat = mtkView.colorPixelFormat
            session.cameraPosition = .back
            
            // This is an alternative way to create a script object (Beta)
            let script = VSScript()
                .gaussian_blur(sigma: 2.0)
                .fork()
                .gaussian_blur(sigma: 2.0)
                .toone()
                .swap()
                .sobel()
                .canny_edge(threshhold: 0.19, thin: 0.5)
                .anti_alias()
                .alpha(ratio: 1.0)
            runtime = script.compile(context: context)

            session.start()
        }
    }
}

extension SampleViewController2 : MTKViewDelegate {
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    public func draw(in view: MTKView) {
        if context.hasUpdate {
            try? runtime?.encode(commandBuffer:context.makeCommandBuffer(), context:context).commit()
            try? renderer.encode(commandBuffer:context.makeCommandBuffer(), view:view).commit()
            context.flush()
        }
    }
}



