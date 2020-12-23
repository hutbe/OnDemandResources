//
//  ResourceManager.swift
//  On-Demand Resources
//
//  Created by Hut on 2020/12/18.
//  Copyright © 2020 Stoull.cn, All rights reserved.
//

import Foundation

#warning("Not finish yet, please check under comment for more information")
/*
 
 Accessing and Downloading On-Demand Resources from AppStore
 
 https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/On_Demand_Resources_Guide/Managing.html#//apple_ref/doc/uid/TP40015083-CH4-SW1
 https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/On_Demand_Resources_Guide/Managing.html#//apple_ref/doc/uid/TP40015083-CH4-SW1
 */


class ResourceManager: NSObject {
    static let shared = ResourceManager()
    var imageRequest: NSBundleResourceRequest!
    
    func requestImageWith(tags: Set<String>,
                          onSuccess: @escaping () -> Void,
                          onFailure: @escaping (Error) -> Void) -> NSBundleResourceRequest {
        imageRequest = NSBundleResourceRequest(tags: tags)
        imageRequest.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent
        
        // Tracking download progress
        // Start observing fractionCompleted to track the progress
        var progressObservingContext = "observeForrestLoad"
        imageRequest.progress.addObserver(self, forKeyPath: "fractionCompleted", options: .new, context: &progressObservingContext)
        
        imageRequest.beginAccessingResources { (error) in
            OperationQueue.main.addOperation {
                if let error = error {
                    onFailure(error)
                } else {
                    onSuccess()
                }
            }
        }
        return imageRequest
    }
    
    func exampleOfUnsafeMutableRawPointer() {
        let bytesPointer = UnsafeMutableRawPointer.allocate(byteCount: 4, alignment: 1)
         bytesPointer.storeBytes(of: 0xFFFF_FFFF, as: UInt32.self)
    
         // Load a value from the memory referenced by 'bytesPointer'
        let x = bytesPointer.load(as: UInt8.self)       // 255
    
         // Load a value from the last two allocated bytes
        let offsetPointer = bytesPointer + 2
        let y = offsetPointer.load(as: UInt16.self)     // 65535
        
        print("UInt8 is: \(x), UInt16 is: \(y)")
        
        print("Here is the master")
        
        bytesPointer.deallocate()
    }
    
}
