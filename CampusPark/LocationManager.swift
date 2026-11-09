//
//  LocationManager.swift
//  CampusPark
//
//  Created by Shammah on 09/11/2026.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject,CLLocationManagerDelegate {
    
   private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
    }
}
