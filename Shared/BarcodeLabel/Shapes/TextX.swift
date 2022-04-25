/*
Copyright 2022 barcoderesource.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import SwiftUI

class TextX: ShapeX {
    
    @Published var fontSize:CGFloat = 16.0*300.0/72.0
    @Published var text:String = "Text"
    @Published var originalText:String = "Text"
    @Published var fontName:String = "Arial"
    @Published var textColor = Color.black
    @Published var horizontalTextAlignment:String = "Center"
    
    init(_ dpi:Double, _ location: CGPoint, _ size: CGSize, _ canvasSize: CGSize, _ isSelected: Bool) {
        
        super.init(dpi,"Text",location,size,canvasSize,isSelected)
        fontSize=16.0*dpi/72.0
        
    }

    enum CodingKeys : String, CodingKey {
        case fontSize
        case text
        //case originalText
        case fontName
        case textColor
        case horizontalTextAlignment
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fontSize = try values.decodeIfPresent(CGFloat.self, forKey: .fontSize) ?? 18.0*dpi/72.0
        text = try values.decodeIfPresent(String.self, forKey: .text) ?? "Text"
        fontName = try values.decodeIfPresent(String.self, forKey: .fontName) ?? "Arial"

        let textColorData = try values.decodeIfPresent(Data.self, forKey: .textColor) ?? nil
        if textColorData != nil
        {
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: textColorData!)
            textColor = Color(color!)
        }
        horizontalTextAlignment = try values.decodeIfPresent(String.self, forKey: .horizontalTextAlignment) ?? "Center"

    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fontSize, forKey: .fontSize)
        try container.encode(text, forKey: .text)
        try container.encode(fontName, forKey: .fontName)
        let convertedTextColor = UIColor(textColor)
        let textColorData = try NSKeyedArchiver.archivedData(withRootObject: convertedTextColor, requiringSecureCoding: false)
        try container.encode(textColorData, forKey: .textColor)
        try container.encode(horizontalTextAlignment, forKey: .horizontalTextAlignment)

    }
    
    override func view() -> AnyView {
        AnyView(
            HStack{
                if horizontalTextAlignment == "Right" { Spacer() }
                Text(self.text)
                    .lineLimit(1)
                    .font(.custom(self.fontName, size: self.fontSize))
                    .foregroundColor(self.textColor)
                    .fixedSize(horizontal: true, vertical: false)
                if horizontalTextAlignment == "Left" { Spacer() }
            }
            .frame(width: self.size.width, height: self.size.height)
            .clipShape(Rectangle())
            .position(self.location)
        )
    }
    
    override func useElipsisIfSizeTooSmall() {
    }
    
}
