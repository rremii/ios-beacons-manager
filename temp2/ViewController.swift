//
//  ViewController.swift
//  ibeacon-manager
//
//  Created by user on 04/12/2024.
//

import CoreLocation
import UIKit
import CoreBluetooth

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func rangeBeacons() {
        let uuid = UUID(uuidString: "DE62C6D0-005E-4F32-B019-AA45124005CA")!
        let major:CLBeaconMajorValue = 5
        let minor:CLBeaconMinorValue = 5
        let identifier = "com.zipplabs.beacon"
        
        let region = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
        
        locationManager.startRangingBeacons(in: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            rangeBeacons()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("beacons: ", beacons)
        
        guard let discoveredBeaconProximity = beacons.first?.proximity else { print("Couldn't find the beacon!"); return }
        
        let backgroundColor:UIColor = {
            switch discoveredBeaconProximity {
            case .immediate: return UIColor.green
            case .near: return UIColor.orange
            case .far: return UIColor.red
            case .unknown: return UIColor.black
            }
        }()
        
        view.backgroundColor = backgroundColor
    }


}

