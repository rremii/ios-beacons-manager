//
//  ViewController.swift
//  ZippBeacon
//
//  Created by Tijn Kooijmans on 12/06/2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, BeaconManagerDelegate, UNUserNotificationCenterDelegate {
      
    @IBOutlet weak var lblInfo: UILabel!
        
    var bgStopTimer: Timer?
    var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        
        BeaconManager.sharedInstance.startMonitoringBeacons()
        BeaconManager.sharedInstance.delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            
        }
    }

    func didEnterBeaconRegion(_ region: CLBeaconRegion) {
        lblInfo.text = "Inside region"
        
        URLSessionConfiguration.background(withIdentifier:
                                           "com.zipplabs.ZippBeacon")
        
        self.bgTask = UIApplication.shared.beginBackgroundTask(withName: "BackgroundTask-Init", expirationHandler: {
            self.stopBackgroundTask()
        })
        self.bgStopTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.stopBackgroundTask), userInfo: nil, repeats: false)
        RunLoop.current.add(self.bgStopTimer!, forMode: RunLoop.Mode.common)
        
        let json: [String: Any] = ["topic": "20211820258","title": "Your parcel is at the door!","battery": "3000"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "https://europe-west1-bitnami--wjgkn1xba.cloudfunctions.net/ringBell")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("\(jsonData!.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("HTTP Request Failed \(error)")
            } else {
                print("HTTP Request Success")
            }
        }

        task.resume()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Parcel for Veemarkt 168"
        content.body = "Check delivery note or contact resident"
        content.sound = UNNotificationSound.default
        let noti = UNNotificationRequest(identifier: "com.zippalert.deliveryalert", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(noti, withCompletionHandler: nil)
        
    }
    
    func didFindBeacon(_ beaconId: String) {
    }
    
    func didLoseBeacon(_ beaconId: String) {
    }
    
    func didExitBeaconRegion(_ region: CLBeaconRegion) {
        lblInfo.text = "Outside region"
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let url = URL(string: "https://door.bellalert.eu/2NLlkDwV8RwQXwX2")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    @objc func stopBackgroundTask() {
        if bgTask == UIBackgroundTaskIdentifier.invalid {
            return
        }
        
        bgStopTimer?.invalidate()
        bgStopTimer = nil
        
        NSLog("End background task")
        UIApplication.shared.endBackgroundTask(bgTask)
        bgTask = UIBackgroundTaskIdentifier.invalid
    }
}

