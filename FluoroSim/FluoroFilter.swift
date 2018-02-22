//
//  FluoroFilter.swift
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

class FluoroFilter : NSObject {
    
    // This is the wrapper process method that creates the x-ray effect.
    
    // Invert: inverts colors
    static let invertFilter = CIFilter(name: "CIColorInvert")
    
    // Noir: Applies a preconfigured set of effects that imitate black-and-white photography film with exaggerated contrast.
    static let noirFilter = CIFilter(name: "CIPhotoEffectNoir")

    // Dulls the highlights of an image.
    static let gloomEffectFilter = CIFilter(name: "CIBloom")
    
    static func process(_ img : CIImage) -> UIImage {
        noirFilter!.setValue(img, forKey: kCIInputImageKey)
        gloomEffectFilter!.setValue(noirFilter!.outputImage!, forKey: kCIInputImageKey)
        invertFilter!.setValue(gloomEffectFilter!.outputImage!, forKey: kCIInputImageKey)
        
        return UIImage(ciImage: invertFilter!.outputImage!)
    }
}
