//
//  ViewController.swift
//  FluoroSim
//
//  Code developed by George Marzloff on 2/21/18 with the help of the these sources:
//
// Adapted from these tutorials
// https://www.raywenderlich.com/76285/beginning-core-image-swift
// https://stackoverflow.com/questions/32378666/how-to-apply-filter-to-video-real-time-using-swift

// And this repository
// https://github.com/illescasDaniel/LiveCameraFiltering

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var camView : UIImageView?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var footOverlay : CALayer!
    var isPaused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video), let input = try? AVCaptureDeviceInput(device:captureDevice) else {
            print("Can't access the camera!")
            return
        }
        if captureSession.canAddInput(input){
            captureSession.addInput(input)
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        if captureSession.canAddOutput(videoOutput){
            captureSession.addOutput(videoOutput)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        camView?.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }

    @IBAction func togglePause(_sender: Any){
        self.isPaused = self.isPaused ? false : true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = .portrait
        DispatchQueue.main.async {
            if(!self.isPaused){
                guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
                let cameraImage = CIImage(cvPixelBuffer: pixelBuffer)
                self.camView?.image = FluoroFilter.process(cameraImage)
            }
        }
    }
    
}

