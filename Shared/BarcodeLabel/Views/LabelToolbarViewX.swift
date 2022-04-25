//
//  LaeblToolbarView.swift
//
//
//  Created by  on 17/3/22.
//

import SwiftUI
@available(iOS 15.0, *)
struct LabelToolbarViewX: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var optionSettings: OptionSettings
    @EnvironmentObject var pageSettings: PageSettings
    @EnvironmentObject var shapes: ShapesX
    @State private var showingAlert = false

    @State var measurementUnit : String = "Inches"
    
    var body: some View {


        Spacer()

        Button(action: {
            appSettings.zoomingOrScrollX = "zoomOut"
            appSettings.zoomingOrScrollY = "zoomOut"
            
            appSettings.zoomFactor = appSettings.zoomFactor - appSettings.zoomFactor * 0.1
            print(appSettings.zoomFactor)
            appSettings.zoomFactor  = appSettings.zoomFactor < 0.1 ? 0.1 : appSettings.zoomFactor
        }) {
            Image(systemName: "minus.magnifyingglass")
                .font(.system(size: 28))
                .foregroundColor(colorScheme == .dark ? Color(UIColor(red: 0.9569, green: 0.9569, blue: 0.9569, alpha: 0.5) ) : Color.black)
        }
        
        Spacer()
        Menu {

            Button(action: {
                self.shapes.shapeList.forEach
                {
                    if $0.isSelected == true {
                                      
                        var w=595.0, h=265.0
                        w = w < pageSettings.labelWidth*appSettings.dpi ? w : pageSettings.labelWidth*appSettings.dpi - 50.0
                        h = h < pageSettings.labelHeight*appSettings.dpi ? h : pageSettings.labelHeight*appSettings.dpi - 50.0
                        w = w < 30 ? 30 : w
                        h = h < 30 ? 30 : h
                        
                        if $0 is RectangleX
                        {
                            shapes.deSelectAll();
                            
                            let shape = RectangleX(
                                    appSettings.dpi,
                                    CGPoint(x:pageSettings.labelWidth*appSettings.dpi/2,y:pageSettings.labelHeight*appSettings.dpi/2),
                                    CGSize(width: w, height: h),
                                    CGSize(width: pageSettings.labelWidth*appSettings.dpi, height: pageSettings.labelHeight*appSettings.dpi),
                                    true)
                            
                            let selectedShape = $0 as! RectangleX
                            shape.type = selectedShape.type
                            if selectedShape.location.x + 20 <= selectedShape.canvasSize.width
                            {
                                shape.location.x = selectedShape.location.x + 20
                            }
                            else
                            {
                                shape.location.x = selectedShape.location.x
                            }
                            if selectedShape.location.y + 20 <= selectedShape.canvasSize.height
                            {
                                shape.location.y = selectedShape.location.y + 20
                            }
                            else
                            {
                                shape.location.y = selectedShape.location.y
                            }
                            shape.size = selectedShape.size
                            shape.canvasSize = selectedShape.canvasSize
                            shape.isSelected = true
                            shape.zIndex = selectedShape.zIndex
                            
                            shape.strokeWidth = selectedShape.strokeWidth
                            shape.strokeColor = selectedShape.strokeColor
                            shape.fillColor = selectedShape.fillColor
                            selectedShape.isSelected = false

                            shapes.add(shape: shape)
                        }
                        else if $0 is EllipseX
                        {
                            shapes.deSelectAll();
                            
                            let shape = EllipseX(
                                    appSettings.dpi,
                                    CGPoint(x:pageSettings.labelWidth*appSettings.dpi/2,y:pageSettings.labelHeight*appSettings.dpi/2),
                                    CGSize(width: w, height: h),
                                    CGSize(width: pageSettings.labelWidth*appSettings.dpi, height: pageSettings.labelHeight*appSettings.dpi),
                                    true)
                            
                            let selectedShape = $0 as! EllipseX
                            shape.type = selectedShape.type
                            if selectedShape.location.x + 20 <= selectedShape.canvasSize.width
                            {
                                shape.location.x = selectedShape.location.x + 20
                            }
                            else
                            {
                                shape.location.x = selectedShape.location.x
                            }
                            if selectedShape.location.y + 20 <= selectedShape.canvasSize.height
                            {
                                shape.location.y = selectedShape.location.y + 20
                            }
                            else
                            {
                                shape.location.y = selectedShape.location.y
                            }
                            shape.size = selectedShape.size
                            shape.canvasSize = selectedShape.canvasSize
                            shape.isSelected = true
                            shape.zIndex = selectedShape.zIndex
                            
                            shape.strokeWidth = selectedShape.strokeWidth
                            shape.strokeColor = selectedShape.strokeColor
                            shape.fillColor = selectedShape.fillColor
                            selectedShape.isSelected = false

                            shapes.add(shape: shape)
                        }
                        else if $0 is TextX
                        {
                            
                            shapes.deSelectAll();
                            
                            let shape = TextX(
                                    appSettings.dpi,
                                    CGPoint(x:pageSettings.labelWidth*appSettings.dpi/2,y:pageSettings.labelHeight*appSettings.dpi/2),
                                    CGSize(width: w, height: h),
                                    CGSize(width: pageSettings.labelWidth*appSettings.dpi, height: pageSettings.labelHeight*appSettings.dpi),
                                    true)
                            
                            let selectedShape = $0 as! TextX
                            shape.type = selectedShape.type
                            if selectedShape.location.x + 20 <= selectedShape.canvasSize.width
                            {
                                shape.location.x = selectedShape.location.x + 20
                            }
                            else
                            {
                                shape.location.x = selectedShape.location.x
                            }
                            if selectedShape.location.y + 20 <= selectedShape.canvasSize.height
                            {
                                shape.location.y = selectedShape.location.y + 20
                            }
                            else
                            {
                                shape.location.y = selectedShape.location.y
                            }
                            shape.size = selectedShape.size
                            shape.canvasSize = selectedShape.canvasSize
                            shape.isSelected = true
                            shape.zIndex = selectedShape.zIndex

                            shape.fontSize = selectedShape.fontSize
                            shape.text = selectedShape.text
                            shape.originalText = selectedShape.originalText
                            shape.fontName = selectedShape.fontName
                            shape.textColor = selectedShape.textColor
                            shape.horizontalTextAlignment = selectedShape.horizontalTextAlignment
                            selectedShape.isSelected = false

                            shapes.add(shape: shape)
                            
                         
                        }
                        else if $0 is BarcodeX
                        {
                            shapes.deSelectAll();
                            let shape = BarcodeX(
                                    appSettings.dpi,
                                    CGPoint(x:pageSettings.labelWidth*appSettings.dpi/2,y:pageSettings.labelHeight*appSettings.dpi/2),
                                    CGSize(width: w, height: h),
                                    CGSize(width: pageSettings.labelWidth*appSettings.dpi, height: pageSettings.labelHeight*appSettings.dpi),
                                    true)
                            let selectedShape = $0 as! BarcodeX
                            shape.type = selectedShape.type
                            if selectedShape.location.x + 20 <= selectedShape.canvasSize.width
                            {
                                shape.location.x = selectedShape.location.x + 20
                            }
                            else
                            {
                                shape.location.x = selectedShape.location.x
                            }
                            if selectedShape.location.y + 20 <= selectedShape.canvasSize.height
                            {
                                shape.location.y = selectedShape.location.y + 20
                            }
                            else
                            {
                                shape.location.y = selectedShape.location.y
                            }
                            shape.size = selectedShape.size
                            shape.canvasSize = selectedShape.canvasSize
                            shape.isSelected = true
                            shape.zIndex = selectedShape.zIndex
                            shape.checkDigit = selectedShape.checkDigit
                            shape.symbology = selectedShape.symbology
                            shape.fontSize = selectedShape.fontSize
                            shape.input = selectedShape.input
                            shape.symbology = selectedShape.symbology
                            shape.checkDigit = selectedShape.checkDigit
                            shape.barcode = selectedShape.barcode
                            shape.humanReadableText = selectedShape.humanReadableText
                            shape.fontName = selectedShape.fontName
                            shape.textColor = selectedShape.textColor
                            shape.horizontalTextAlignment = selectedShape.horizontalTextAlignment
                            shape.hrFontName = selectedShape.hrFontName
                            shape.hrTextColor = selectedShape.hrTextColor
                            shape.hrFontSize = selectedShape.hrFontSize
                            selectedShape.isSelected = false
                            shapes.add(shape: shape)
                        }
                        else if $0 is ImageX
                        {
                            shapes.deSelectAll();
                            
                            let shape = ImageX(
                                    appSettings.dpi,
                                    CGPoint(x:pageSettings.labelWidth*appSettings.dpi/2,y:pageSettings.labelHeight*appSettings.dpi/2),
                                    CGSize(width: w, height: h),
                                    CGSize(width: pageSettings.labelWidth*appSettings.dpi, height: pageSettings.labelHeight*appSettings.dpi),
                                    true)
                            
                            let selectedShape = $0 as! ImageX
                            shape.type = selectedShape.type
                            if selectedShape.location.x + 20 <= selectedShape.canvasSize.width
                            {
                                shape.location.x = selectedShape.location.x + 20
                            }
                            else
                            {
                                shape.location.x = selectedShape.location.x
                            }
                            if selectedShape.location.y + 20 <= selectedShape.canvasSize.height
                            {
                                shape.location.y = selectedShape.location.y + 20
                            }
                            else
                            {
                                shape.location.y = selectedShape.location.y
                            }
                            shape.size = selectedShape.size
                            shape.canvasSize = selectedShape.canvasSize
                            shape.isSelected = true
                            shape.zIndex = selectedShape.zIndex
                            
                            UIGraphicsBeginImageContext(selectedShape.image.size)
                            selectedShape.image.draw(in: CGRect(x: 0, y: 0, width: selectedShape.image.size.width, height: selectedShape.image.size.height))
                            let copy = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                            shape.image=copy!
                            selectedShape.isSelected = false
                            shapes.add(shape: shape)
                            
                        }
                    }
                    
                }
                
            }) {
                Label("Duplicate", systemImage: "doc.on.clipboard.fill")
            }
        
            
            Button(action: {
                var w=200.0, h=100.0
                w = w < pageSettings.labelWidth*appSettings.dpi ? w : pageSettings.labelWidth*appSettings.dpi - 50.0
                h = h < pageSettings.labelHeight*appSettings.dpi ? h : pageSettings.labelHeight*appSettings.dpi - 50.0
                w = w < 30 ? 30 : w
                h = h < 30 ? 30 : h
                print(w,":",h)
                shapes.deSelectAll();
                
                let shape = EllipseX(
                        appSettings.dpi,
                        CGPoint(x:pageSettings.labelWidth*appSettings.dpi/2,y:pageSettings.labelHeight*appSettings.dpi/2),
                        CGSize(width: w, height: h),
                        CGSize(width: pageSettings.labelWidth*appSettings.dpi, height: pageSettings.labelHeight*appSettings.dpi),
                        true)
                
                shapes.add(shape: shape)
            }) {
                Label("Add Ellipse", systemImage: "circle")
            }

            Button(action: {
                shapes.deSelectAll();
                
                //var w=2000.0, h=1000.0
                var w=200.0, h=100.0
                w = w < pageSettings.labelWidth*appSettings.dpi ? w : pageSettings.labelWidth*appSettings.dpi - 50.0
                h = h < pageSettings.labelHeight*appSettings.dpi ? h : pageSettings.labelHeight*appSettings.dpi - 50.0
                w = w < 30 ? 30 : w
                h = h < 30 ? 30 : h
                print(w,":",h)
                
                let shape = RectangleX(
                        appSettings.dpi,
                        CGPoint(x:pageSettings.labelWidth*appSettings.dpi/2,y:pageSettings.labelHeight*appSettings.dpi/2),
                        CGSize(width: w, height: h),
                        CGSize(width: pageSettings.labelWidth*appSettings.dpi, height: pageSettings.labelHeight*appSettings.dpi),
                        true)
                
                shapes.add(shape: shape)
            }) {
                Label("Add Rectangle", systemImage: "rectangle")
            }

            Button(action: {
                
                var w=300/2.0, h=300/2.0
                w = w < pageSettings.labelWidth*appSettings.dpi ? w : pageSettings.labelWidth*appSettings.dpi - 50.0
                h = h < pageSettings.labelHeight*appSettings.dpi ? h : pageSettings.labelHeight*appSettings.dpi - 50.0
                w = w < 30 ? 30 : w
                h = h < 30 ? 30 : h
                print(w,":",h)
                
                shapes.deSelectAll();
                let shape = ImageX(
                        appSettings.dpi,
                        CGPoint(x:pageSettings.labelWidth*appSettings.dpi/2,y:pageSettings.labelHeight*appSettings.dpi/2),
                        CGSize(width: w, height: h),
                        CGSize(width: pageSettings.labelWidth*appSettings.dpi, height: pageSettings.labelHeight*appSettings.dpi),
                        true)
                
                shapes.add(shape: shape)
 
                
                optionSettings.action = "NewImage"
                optionSettings.showPropertiesSheet = true
            }) {
                Label("Add Image", systemImage: "photo")
            }

            Button(action: {
                var w=200.0, h=100.0
                w = w < pageSettings.labelWidth*appSettings.dpi ? w : pageSettings.labelWidth*appSettings.dpi - 50.0
                h = h < pageSettings.labelHeight*appSettings.dpi ? h : pageSettings.labelHeight*appSettings.dpi - 50.0
                w = w < 30 ? 30 : w
                h = h < 30 ? 30 : h
                print(w,":",h)

                
                shapes.deSelectAll();
                
                let shape = TextX(
                        appSettings.dpi,
                        CGPoint(x:pageSettings.labelWidth*appSettings.dpi/2,y:pageSettings.labelHeight*appSettings.dpi/2),
                        CGSize(width: w, height: h),
                        CGSize(width: pageSettings.labelWidth*appSettings.dpi, height: pageSettings.labelHeight*appSettings.dpi),
                        true)
                
                shapes.add(shape: shape)
            }) {
                Label("Add Text", systemImage: "textformat.abc")
            }

            Button(action: {
                
                var w=595.0*pageSettings.dpi/300.0, h=265.0*pageSettings.dpi/300.0
                w = w < pageSettings.labelWidth*appSettings.dpi ? w : pageSettings.labelWidth*appSettings.dpi - 50.0
                h = h < pageSettings.labelHeight*appSettings.dpi ? h : pageSettings.labelHeight*appSettings.dpi - 50.0
                w = w < 30*pageSettings.dpi/300.0 ? 30*pageSettings.dpi/300.0 : w
                h = h < 30*pageSettings.dpi/300.0 ? 30*pageSettings.dpi/300.0 : h

                print(w,":",h)

                shapes.deSelectAll();
                
                let shape = BarcodeX(
                        appSettings.dpi,
                        CGPoint(x:pageSettings.labelWidth*appSettings.dpi/2,y:pageSettings.labelHeight*appSettings.dpi/2),
                        //CGSize(width: 250, height: 100),
                        CGSize(width: w, height: h),
                        CGSize(width: pageSettings.labelWidth*appSettings.dpi, height: pageSettings.labelHeight*appSettings.dpi),
                        true)
                
                shapes.add(shape: shape)
            }) {
                Label("Add Barcode", systemImage: "barcode")
            }
            
        }
        label: {
            HStack {
                //Label("Add", systemImage: "plus.circle")
                //    .font(.system(size: 22)).foregroundColor(Color.black)
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(colorScheme == .dark ? Color(UIColor(red: 0.9569, green: 0.9569, blue: 0.9569, alpha: 0.5) ) : Color.black)
                //Text("Add")
                //    .font(.system(size: 22)).foregroundColor(Color.black)
            }
        }
        Spacer()

        Button(action: {
            appSettings.zoomingOrScrollX = "zoomIn"
            appSettings.zoomingOrScrollY = "zoomIn"
            appSettings.zoomFactor = appSettings.zoomFactor + appSettings.zoomFactor * 0.1
            appSettings.zoomFactor  = appSettings.zoomFactor > 1.0 ? 1.0 : appSettings.zoomFactor
        }) {
            Image(systemName: "plus.magnifyingglass")
                .font(.system(size: 28))
                .foregroundColor(colorScheme == .dark ? Color(UIColor(red: 0.9569, green: 0.9569, blue: 0.9569, alpha: 0.5) ) : Color.black)                
        }
 
        Spacer()
    }

}
