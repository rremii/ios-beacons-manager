//
//  BeaconManagerDelegate.swift
//  ZippBell
//
//  Created by Tijn Kooijmans on 30/06/16.
//  Copyright © 2016 Studio Sophisti. All rights reserved.
//

import Foundation
import CoreLocation

protocol BeaconManagerDelegate {    
    func didEnterBeaconRegion(_ region: CLBeaconRegion)
    func didFindBeacon(_ beaconId: String)
    func didLoseBeacon(_ beaconId: String)
    func didExitBeaconRegion(_ region: CLBeaconRegion)
}
