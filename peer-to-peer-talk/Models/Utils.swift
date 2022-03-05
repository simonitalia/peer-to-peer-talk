//
//  Utilis.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 05/03/22.
//

import UIKit

class Utils {
    
    enum SettingsPath: String {
        case localNetwork = "LOCAL_NETWORK"
    }
    
    class func openSettingsUrl(path: SettingsPath) {
        
        if let bundleId = Bundle.main.bundleIdentifier,
           let url = URL(string: "\(UIApplication.openSettingsURLString)&path=\(path.rawValue)/\(bundleId)")
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
