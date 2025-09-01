//
//  ViewController.swift
//  Continuous Location
//
//  Created by Faiz Ul Hassan on 9/1/25.
//


import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    private var locationContinues:ContinuesLocationManager?


    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.delegate = self
        startTrackUser()
        // Add Long Press Gesture Recognizer
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        mapView.addGestureRecognizer(longPress)
    }

    // MARK: - Handle Long Press to Move User
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != .began { return } // Ensure it only triggers once per press

        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

        // Move the map center to the new coordinate
        let region = MKCoordinateRegion(center: newCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)

        // Remove previous overlays and add a new circle
        mapView.removeOverlays(mapView.overlays)
        let circle = MKCircle(center: newCoordinate, radius: 500) // 500 meters radius
        mapView.addOverlay(circle)

        // Simulate User Movement (Optional: You can call API to update tracking here)
        print("User moved to: \(newCoordinate.latitude), \(newCoordinate.longitude)")
    }


    func startTrackUser(){
        locationContinues = ContinuesLocationManager.shared
        locationContinues?.startTrackUser(lat:45.5019, long: -73.5674, apiEndPoint: "http://www.google.com/search", userID: 2)

    }

    func stopTrackUser(){
        locationContinues?.stopTrackUser()
        locationContinues = nil
    }


}
extension ViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let coordinate = userLocation.coordinate

        // Set region
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)

        // Remove existing overlays before adding a new one
        mapView.removeOverlays(mapView.overlays)

        // Draw a circular region
        let circle = MKCircle(center: coordinate, radius: 500) // 500 meters radius
        mapView.addOverlay(circle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let renderer = MKCircleRenderer(circle: circleOverlay)
            renderer.fillColor = UIColor.blue.withAlphaComponent(0.3) // Semi-transparent blue
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
}
