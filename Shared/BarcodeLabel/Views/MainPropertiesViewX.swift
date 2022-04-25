//
//  MainSheetViewX.swift
//
//
//  Created by  on 21/4/22.
//

import SwiftUI

@available(iOS 15.0, *)
struct MainPropertiesViewX: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
   
    @EnvironmentObject var optionSettings: OptionSettings
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var pageSettings: PageSettings
    @EnvironmentObject var shapes: ShapesX
    
    var body: some View {
        VStack{
            
            if optionSettings.showPropertiesView == 2
            {
                ForEach(shapes.shapeList){
                    shape in
                    if shape.isSelected == true && shape is TextX
                    {
                        TextPropertiesViewX(textPropertiesViewModel:  TextPropertiesViewModel(shapes: shapes))
                    }
                }
            }
            else if optionSettings.showPropertiesView == 3
            {
                ForEach(shapes.shapeList){
                    shape in
                    if shape.isSelected == true && (shape is RectangleX || shape is EllipseX)
                    {
                        ShapePropertiesViewX(shapePropertiesViewModel: ShapePropertiesViewModel(shapes: shapes))
                    }
                }
            }
            else if optionSettings.showPropertiesView == 5
            {
                ForEach(shapes.shapeList){
                    shape in
                    if shape.isSelected == true && shape is BarcodeX
                    {
                        BarcodePropertiesViewX(barcodePropertiesViewModel:  BarcodePropertiesViewModel(shapes: shapes))
                    }
                }
            }
            else if optionSettings.showPropertiesView == 6
            {
                ForEach(shapes.shapeList){
                    shape in
                    if shape.isSelected == true && shape is ImageX
                    {
                        ImagePropertiesViewX(imagePropertiesViewModel:  ImagePropertiesViewModel(shapes: shapes))
                    }
                }
            }
            else
            {
                VStack (alignment: .trailing)
                {
                    HStack{
                        LabelToolbarViewX()
                    }.frame(height: horizontalSizeClass == .regular && verticalSizeClass == .regular ? 85 : 85)
              
                }.frame(height: horizontalSizeClass == .regular && verticalSizeClass == .regular ? 85 : 85)
            }
            

            //Spacer() //for toolbar push up
        }
        .frame(height: (optionSettings.showPropertiesView != 0 ? 280 :
                       (horizontalSizeClass == .regular && verticalSizeClass == .regular ? 85 : 85))) //so as to extend beyond the bottomn toolbar

    }
}
