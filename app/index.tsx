import { Text, View } from "react-native";
import BeaconsManagerModule from "@/modules/beacons-manager-module/src/BeaconsManagerModule";
import { useEffect } from "react";

export default function Index() {
  useEffect(() => {
    BeaconsManagerModule.initialize();
  }, []);

  return (
    <View
      style={{
        flex: 1,
        justifyContent: "center",
        alignItems: "center",
      }}
    >
      <Text>qweqwe</Text>
    </View>
  );
}
