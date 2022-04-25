//
//  AppSettings.swift
//
//
//  Created by  on 15/3/22.
//

import Foundation
import SwiftUI

class AppSettings: ObservableObject, Identifiable, Equatable {
    
    static func == (lhs: AppSettings, rhs: AppSettings) -> Bool {
        return lhs.id==rhs.id
    }
    
    var id = UUID()
    
    @Published var dpi: Double = 300.0
    @Published var dpiScale: Double = 300.0/72.0
    @Published var zoomFactor: Double = 1.0
    @Published var units: String = "Inches"
    @Published var zoomingOrScrollX: String = "scroll" //zoomIn, zoomOut, scroll
    @Published var zoomingOrScrollY: String = "scroll" //zoomIn, zoomOut, scroll

    
    
    
    init(_ dpi: Double, _ zoomFactor: Double) {
        self.dpi=dpi
        self.dpiScale=dpi/72.0
        self.zoomFactor=zoomFactor
    }
}

