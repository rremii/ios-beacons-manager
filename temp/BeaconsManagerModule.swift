import ExpoModulesCore



public class BeaconsManagerModule: Module,BeaconManagerDelegate {
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  public func definition() -> ModuleDefinition {
    Name("BeaconsManagerModule")

    Events(
      "onInitialize",
      "didEnterBeaconRegion",
      "didFindBeacon",
      "didLoseBeacon",
      "didExitBeaconRegion"
    )

    AsyncFunction("initialize") {
      
//        let beaconManager = BeaconManager()
        
//      BeaconManager.sharedInsstance.startMonitoringBeacons()
//        BeaconManager.sharedInsstance.delegate = self
        
//        beaconManager.delegate = self
        
      
        self.sendEvent("onInitialize", ["message": "Module initialized"])
    }
      
  }
    

        
    
    
    
    

    
  @objc func didEnterBeaconRegion(_ region: CLBeaconRegion) {
    sendEvent("didEnterBeaconRegion", ["message": region])

    print("Inside region")
  }
  
  @objc func didFindBeacon(_ beaconId: String) {
    sendEvent("didFindBeacon", ["message": beaconId])

    print("Found beacon")
  }
  
  @objc func didLoseBeacon(_ beaconId: String) {
    sendEvent("didLoseBeacon", ["message": beaconId])

    print("Lost beacon")
  }
  
  @objc func didExitBeaconRegion(_ region: CLBeaconRegion) {
    sendEvent("didExitBeaconRegion", ["message": region])

    print("Outside region")
  }
}
