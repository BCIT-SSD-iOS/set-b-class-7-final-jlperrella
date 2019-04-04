//
//  ViewController.swift
//  SmartCam
//
//  Created by jp on 2019-04-04.
//  Copyright © 2019 Jordan Perrella. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    //start camera here
    
    let captureSession = AVCaptureSession()
    
    //Crops camera viewport to "photo" size
    //captureSession.sessionPreset = .photo
    
    guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
    
    guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
    captureSession.addInput(input)
    
    captureSession.startRunning()
    
    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    view.layer.addSublayer(previewLayer)
    previewLayer.frame = view.frame
    
    
    
   
    
    
  }


}

