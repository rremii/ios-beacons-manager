import Foundation
import CoreLocation

@objc public class BeaconManager: NSObject, CLLocationManagerDelegate {
  private var locationManager: CLLocationManager!
  public static let sharedInstance = BeaconManager()
  var delegate: BeaconManagerDelegate?

  override private init() {
    super.init()
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedAlways {
            rangeBeacons()
        }
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
        
        delegate.didFindBeacon(beacons.first.uuid.uuidString)

        // guard let discoveredBeaconProximity = beacons.first?.proximity else { print("Couldn't find the beacon!"); return }
        
        // let backgroundColor:UIColor = {
        //     switch discoveredBeaconProximity {
        //     case .immediate: return UIColor.green
        //     case .near: return UIColor.orange
        //     case .far: return UIColor.red
        //     case .unknown: return UIColor.black
        //     }
        // }()
        
        // view.backgroundColor = backgroundColor
  }

  
  
  // public func startMonitoringBeacons() {
  //   if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
  //       let beaconConstraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: AppConstants.beaconUuid)!)
  //       let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: beaconConstraint, identifier: AppConstants.beaconIdentifier)

  //       locationManager.startMonitoring(for: beaconRegion)
  //       locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: UUID(uuidString: AppConstants.beaconUuid)!))
  //   }
  // }
  
  // public func stopMonitoringBeacons() {
  //   if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {

 
  //       let beaconConstraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: AppConstants.beaconUuid)!)
  //       let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: beaconConstraint, identifier: AppConstants.beaconIdentifier)

  //       locationManager.stopMonitoring(for: beaconRegion)
  //       locationManager.stopRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: UUID(uuidString: AppConstants.beaconUuid)!))
  //   }
  // }
  
  // public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
  //   print("Started monitoring region: \(region.identifier)")
  //   locationManager.requestState(for: region)
  // }
  
  // public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
  //   if state == .inside {
  //     if let beaconRegion = region as? CLBeaconRegion {
  //       locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: beaconRegion.uuid))
  //     }
  //   } else {
  //     if let beaconRegion = region as? CLBeaconRegion {
  //       locationManager.stopRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: beaconRegion.uuid))
  //     }
  //   }
  // }
  
  // public func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconIdentityConstraint: CLBeaconIdentityConstraint) {
  //   if let nearestBeacon = beacons.first {
  //       print("Nearest beacon: \(nearestBeacon)")
        
  //       delegate?.didFindBeacon(nearestBeacon.uuid.uuidString)
  //   }
  // }
  
  // public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
  //   print("Entered region: \(region.identifier)")
  //   delegate?.didEnterBeaconRegion(region)
  // }
  
  // public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
  //   print("Exited region: \(region.identifier)")
  //   delegate?.didExitBeaconRegion(region)
  // }
  
  // public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
  //   print("Monitoring failed for region: \(region?.identifier ?? "unknown region") with error: \(error)")
  // }
  
  // public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
  //   print("Location manager failed with error: \(error)")
  // }
}
