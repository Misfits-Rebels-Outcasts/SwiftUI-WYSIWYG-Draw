//
//  BaseViewModel.swift
//
//
//  Created by  on 23/3/22.
//

import Foundation
import SwiftUI
class ObjectBaseViewModel: ObservableObject {

    @Published var x: String = ""
    @Published var y: String = ""
    @Published var width: String = ""
    @Published var height: String = ""
    @Published var zIndex: String = "0"
    
    let shapes: ShapesX
    init(shapes: ShapesX) {
       self.shapes = shapes
    }
    
    func setupSelectedProperties(x: CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, zIndex: Double)
    {
        print("setup x:",x)
        self.x = String(format: "%.0f", x)
        self.y = String(format: "%.0f", y)
        self.width = String(format: "%.0f", width)
        self.height = String(format: "%.0f", height)
        self.zIndex = String(format: "%.0f", zIndex)
    }
    
}
