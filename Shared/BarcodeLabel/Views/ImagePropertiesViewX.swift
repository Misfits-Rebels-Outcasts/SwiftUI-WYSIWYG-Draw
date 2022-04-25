//
//  ShapePropertiesX.swift
//
//
//  Created by  on 25/3/22.
//


import SwiftUI

struct ImagePropertiesViewX: View {

    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
     @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @EnvironmentObject var optionSettings: OptionSettings
    @EnvironmentObject var shapes: ShapesX
    @StateObject var imagePropertiesViewModel: ImagePropertiesViewModel
    var body: some View {


        NavigationView {
            Form {

                DimensionsPropertiesViewX(objectPropertiesViewModel:  imagePropertiesViewModel)
                
            }
            .navigationTitle("Image")
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
        imagePropertiesViewModel.setupSelectedProperties()

    }
}

