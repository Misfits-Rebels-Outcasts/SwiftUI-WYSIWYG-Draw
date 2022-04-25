//
//  PageSettings.swift
//
//
//  Created by  on 16/3/22.
//

import Foundation
import SwiftUI

struct ILabel: Identifiable {
    var id = UUID()
    var label: Int
    var x:CGFloat
    var y:CGFloat
}

class PageSettings: Codable, ObservableObject, Identifiable, Equatable {
    
    static func == (lhs: PageSettings, rhs: PageSettings) -> Bool {
        return lhs.id==rhs.id
    }
    
    var id = UUID()

    //name,category,vendor,description,orientation
    @Published var name: String = "Standard SLE005"
    @Published var category: String = "Labels"
    @Published var vendor: String = "Standard"
    @Published var description: String = "Address Label (Letter) - 10x3"
    @Published var type: String = "iso-letter"    
    
    @Published var pageWidth: Double = 8.5
    @Published var pageHeight: Double = 11.0
    @Published var leftMargin: Double = 0.188
    @Published var topMargin: Double = 0.5
    @Published var labelWidth: Double = 2.625
    @Published var labelHeight: Double = 1.0
    @Published var hSpace: Double = 0.125
    @Published var vSpace: Double = 0.0
    @Published var numRows: Int = 10
    @Published var numCols: Int = 3
    @Published var dpi: Double =  300.0//72.0
    @Published var labelList = [ILabel]()

    init() {
        generateLabels()
    }
    init(name: String,
         category: String,
         vendor: String,
         description: String,
         type: String,
         pageWidth: Double,
         pageHeight: Double,
         leftMargin: Double,
         topMargin: Double,
         labelWidth: Double,
         labelHeight: Double,
         hSpace: Double,
         vSpace: Double,
         numRows: Int,
         numCols: Int,
         dpi: Double) {
        
        self.name=name
        self.category=category
        self.vendor=vendor
        self.description=description
        self.type=type
        self.pageWidth=pageWidth
        self.pageHeight=pageHeight
        self.leftMargin=leftMargin
        self.topMargin=topMargin
        self.labelWidth=labelWidth
        self.labelHeight=labelHeight
        self.hSpace=hSpace
        self.vSpace=vSpace
        self.numRows=numRows
        self.numCols=numCols
        self.dpi=dpi
        
        generateLabels()
    }
    
    func generateLabels()
    {
        generateLabels(dpi:dpi)
    }
    
    func generateLabels(dpi :Double)
    {
        labelList = [ILabel]()
        var x = leftMargin * dpi
        var y = topMargin * dpi
        let adjustX = labelWidth / 2.0 * dpi
        let adjustY = labelHeight / 2.0 * dpi
        var count = 1
        //print ("Label:",numRows,":",numCols,":",pageWidth,":",pageHeight,":",labelWidth,":",labelHeight)
        
        for _ in 1...numRows {
            for _ in 1...numCols {
                labelList.append(ILabel(label: count, x: x + adjustX, y: y + adjustY))
                count=count+1
                x = x + hSpace * dpi
                x = x + labelWidth * dpi
            }
            x = leftMargin * dpi
            y = y + vSpace * dpi
            y = y + labelHeight * dpi
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case category
        case vendor
        case description
        case type
        case pageWidth
        case pageHeight
        case leftMargin
        case topMargin
        case labelWidth
        case labelHeight
        case hSpace
        case vSpace
        case numRows
        case numCols
        case dpi
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? "Standard"
        category = try values.decodeIfPresent(String.self, forKey: .category) ?? "Labels"
        vendor = try values.decodeIfPresent(String.self, forKey: .vendor) ?? "Standard"
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? "Address Label (Letter) - 10x3"
        type = try values.decodeIfPresent(String.self, forKey: .type) ?? "iso-letter"
        pageWidth = try values.decodeIfPresent(Double.self, forKey: .pageWidth) ?? 8.5
        pageHeight = try values.decodeIfPresent(Double.self, forKey: .pageHeight) ?? 11.0
        leftMargin = try values.decodeIfPresent(Double.self, forKey: .leftMargin) ?? 0.188
        topMargin = try values.decodeIfPresent(Double.self, forKey: .topMargin) ?? 0.5
        labelWidth = try values.decodeIfPresent(Double.self, forKey: .labelWidth) ?? 2.625
        labelHeight = try values.decodeIfPresent(Double.self, forKey: .labelHeight) ?? 1.0
        hSpace = try values.decodeIfPresent(Double.self, forKey: .hSpace) ??  0.125
        vSpace = try values.decodeIfPresent(Double.self, forKey: .vSpace) ?? 0.0
        numRows = try values.decodeIfPresent(Int.self, forKey: .numRows) ?? 10
        numCols = try values.decodeIfPresent(Int.self, forKey: .numCols) ?? 3
        dpi = try values.decodeIfPresent(Double.self, forKey: .dpi) ?? 300.0
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)        
        try container.encode(vendor, forKey: .vendor)
        try container.encode(description, forKey: .description)
        try container.encode(type, forKey: .type)
        try container.encode(pageWidth, forKey: .pageWidth)
        try container.encode(pageHeight, forKey: .pageHeight)
        try container.encode(leftMargin, forKey: .leftMargin)
        try container.encode(topMargin, forKey: .topMargin)
        try container.encode(labelWidth, forKey: .labelWidth)
        try container.encode(labelHeight, forKey: .labelHeight)
        try container.encode(hSpace, forKey: .hSpace)
        try container.encode(vSpace, forKey: .vSpace)
        try container.encode(numRows, forKey: .numRows)
        try container.encode(numCols, forKey: .numCols)
        try container.encode(dpi, forKey: .dpi)
    }
}



