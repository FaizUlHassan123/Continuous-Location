//
//  ContinuesLocationManager.swift
//  Continuous Location
//
//  Created by Faiz Ul Hassan on 9/1/25.
//


import Foundation
import CoreLocation
import UIKit

class ContinuesLocationManager: NSObject, CLLocationManagerDelegate {

    // MARK: - Singleton
    static let shared = ContinuesLocationManager()
    private override init() {
        super.init()
        locationManager.delegate = self
    }

    // MARK: - Properties
    private let locationManager = CLLocationManager()
    var myLocation: CLLocation?
    var isTrackUser = false

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd/MM/yyyy hh:mm:ss a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()


    func startTrackUser(lat: Double, long: Double, apiEndPoint: String, userID: Int) {
        let defaults = UserDefaults.standard
        defaults.set(lat, forKey: "StoredLatitude")
        defaults.set(long, forKey: "StoredLongitude")
        defaults.set(apiEndPoint, forKey: "StoredAPIEndpoint")
        defaults.set(userID, forKey: "StoredUserID")
        defaults.synchronize()

        guard !isTrackUser else { return }
        isTrackUser = true

//        locationManager.distanceFilter = kCLDistanceFilterNone
//        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//        locationManager.startUpdatingLocation()
        createRegion(lat: lat, long: long)
    }

    func stopTrackUser() {
        isTrackUser = false
        locationManager.stopUpdatingLocation()

        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }

    func createRegion(lat: Double, long: Double) {
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
            print("System can't track regions")
            return
        }

        // Stop all existing
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }

        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = CLCircularRegion(center: coordinate, radius: 50.0, identifier: "dynamicRegion")
        region.notifyOnEntry = true
        region.notifyOnExit = true

        locationManager.startMonitoring(for: region)
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .restricted, .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                self.showAlert(
                    title: "Location Required",
                    message: "Please enable location services for better functionality."
                )
            }

        case .authorizedWhenInUse:
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                manager.requestAlwaysAuthorization()
            }

        case .authorizedAlways:
            manager.startUpdatingLocation()

        @unknown default:
            print("Unknown authorization status")
        }
    }


    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print(#function)
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("User entered the region")

        if let location = manager.location {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("Current location → \(lat), \(lon)")
        }

        checkInOrCheckOutUser(isCheckin: true)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("User exited the region")
        if let location = manager.location {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("Current location → \(lat), \(lon)")
        }
        checkInOrCheckOutUser(isCheckin: false)
    }

    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print("Error didFinishDeferredUpdatesWithError for \(#function)  \(String(describing: error?.localizedDescription))")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        guard let location = locations.last else { return }

        //        if location.horizontalAccuracy <= 65.0 {
        //            myLocation = location
        //                        createRegion(location: location)
        //        } else {
        //            manager.stopUpdatingLocation()
        //            manager.startUpdatingLocation()
        //        }
    }


    private func sendNotification(message:String) {
        let content = UNMutableNotificationContent()
        content.title = message
        content.body = getFormattedDate()
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "location_notification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    func getFormattedDate() -> String {
        return dateFormatter.string(from: Date())
    }
}
extension ContinuesLocationManager{

    // MARK: - Show Alert
    func showAlert(title: String, message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

            //            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alertController.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL)
                }
            })

            UIApplication.topViewController?.present(alertController, animated: true)
        }
    }

    func checkInOrCheckOutUser(isCheckin:Bool) {

        sendNotification(message: isCheckin ? "Checking In..." : "Checking Out...")

        //        let defaults = UserDefaults.standard
        //        let storedLat = defaults.double(forKey: "StoredLatitude")
        //        let storedLong = defaults.double(forKey: "StoredLongitude")
        //        let storedAPIEndpoint = defaults.string(forKey: "StoredAPIEndpoint") ?? ""
        //        let storedUserID = defaults.integer(forKey: "StoredUserID")
        //
        //        guard !storedAPIEndpoint.isEmpty, var urlComponents = URLComponents(string: storedAPIEndpoint) else {
        //            print("Invalid API Endpoint")
        //            return
        //        }
        //
        //        // Append query parameters
        //        urlComponents.queryItems = [
        //            URLQueryItem(name: "latitude", value: "\(storedLat)"),
        //            URLQueryItem(name: "longitude", value: "\(storedLong)"),
        //            URLQueryItem(name: "userId", value: "\(storedUserID)")
        //        ]
        //
        //        guard let url = urlComponents.url else {
        //            print("Failed to construct URL")
        //            return
        //        }
        //
        //        var request = URLRequest(url: url)
        //        request.httpMethod = "GET"
        //
        //        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        //              DispatchQueue.main.async {
        //                  if let error = error {
        //                      print("Error: \(error.localizedDescription)")
        //                      return
        //                  }
        //                  if let httpResponse = response as? HTTPURLResponse {
        //                      print("Response Status Code: \(httpResponse.statusCode)")
        //                  }
        //                  if let data = data, let responseString = String(data: data, encoding: .utf8) {
        //                      print("Response Data: \(responseString)")
        //                  }
        //              }
        //          }
        //
        //        task.resume()
    }

}
