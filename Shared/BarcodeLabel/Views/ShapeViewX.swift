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



struct ShapeViewX: View {
    @ObservedObject var shape: ShapeX
    @Binding var showPropertiesView: Int
 
    @GestureState private var startLocation: CGPoint? = nil
    @GestureState private var startSize: CGSize? = nil
    @State private var tapped = false
    
    @EnvironmentObject var shapes: ShapesX
    @EnvironmentObject var optionSettings: OptionSettings
    var simpleDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                print("dragChange")
                var newLocation = startLocation ?? self.shape.location
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                if newLocation.x <= shape.canvasSize.width
                    && newLocation.x >= 0
                    && newLocation.y <= shape.canvasSize.height
                    && newLocation.y >= 0
                {
                    self.shape.location = newLocation
                }
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? self.shape.location
                print("dragUpdating")
            }
    }
    
    var resizeDrag1: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                var selectedShape: ShapeX = ShapeX()
                shapes.shapeList.forEach
                {
                   if ($0.isSelected == true)
                   {
                       selectedShape=$0
                   }
                }
                if selectedShape.location.x == self.shape.location.x &&
                    selectedShape.location.y == self.shape.location.y
                {
                    var newSize = startSize ?? self.shape.size
                    print("os:",newSize.width,":",newSize.height)
                    newSize.width += value.translation.width
                    newSize.height += value.translation.height
                    if (newSize.width>=2 && newSize.height>=2)
                    {
                        print("ns:",newSize.width,":",newSize.height)
                        var newLocation = startLocation ?? self.shape.location
                        print("ox:",newLocation.x)
                        newLocation.x += value.translation.width/2
                        newLocation.y += value.translation.height/2
                        print("tw:",value.translation.width,"nx:",newLocation.x)

                        if newLocation.x <= shape.canvasSize.width
                            && newLocation.x >= 0
                            && newLocation.y <= shape.canvasSize.height
                            && newLocation.y >= 0
                            && newSize.height <= shape.canvasSize.height - 20
                            && newSize.width <= shape.canvasSize.width - 20
                        {
                            if newSize.width < 80.0
                            {
                                newSize.width = 80.0
                            }
                            if newSize.height < 80.0
                            {
                                newSize.height = 80.0
                            }
                            self.shape.size = newSize
                            self.shape.location = newLocation
                            self.shape.useElipsisIfSizeTooSmall()
                        }
                        
                    }
                }
                
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? self.shape.location
            }.updating($startSize) { (value, startSize, transaction) in
                startSize = startSize ?? self.shape.size
                //print("resize Center updating:",startSize)
            }
    }
    
    var tap: some Gesture {
        TapGesture(count: 1)
            .onEnded { _ in
                shapes.shapeList.forEach
                {
                        $0.isSelected = false
                }
                self.shape.isSelected = true
                self.showPropertiesView=0
            }
    }
    
    @State private var showingAlert = false
    
    var body: some View {
        
        ZStack
        {
            Rectangle()
                .fill(Color.gray)
                .opacity(self.shape.isSelected ? 0.2 : 0)
                .frame(width: self.shape.size.width, height: self.shape.size.height)
                .position(self.shape.location)

            self.shape.view()

            Rectangle()
                .fill(Color.white)
                .opacity(0.001)
                .frame(width: self.shape.size.width, height: self.shape.size.height)
                .position(self.shape.location)
                .gesture(
                    simpleDrag
                ).allowsHitTesting(self.shape.isSelected ? true : false)
            
            Rectangle()
                .fill(Color.white)
                .opacity(0.001)
                .frame(width: self.shape.size.width, height: self.shape.size.height)
                .position(self.shape.location)
                .gesture(
                    tap
                ).allowsHitTesting(self.shape.isSelected ? false : true)


            Image(systemName: "i.circle")
                .font(.system(size: 40))
                .foregroundColor(Color.white)
                .frame(width: 44, height: 44)
                .background(Color.green)
                .clipShape(Circle())
                .opacity(self.shape.isSelected ? 1 : 0)
                .position(CGPoint(x: self.shape.location.x+self.shape.size.width/2, y: self.shape.location.y-self.shape.size.height/2))
            
            Rectangle()
                .foregroundColor(Color.white)
                .frame(width: 80, height: 80)
                .background(Color.white)
                .opacity(0.01)
                .position(CGPoint(x: self.shape.location.x+self.shape.size.width/2+10, y: self.shape.location.y-self.shape.size.height/2-10))
                .onTapGesture {
                    
                    var selectedShape: ShapeX = ShapeX()
                    shapes.shapeList.forEach
                    {
                       if ($0.isSelected == true)
                       {
                           selectedShape=$0
                       }
                    }
                    if selectedShape.location.x == self.shape.location.x &&
                        selectedShape.location.y == self.shape.location.y
                    {
                        if shape is TextX
                        {
                            showPropertiesView=2
                        }
                        else if shape is RectangleX
                        {
                            showPropertiesView=3
                        }
                        else if shape is EllipseX
                        {
                            showPropertiesView=3
                        }
                        else if shape is BarcodeX
                        {
                            showPropertiesView=5
                        }
                        else if shape is ImageX
                        {
                            showPropertiesView=6

                            /*
                            showPropertiesView=0
                            optionSettings.action = "EditImage"
                            optionSettings.showPropertiesSheet = true
                             */
                        }
                    }
                }
            

            //tap for delete
            Image(systemName: "multiply.circle")
                .font(.system(size: 40))
                .foregroundColor(Color.white)
                .frame(width: 44, height: 44)
                //.background(showPropertiesView == 2 ? Color.gray : Color.pink)
                .background(showPropertiesView == 0 ? Color.pink : Color.gray)
                .clipShape(Circle())
                .opacity(self.shape.isSelected ? 1 : 0)
                .position(CGPoint(x: self.shape.location.x-self.shape.size.width/2, y: self.shape.location.y-self.shape.size.height/2))

            Rectangle()
                .foregroundColor(Color.white)
                .frame(width: 80, height: 80)
                .background(Color.white)
                .opacity(0.01)
                .position(CGPoint(x: self.shape.location.x-self.shape.size.width/2-10, y: self.shape.location.y-self.shape.size.height/2-10))
                .onTapGesture
                { 


                    //if showPropertiesView != 2{
                    if showPropertiesView == 0 {
                         var deleteShape: ShapeX = ShapeX()
                        shapes.shapeList.forEach
                        {
                            if ($0.isSelected == true)
                            {
                                print("set false")
                                $0.isSelected = false
                                deleteShape=$0
                                
         
                            }
                        }
                        showPropertiesView=0
                        
                        if deleteShape.location.x == self.shape.location.x &&
                           deleteShape.location.y == self.shape.location.y
                        {
                            if let x = shapes.shapeList.firstIndex(of: deleteShape)
                            {
                                print("x:",x)
                                shapes.shapeList.remove(at: x)
                            }
                        }
                    }

                }

            
            //tap for resize
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 24))
                .foregroundColor(Color.white)
                .frame(width: 44, height: 44)
                .background(Color.blue)
                .clipShape(Circle())
                .opacity(self.shape.isSelected ? 1 : 0)
                .position(CGPoint(x: self.shape.location.x+self.shape.size.width/2, y: self.shape.location.y+self.shape.size.height/2))
            
           Rectangle()
            .foregroundColor(Color.white)
            .frame(width: 80, height: 80)
            .background(Color.white)
            .opacity(0.01)
            .position(CGPoint(x: self.shape.location.x+self.shape.size.width/2+10, y: self.shape.location.y+self.shape.size.height/2+10))
                .gesture(
                    resizeDrag1
                )

        }
        .frame(width:shape.canvasSize.width, height:shape.canvasSize.height)
        .zIndex(self.shape.zIndex)
        
    }

    
}
