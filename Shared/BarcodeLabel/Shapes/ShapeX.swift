/*
Copyright 2022 barcoderesource.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/*
 https://www.barcoderesource.com/barcodelabelappleapp.shtml
 
 https://www.barcoderesource.com/swiftui_view_vector_draw_wysiwyg.shtml
*/

import SwiftUI

class ShapeX: Codable, ObservableObject, Identifiable, Equatable {
    static func == (lhs: ShapeX, rhs: ShapeX) -> Bool {
        return lhs.id==rhs.id
    }
    
    var id = UUID()

    @Published var dpi = 300.0
    @Published var type: String = ""
    @Published var location: CGPoint = CGPoint(x: 50, y: 50)
    @Published var size: CGSize = CGSize(width: 100, height: 100)
    @Published var canvasSize: CGSize = CGSize(width: 1, height: 1)
    @Published var isSelected = false
    @Published var zIndex = 0.0

    var width: Float = 0.0
    var height: Float = 0.0
    
    init()
    {
        
    }
    init(_ dpi:Double, _ type: String, _ location: CGPoint, _ size: CGSize, _ canvasSize: CGSize, _ isSelected: Bool) {
        self.dpi=dpi
        self.type=type
        self.location=location
        self.size=size
        self.canvasSize=canvasSize
        self.isSelected = isSelected
    }
    
    func useElipsisIfSizeTooSmall() {

    }
    
    func view() -> AnyView {
        AnyView(EmptyView())
    }
    
    enum CodingKeys: String, CodingKey {
      case dpi
      case type
      case location
      case size
      case canvasSize
      case isSelected
      case zIndex
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dpi = try values.decodeIfPresent(Double.self, forKey: .dpi) ?? 300.0
        type = try values.decodeIfPresent(String.self, forKey: .type) ?? ""
        location = try values.decodeIfPresent(CGPoint.self, forKey: .location) ?? CGPoint(x: 50, y: 50)
        size = try values.decodeIfPresent(CGSize.self, forKey: .size) ?? CGSize(width: 100, height: 100)
        canvasSize = try values.decodeIfPresent(CGSize.self, forKey: .canvasSize) ?? CGSize(width: 1, height: 1)
        isSelected = try values.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
        zIndex = try values.decodeIfPresent(Double.self, forKey: .zIndex) ?? 0
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(dpi, forKey: .dpi)
      try container.encode(type, forKey: .type)
      try container.encode(location, forKey: .location)
      try container.encode(size, forKey: .size)
      try container.encode(canvasSize, forKey: .canvasSize)
      try container.encode(isSelected, forKey: .isSelected)
      try container.encode(zIndex, forKey: .zIndex)
    }
    
}
