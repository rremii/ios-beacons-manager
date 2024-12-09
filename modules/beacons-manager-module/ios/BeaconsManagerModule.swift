import ExpoModulesCore
import CoreLocation

//https://www.npmjs.com/package/react-native-ibeacon
public class BeaconsManagerModule: Module,BeaconManagerDelegate {
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  public func definition() -> ModuleDefinition {
    Name("BeaconsManagerModule")

    Events(
      "onInitialize",
      "didEnterBeaconRegion",
      "didFindBeacon",
      "didExitBeaconRegion"
    )

    AsyncFunction("initialize") {
      
      
        // BeaconManager.sharedInstance.startMonitoringBeacons()
        BeaconManager.sharedInstance.delegate = self
        
      
        self.sendEvent("onInitialize", ["message": "Module initialized"])
    }
      
  }
        

    
  @objc func didEnterBeaconRegion(_ region: CLRegion) {
    sendEvent("didEnterBeaconRegion", ["message": region])

    print("Inside region")
  }
  
  @objc func didFindBeacon(_ beaconId: String) {
    sendEvent("didFindBeacon", ["message": beaconId])

    print("Found beacon")
  }
  
  @objc func didExitBeaconRegion(_ region: CLRegion) {
    sendEvent("didExitBeaconRegion", ["message": region])

    print("Outside region")
  }
}
