/*
Copyright 2022 barcoderesource.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import SwiftUI

class RectangleX: ShapeX {
       
    @Published var strokeWidth:Double = 0.25 * 300.0/72.0
    @Published var strokeColor = Color.black
    @Published var fillColor = Color.white

    init(_ dpi:Double, _ location: CGPoint, _ size: CGSize, _ canvasSize: CGSize, _ isSelected: Bool) {
        super.init(dpi,"Rectangle",location,size,canvasSize,isSelected)
        strokeWidth = 0.25 * dpi/72.0
    }
    
    enum CodingKeys : String, CodingKey {
        case strokeWidth
        case strokeColor
        case fillColor
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        strokeWidth = try values.decodeIfPresent(Double.self, forKey: .strokeWidth) ?? 0.25 * dpi/72.0
        
        let strokeColorData = try values.decodeIfPresent(Data.self, forKey: .strokeColor) ?? nil
        if strokeColorData != nil
        {
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: strokeColorData!)
            strokeColor = Color(color!)
        }
        
        let fillColorData = try values.decodeIfPresent(Data.self, forKey: .fillColor) ?? nil
        if fillColorData != nil
        {
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: fillColorData!)
            fillColor = Color(color!)
        }
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(strokeWidth, forKey: .strokeWidth)
      
        let convertedStrokeColor = UIColor(strokeColor)
        let strokeColorData = try NSKeyedArchiver.archivedData(withRootObject: convertedStrokeColor, requiringSecureCoding: false)
        try container.encode(strokeColorData, forKey: .strokeColor)
              
        let convertedFillColor = UIColor(fillColor)
        let fillColorData = try NSKeyedArchiver.archivedData(withRootObject: convertedFillColor, requiringSecureCoding: false)
        try container.encode(fillColorData, forKey: .fillColor)
    }

    override func view() -> AnyView {
        AnyView(
            Rectangle()
                .stroke(strokeColor, lineWidth: strokeWidth)
                .background(Rectangle().fill(fillColor))
                //.fill(Color.white)
                .frame(width: self.size.width, height: self.size.height)
                //.border(Color.black)
                .position(self.location)
                )
                
        }
}

