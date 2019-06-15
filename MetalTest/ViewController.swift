//
//  ViewController.swift
//  MetalTest
//
//  Created by isec on 2019/6/14.
//  Copyright © 2019 huangrui. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {

    let mtkView = MTKView()
    
    var r = 0.0
    var g = 0.0
    var b = 0.0
    var step = 0.01
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mtkView.frame = view.bounds
        view = mtkView
        
        guard let device = MTLCreateSystemDefaultDevice() else { return }
        mtkView.device = device
        mtkView.delegate = self
        mtkView.preferredFramesPerSecond = 60
    }

    func getColor() -> MTLClearColor {
        if r >= 1.0  && g >= 1.0 && b >= 1.0 {
            step = -0.01
        } else if r <= 0 && g <= 0 && b <= 0 {
            step = 0.01
        }
        
        if r < 1.0 {
            r = r + step
        } else if g < 1.0 {
            g = g + step
        } else {
            b = b + step
        }
        return MTLClearColorMake(r, g, b, 1.0)
    }
}

extension ViewController: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        
        view.clearColor = getColor()

        guard let device = view.device else { return }
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        guard let commandQueue = device.makeCommandQueue() else { return }
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        

        commandEncoder.endEncoding()
        guard let drawable = view.currentDrawable else { return }
        commandBuffer.present(drawable)
        commandBuffer.commit()

    }
    
}
