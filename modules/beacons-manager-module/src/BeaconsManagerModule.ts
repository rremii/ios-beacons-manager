import { requireNativeModule } from "expo-modules-core";

const BeaconsManager = requireNativeModule("BeaconsManagerModule");

BeaconsManager.addListener("onInitialize", (event: any) => {
  console.log(event);
});

export default BeaconsManager;

// export const getMessageAsync = async () => {
//   return await BeaconsManagerModule.initialize();
// };
