//
//  ParkingRecord.swift
//  CampusPark
//
//  Created by Shammah on 25/11/2026.
//

import Foundation
import SwiftData

@Model
class ParkingRecord: Identifiable {

    @Attribute(.unique) var id: UUID = UUID()

    var parkingArea: String
    var spotNumber: String
    var reminderEnabled: Bool
    var savedAt: Date

    var latitude: Double?
    var longitude: Double?

    init(parkingArea: String,
         spotNumber: String,
         reminderEnabled: Bool,
         latitude: Double? = nil,
         longitude: Double? = nil) {

        self.parkingArea = parkingArea
        self.spotNumber = spotNumber
        self.reminderEnabled = reminderEnabled
        self.savedAt = Date()
        self.latitude = latitude
        self.longitude = longitude
    }
}
