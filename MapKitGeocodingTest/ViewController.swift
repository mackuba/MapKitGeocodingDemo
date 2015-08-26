//
//  ViewController.swift
//  MapKitGeocodingTest
//
//  Created by Kuba Suder on 26.08.2015.
//  Copyright (c) 2015 Kuba Suder. All rights reserved.
//

import MapKit
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var addressField: UITextField!

    var marker: MKPointAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchPressed()
        textField.resignFirstResponder()
        return true
    }

    @IBAction func searchPressed() {
        result.hidden = false
        map.hidden = true

        if let marker = self.marker {
            map.removeAnnotation(marker)
            self.marker = nil
        }

        let text = addressField.text

        if text.isEmpty {
            result.text = "Address is empty!"
            return
        }

        result.text = "Searching..."

        let geocoder = CLGeocoder()

        // let's prioritize US addresses (this doesn't seem to work though?)
        let region = CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: 39.05, longitude: -95.78),
            radius: 3_000_000,
            identifier: "USA"
        )

        geocoder.geocodeAddressString(text, inRegion: region) { placemarks, error in
            if let places = placemarks as? [CLPlacemark] {
                for place in placemarks {
                    NSLog("\(place)")
                }

                if let first = places.first {
                    self.result.text = "Found \(places.count) place(s), I think you're here: \(first.name)"
                    self.map.hidden = false

                    let marker = MKPointAnnotation()
                    marker.coordinate = first.location.coordinate
                    self.marker = marker

                    self.map.addAnnotation(marker)
                    self.map.showAnnotations([marker], animated: true)
                } else {
                    self.result.text = "No places found."
                }
            }

            if let error = error {
                self.result.text = "Error: \(error)"
            }
        }
    }
}
