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

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

  @IBOutlet weak var objectLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //start camera
    let captureSession = AVCaptureSession()
    
    //Crops camera viewport to "photo" size
    captureSession.sessionPreset = .photo
    
    guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
    guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
   
    captureSession.addInput(input)
    captureSession.startRunning()
    
    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    view.layer.addSublayer(previewLayer)
    previewLayer.frame = view.frame
  
    let dataOutput = AVCaptureVideoDataOutput()
    dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label:"videoQueue"))
    captureSession.addOutput(dataOutput)
    
  }
  
  //captures camera output every frame
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    
    //print ("Camera Captured Frame", Date())
  
    guard let pixelBuffer: CVPixelBuffer =
      CMSampleBufferGetImageBuffer(sampleBuffer) else {return}

    guard let model = try? VNCoreMLModel(for: Resnet50().model) else {return}
    let request = VNCoreMLRequest(model: model){
      (finishedReq, err) in
      
      // check error
     // print (finishedReq.results)
      
      guard let result = finishedReq.results as? [VNClassificationObservation] else {return}
      guard let firstObservation = result.first else { return }
      print(firstObservation.identifier, firstObservation.confidence)
      
      DispatchQueue.main.async {
        self.objectLabel.text = "\(firstObservation.identifier) %\((firstObservation.confidence * 100).rounded())"
      }
      
    }

    try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
  }
  
}

