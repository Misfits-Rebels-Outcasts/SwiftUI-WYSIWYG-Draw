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

class ShapesX: Codable, ObservableObject{
    @Published var shapeList = [ShapeX]()

    init() {
        
    }
    
    func deSelectAll() {
        shapeList.forEach
        {
            $0.isSelected = false
        }
    }
    
    func add(shape: ShapeX)
    {
        shapeList.append(shape)
    }
    
    enum CodingKeys: String, CodingKey {
      case shapelist
    }
    
    enum ShapeTypeKey: CodingKey {
       case type
    }

    enum ShapeTypes: String, Decodable {
            case rectangle = "Rectangle"
            case ellipse = "Ellipse"
            case text = "Text"
            case image = "Image"
            case barcode = "Barcode"
    }

    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var shapesArrayForType = try container.nestedUnkeyedContainer(forKey: CodingKeys.shapelist)
        var newShapeList = [ShapeX]()
        var shapesArray = shapesArrayForType

        while(!shapesArrayForType.isAtEnd)
        {

            let shape = try shapesArrayForType.nestedContainer(keyedBy: ShapeTypeKey.self) //causes the
            let type = try shape.decode(ShapeTypes.self, forKey: ShapeTypeKey.type)
  
            switch type {
                case .rectangle:
                    print("found rectangle")
                    newShapeList.append(try shapesArray.decode(RectangleX.self)) //since currentIndex of shapesArray is still at previous location, decode the object
                case .ellipse:
                    print("found ellipse")
                    newShapeList.append(try shapesArray.decode(EllipseX.self))
                case .image:
                    print("found image")
                    newShapeList.append(try shapesArray.decode(ImageX.self))
                case .text:
                    print("found text")
                    newShapeList.append(try shapesArray.decode(TextX.self))
                case .barcode:
                    print("found barcode")
                    newShapeList.append(try shapesArray.decode(BarcodeX.self))
            }
        }
        self.shapeList = newShapeList
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(shapeList, forKey: .shapelist)
    }
}
