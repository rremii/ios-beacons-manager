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
import CoreBluetooth



class BeaconManager: NSObject, CLLocationManagerDelegate,UNUserNotificationCenterDelegate {
    
    static var sharedInsstance = BeaconManager()

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
        
        print("INIT")
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
            

        UNUserNotificationCenter.current().delegate = self
            
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
        }

        
        region.notifyOnEntry = true
        region.notifyOnExit = true
    }

    
    
    func startMonitoringBeacons() {
            
        print("start monitoring")
        locationManager.startMonitoring(for: region)
    
        sleep(1)
        
        let beaconConstraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: AppConstants.beaconUuid)!)
        locationManager.startMonitoringLocationPushes()
        locationManager.startRangingBeacons(in: region)
        locationManager.startRangingBeacons(satisfying: beaconConstraint)
        
        print("ARE BEACONS AVAILABLE")
        print(CLLocationManager.isRangingAvailable())
    
    
        
        locationManager.requestState(for: region)
        locationManager.startUpdatingLocation()
        
        isMonitoringBeacons = true
    }
    
    
    //////////////////////
//    func startMonitoringBeaconsWithDelay() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.startMonitoringBeacons()
//        }
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print("NOTIFICATION")
//        print(response)
//            
//    }
    ////////////////


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
  
        
        print(locations)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Parcel for Veemarkt 168"
        content.body = "Check delivery note or contact resident"
        content.sound = UNNotificationSound.default
        let noti = UNNotificationRequest(identifier: "com.zippalert.deliveryalert", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(noti, withCompletionHandler: nil)
                
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
        
        // delegate?.didEnterBeaconRegion(region)
        
        NSLog("Enter beacon range")
        
        currentRegions[uuidString] = region
    }

    fileprivate func exitBeaconRegion(_ region: CLBeaconRegion) {
        
        let uuidString = region.uuid.uuidString
        
        currentRegions[uuidString] = nil
        
        // delegate?.didExitBeaconRegion(region)
        
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
        print("found beacon")
//        let key = beacon.key
//        NSLog("Found beacon: %@", beacon)
        
        // delegate?.didFindBeacon(key)
    }
    
    fileprivate func lostBeacon(_ beacon: CLBeacon) {
        print("lost beacon")
//        let key = beacon.key
//        NSLog("Lost beacon: %@", beacon)
        
        // delegate?.didLoseBeacon(key)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("did enter region")
//        if let beaconRegion = region as? CLBeaconRegion {
//            NSLog("Enter beacon region: %@", beaconRegion.proximityUUID.uuidString)
//            enterBeaconRegion(beaconRegion)
//        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("did exit region")
//        if let beaconRegion = region as? CLBeaconRegion {
//            NSLog("Exit beacon region: %@", beaconRegion.proximityUUID.uuidString)
//            exitBeaconRegion(beaconRegion)
//        }
    }

    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("did determine state")
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
        print("did range beacons")
        for beacon in beacons {
            if beaconsInRange[beacon.uuid.uuidString] == nil {
                beaconsInRange[beacon.uuid.uuidString] = beacon
                foundBeacon(beacon)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("start monitoring for region")
        if let _ = region as? CLBeaconRegion {
            NSLog("did start monitoring for beacon")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR")
        NSLog("location manager error: \(error.localizedDescription)")
    }
    
}

