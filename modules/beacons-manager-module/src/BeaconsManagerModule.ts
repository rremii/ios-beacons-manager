import { requireNativeModule } from "expo-modules-core";

const BeaconsManagerModule = requireNativeModule("BeaconsManagerModule");

console.log(BeaconsManagerModule);

BeaconsManagerModule.addListener("onInitialize", (event: any) => {
  console.log(event);
});

export default BeaconsManagerModule;

// export const getMessageAsync = async () => {
//   return await BeaconsManagerModule.initialize();
// };
