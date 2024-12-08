import ExpoModulesCore

public class BeaconsManagerModule: Module {
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  public func definition() -> ModuleDefinition {
    Name("BeaconsManagerModule")

    Events("onInitialize")

    AsyncFunction("initialize") {
      self.sendEvent("onInitialize", ["message": "Module initialized"])
    }
  }
}
