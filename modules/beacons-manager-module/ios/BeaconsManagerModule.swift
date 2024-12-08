import ExpoModulesCore

public class BeaconsManagerModule: Module,BeaconManagerDelegate {
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  public func definition() -> ModuleDefinition {
    Name("BeaconsManagerModule")

    Events("onInitialize")

    AsyncFunction("initialize") {
      self.sendEvent("onInitialize", ["message": "Module initialized"])
    }
      
  }


  @objc func didEnterBeaconRegion(_ region: CLBeaconRegion) {
    self.sendEvent(batteryStateDidChange, [
      "batteryState": UIDevice.current.batteryState.rawValue
    ])
    print("Inside region")
  }
  
  @objc func didFindBeacon(_ beaconId: String) {
    print("Found beacon")
  }
  
  @objc func didLoseBeacon(_ beaconId: String) {
    print("Lost beacon")
  }
  
  @objc func didExitBeaconRegion(_ region: CLBeaconRegion) {
    print("Outside region")
  }
}
