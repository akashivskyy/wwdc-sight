// Filter.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import CoreImage

internal struct Filter {

    internal var ciFilters: [CIFilter]

    init(ciFilters: [CIFilter]) {
        
        self.ciFilters = ciFilters
    }



}
