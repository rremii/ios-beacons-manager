import ExpoModulesCore

public class BeaconsManager: Module,BeaconManagerDelegate {


  public func definition() -> ModuleDefinition {
    Name("BeaconsManager")

    Events(
      "onInitialize" 
    )

   AsyncFunction("initialize") {
         
       (promise: Promise) in self.sendEvent("onInitialize", ["message": "Module initialized"])
       
       
       promise.resolve(nil)
   }

  }



    
    
    private func sendEvent(_ eventName: String, _ body: [String: Any]) {
        if let eventEmitter = appContext?.eventEmitter as? EXEventEmitterService {
            eventEmitter.sendEvent(withName: eventName, body: body)
        }
    }
  


  @objc func didEnterBeaconRegion(_ region: CLBeaconRegion) {
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
