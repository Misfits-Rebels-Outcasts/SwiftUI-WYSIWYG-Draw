//
//  ShapePropertiesX.swift
//
//
//  Created by  on 25/3/22.
//


import SwiftUI

struct ShapePropertiesViewX: View {

    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
     @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @EnvironmentObject var optionSettings: OptionSettings
    @EnvironmentObject var shapes: ShapesX
    @StateObject var shapePropertiesViewModel: ShapePropertiesViewModel
    var body: some View {


        NavigationView {
            Form {
 
                
                Section(header: Text("Stroke")){
                    
                    HStack() {
                        Text("Width")
                        Spacer()
                        Text(String(format: "%.0f", round(Double(shapePropertiesViewModel.strokeWidth * 72.0/300.0)+1)))
                        //Text("\(Double(shapePropertiesViewModel.strokeWidth * 72.0/300.0))")
                    }
                    Slider(value: $shapePropertiesViewModel.strokeWidth, in: 0.2*300.0/72.0...29*300.0/72.0)
                        .onChange(of: shapePropertiesViewModel.strokeWidth) { newValue in
                                        //print("sw changed to \(sw)!")
                            //print("change")
                            //print(newValue)
                            shapes.shapeList.forEach
                            {
                                if $0.isSelected == true {
                                    if $0 is RectangleX
                                    {
                                        let selectedRect = $0 as! RectangleX
                                        selectedRect.strokeWidth=newValue
                                    }
                                    else if $0 is EllipseX
                                    {
                                        let selectedRect = $0 as! EllipseX
                                        selectedRect.strokeWidth=newValue
                                    }
                                }
                            }
                        }
                    HStack{
                        Text("Color")
                        Spacer()
                        ColorPicker("", selection: $shapePropertiesViewModel.strokeColor, supportsOpacity: false)
                          .onChange(of: shapePropertiesViewModel.strokeColor) { newValue in
                              
                              self.shapes.shapeList.forEach
                              {
                                  if $0.isSelected == true {
                                      if $0 is RectangleX
                                      {
                                          let selectedRect = $0 as! RectangleX
                                          selectedRect.strokeColor = newValue
                                      }
                                      else if $0 is EllipseX
                                      {
                                          let selectedRect = $0 as! EllipseX
                                          selectedRect.strokeColor = newValue
                                      }
                                  }
                              }
                          }.frame(width:100, height:30, alignment: .trailing)
                    }
                                        
                }
                Section(header: Text("Fill")){
                    
                    HStack{
                        Text("Color")
                        Spacer()
                        ColorPicker("", selection: $shapePropertiesViewModel.fillColor, supportsOpacity: false)
                          .onChange(of: shapePropertiesViewModel.fillColor) { newValue in
                              
                              self.shapes.shapeList.forEach
                              {
                                  if $0.isSelected == true {
                                                                         
                                      if $0 is RectangleX
                                      {
                                          let selectedRect = $0 as! RectangleX
                                          selectedRect.fillColor = newValue
                                      }
                                      else if $0 is EllipseX
                                      {
                                          let selectedRect = $0 as! EllipseX
                                          selectedRect.fillColor = newValue
                                      }
                                  }
                                  
                              }
                          }.frame(width:100, height:30, alignment: .trailing)
                    }
                                        
                }
 
                DimensionsPropertiesViewX(objectPropertiesViewModel:  shapePropertiesViewModel)

                
            }
            .navigationTitle("Shape")
            //.navigationBarTitleDisplayMode(.inline)
            .toolbar {

            }
        }
        .navigationViewStyle(.stack)
        .frame(height:horizontalSizeClass == .regular && verticalSizeClass == .regular ? 400 : 290)
        .onAppear(perform: setupViewModel)
        .padding(.bottom, horizontalSizeClass == .regular && verticalSizeClass == .regular ? 70 : 0)
    }
    
    func setupViewModel()
    {
        shapePropertiesViewModel.setupSelectedProperties()

    }
}

