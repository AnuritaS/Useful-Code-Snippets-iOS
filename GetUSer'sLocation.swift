//
//  GetUSer'sLocation.swift
//  Mooskine
//
//  Created by Anurita Srivastava on 10/09/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

let locationManager = CLLocationManager()
In viewDidLoad() you have to instanitate the CLLocationManager class, like this:

// Ask for Authorisation from the User.
self.locationManager.requestAlwaysAuthorization()

// For use in foreground
self.locationManager.requestWhenInUseAuthorization()

if CLLocationManager.locationServicesEnabled() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.startUpdatingLocation()
}
Then in CLLocationManagerDelegate method you can get user's current location coordinates:

func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    print("locations = \(locValue.latitude) \(locValue.longitude)")
}
