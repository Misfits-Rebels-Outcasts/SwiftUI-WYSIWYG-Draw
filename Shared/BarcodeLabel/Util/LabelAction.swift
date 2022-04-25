/*
Copyright 2022 barcoderesource.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
class LabelAction
{
    let pageSettings: PageSettings
    let shapes: ShapesX
    
    init(shapes: ShapesX, pageSettings: PageSettings) {
       self.shapes = shapes
       self.pageSettings = pageSettings
    }

    func generate() -> String{
        let encoder=JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let shapesData = (try? encoder.encode(shapes))!
        let shapesDataStr = String(data: shapesData, encoding: .utf8)!
        let pageSettingsData = (try? encoder.encode(pageSettings))!
        let pageSettingsDataStr = String(data: pageSettingsData, encoding: .utf8)!
        
        var jsonObject: [String: String] = [String: String]()
        
        jsonObject["page_settings"]=pageSettingsDataStr
        jsonObject["shapes"]=shapesDataStr
        
        if let jsonData = try? encoder.encode(jsonObject) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                //print(jsonString)

                var jsonLabel: [String: String] = [String: String]()
                jsonLabel["label"]=jsonString
                
                if let jsonLabelData = try? encoder.encode(jsonLabel) {
                    if let jsonLabelString = String(data: jsonLabelData, encoding: .utf8) {
                                             
                        return jsonLabelString
                
                    }
                }
                
            }
        }
        
        return ""
    }
    
    func load(jsonLabelStr: String)
    {
        if let data = jsonLabelStr.data(using: .utf8) {
                //do {
                    let labelDictionary : [String: Any] = (try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])!
                    let labelStr = labelDictionary["label"] as? String
                    
                    if let attributesData = labelStr!.data(using: .utf8) {
                        let attributesDictionary : [String: Any] = (try? JSONSerialization.jsonObject(with: attributesData, options: []) as? [String: Any])!
                        let loadedPageSettingsStr = attributesDictionary["page_settings"] as? String
                        let loadedPageSettings = (try? JSONDecoder().decode(PageSettings.self, from: loadedPageSettingsStr!.data(using: .utf8)!))!
                        let loadedShapesStr = attributesDictionary["shapes"] as? String
                        let loadedShapes = (try? JSONDecoder().decode(ShapesX.self, from: loadedShapesStr!.data(using: .utf8)!))!
                        pageSettings.dpi=loadedPageSettings.dpi
                        pageSettings.name=loadedPageSettings.name
                        pageSettings.category=loadedPageSettings.category
                        pageSettings.vendor=loadedPageSettings.vendor
                        pageSettings.description=loadedPageSettings.description
                        pageSettings.type=loadedPageSettings.type
                        pageSettings.pageWidth=loadedPageSettings.pageWidth
                        pageSettings.pageHeight=loadedPageSettings.pageHeight
                        pageSettings.labelWidth=loadedPageSettings.labelWidth
                        pageSettings.labelHeight=loadedPageSettings.labelHeight
                        pageSettings.leftMargin=loadedPageSettings.leftMargin
                        pageSettings.topMargin=loadedPageSettings.topMargin
                        pageSettings.labelWidth=loadedPageSettings.labelWidth
                        pageSettings.hSpace=loadedPageSettings.hSpace
                        pageSettings.vSpace=loadedPageSettings.vSpace
                        pageSettings.numRows=loadedPageSettings.numRows
                        pageSettings.numCols=loadedPageSettings.numCols
                        pageSettings.dpi=loadedPageSettings.dpi
                        
                        shapes.shapeList=loadedShapes.shapeList
                        pageSettings.generateLabels() //File Open
                        
                        print("loadedPageSettings:",loadedPageSettings.name,":",loadedPageSettings.numRows,":",loadedPageSettings.numCols)
                                                
                    }
                    
                //} catch {
                //    print(error.localizedDescription)
                //}
            }
        

    }
}
