//
//  PlaceMarker.swift
//  Feed Me
//
//  Created by hodaya ohana on 12/30/14.
//  Copyright (c) 2014 Ron Kliffer. All rights reserved.
//
//import GoogleMaps

class PlaceMarker: GMSMarker {

  let place: GooglePlace
  
  init(place: GooglePlace) {
    self.place = place
    super.init()
    position = place.coordinate
    icon = UIImage(named: place.placeType+"_pin")
    groundAnchor = CGPoint(x: 0.5, y: 1)
    appearAnimation = kGMSMarkerAnimationPop
  }
}
