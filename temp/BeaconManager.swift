//
//  BeaconManager.h
//  ZippBell
//
//  Created by Tijn Kooijmans on 20/06/16.
//  Copyright © 2016 Studio Sophisti. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


class BeaconManager: NSObject, CLLocationManagerDelegate {
    
//    static var sharedInsstance = BeaconManager()

    let locationManager: CLLocationManager
    let region: CLBeaconRegion
    
    var currentRegions = [String: CLBeaconRegion]()
    
    var isRanging = false
    var beaconsInRange = [String: CLBeacon]()
    
    var bgStopTimer: Timer?
    var rangingTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    
    var isMonitoringBeacons: Bool = false
    
    var delegate: BeaconManagerDelegate?
    
    override init() {
            
        locationManager = CLLocationManager()

        let beaconConstraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: AppConstants.beaconUuid)!)
        region = CLBeaconRegion(beaconIdentityConstraint: beaconConstraint, identifier: AppConstants.beaconIdentifier)
            
        super.init()
            
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
            
        region.notifyOnEntry = true
        region.notifyOnExit = true
    }

    func startMonitoringBeacons() {
            
        locationManager.startMonitoring(for: region)
//        delay(1) {
//            self.locationManager.requestState(for: self.region)
//        }
        
        isMonitoringBeacons = true
    }
    
    func stopMonitoringBeacons() {
        let beaconConstraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: AppConstants.beaconUuid)!)
        
        locationManager.stopRangingBeacons(satisfying: beaconConstraint)
        locationManager.stopMonitoring(for: region)
        
        isMonitoringBeacons = false
    }
    
    func stopBackgroundTask() {
        bgStopTimer = nil
        
        NSLog("Stop ranging beacons")
        
        let beaconConstraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: AppConstants.beaconUuid)!)
        self.locationManager.stopRangingBeacons(satisfying: beaconConstraint)

        isRanging = false
            
        NSLog("End background task")
        UIApplication.shared.endBackgroundTask(rangingTask)
    }
    
    fileprivate func enterBeaconRegion(_ region: CLBeaconRegion) {
        
        let uuidString = region.uuid.uuidString
        
        delegate?.didEnterBeaconRegion(region)
        
        NSLog("Enter beacon range")
        
        currentRegions[uuidString] = region
    }

    fileprivate func exitBeaconRegion(_ region: CLBeaconRegion) {
        
        let uuidString = region.uuid.uuidString
        
        currentRegions[uuidString] = nil
        
        delegate?.didExitBeaconRegion(region)
        
        NSLog("Exit beacon range")
        
        if currentRegions.isEmpty {
            isRanging = false
            
            for key in beaconsInRange.keys {
                lostBeacon(beaconsInRange[key]!)
                beaconsInRange[key] = nil
            }
        }
    }

    
    fileprivate func foundBeacon(_ beacon: CLBeacon) {
        let key = beacon.key
        NSLog("Found beacon: %@", key)
        
        delegate?.didFindBeacon(key)
    }
    
    fileprivate func lostBeacon(_ beacon: CLBeacon) {
        let key = beacon.key
        NSLog("Lost beacon: %@", key)
        
        delegate?.didLoseBeacon(key)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        if let beaconRegion = region as? CLBeaconRegion {
//            NSLog("Enter beacon region: %@", beaconRegion.proximityUUID.uuidString)
//            enterBeaconRegion(beaconRegion)
//        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        if let beaconRegion = region as? CLBeaconRegion {
//            NSLog("Exit beacon region: %@", beaconRegion.proximityUUID.uuidString)
//            exitBeaconRegion(beaconRegion)
//        }
    }

    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            if state == .inside {
                NSLog("Inside beacon region: %@", beaconRegion.uuid.uuidString)
                enterBeaconRegion(beaconRegion)
                
            } else if state == .outside {
                NSLog("Outside beacon region: %@", beaconRegion.uuid.uuidString)
                exitBeaconRegion(beaconRegion)
            }
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            if beaconsInRange[beacon.key] == nil {
                beaconsInRange[beacon.key] = beacon
                foundBeacon(beacon)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        if let _ = region as? CLBeaconRegion {
            NSLog("did start monitoring for beacon")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("location manager error: \(error.localizedDescription)")
    }
    
}

