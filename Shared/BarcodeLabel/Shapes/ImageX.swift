/*
Copyright 2022 barcoderesource.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import SwiftUI

//image orientation
//https://stackoverflow.com/questions/42098390/swift-png-image-being-saved-with-incorrect-orientation
class ImageX: ShapeX {
    @Published var image: UIImage = UIImage(named: "LabelImage")!
        
    init(_ dpi:Double, _ location: CGPoint, _ size: CGSize, _ canvasSize: CGSize, _ isSelected: Bool) {
        super.init(dpi,"Image",location,size,canvasSize,isSelected)
        print(location)
        print(size)
        print(canvasSize)
        print(isSelected)
    }

    enum CodingKeys : String, CodingKey {
      case image
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
      
        let data = try container.decodeIfPresent(String.self, forKey: .image) ?? nil
        if data != nil
        {
            //https://stackoverflow.com/questions/11251340/convert-between-uiimage-and-base64-string
            self.image = convertBase64StringToImage(imageBase64String:data!)
        }
      }

    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(convertImageToBase64String(img:image), forKey: .image)

      }

    override func view() -> AnyView {
        AnyView(
            Image(uiImage: image)
                .resizable()
                .frame(width: self.size.width, height: self.size.height)
                .position(self.location))
        }
}
