import { requireNativeModule } from "expo-modules-core";

const BeaconsManager = requireNativeModule("BeaconsManagerModule");

BeaconsManager.addListener("onInitialize", (event: any) => {
  console.log(event);
});
BeaconsManager.addListener("didEnterBeaconRegion", (event: any) => {
  console.log(event);
});
BeaconsManager.addListener("didExitBeaconRegion", (event: any) => {
  console.log(event);
});
BeaconsManager.addListener("didFindBeacon", (event: any) => {
  console.log(event);
});

export default BeaconsManager;
