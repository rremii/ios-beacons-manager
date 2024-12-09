import Foundation
import CoreLocation

@objc public class BeaconManager: NSObject, CLLocationManagerDelegate {
  private var locationManager: CLLocationManager!
  public static let sharedInstance = BeaconManager()
  var delegate: BeaconManagerDelegate?


    

  override private init() {
    super.init()
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    locationManager.allowsBackgroundLocationUpdates = true

    

    let beaconConstraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: AppConstants.beaconUuid)!)
    let region = CLBeaconRegion(beaconIdentityConstraint: beaconConstraint, identifier: AppConstants.beaconIdentifier)
    
         
            
    region.notifyOnEntry = true
    region.notifyOnExit = true
  }
  
  public func startMonitoringBeacons() {
    if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
        let beaconConstraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: AppConstants.beaconUuid)!)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: beaconConstraint, identifier: AppConstants.beaconIdentifier)

        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: UUID(uuidString: AppConstants.beaconUuid)!))
    }
  }
  
  public func stopMonitoringBeacons() {
    if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {

 
        let beaconConstraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: AppConstants.beaconUuid)!)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: beaconConstraint, identifier: AppConstants.beaconIdentifier)

        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: UUID(uuidString: AppConstants.beaconUuid)!))
    }
  }
  
  public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
    print("Started monitoring region: \(region.identifier)")
    locationManager.requestState(for: region)
  }
  
  public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
    if state == .inside {
      if let beaconRegion = region as? CLBeaconRegion {
        locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: beaconRegion.uuid))
      }
    } else {
      if let beaconRegion = region as? CLBeaconRegion {
        locationManager.stopRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: beaconRegion.uuid))
      }
    }
  }
  
  public func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconIdentityConstraint: CLBeaconIdentityConstraint) {
    if let nearestBeacon = beacons.first {
        print("Nearest beacon: \(nearestBeacon)")
        
        delegate?.didFindBeacon(nearestBeacon.uuid.uuidString)
    }
  }
  
  public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    print("Entered region: \(region.identifier)")
    delegate?.didEnterBeaconRegion(region)
  }
  
  public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    print("Exited region: \(region.identifier)")
    delegate?.didExitBeaconRegion(region)
  }
  
  public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    print("Monitoring failed for region: \(region?.identifier ?? "unknown region") with error: \(error)")
  }
  
  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location manager failed with error: \(error)")
  }
}
