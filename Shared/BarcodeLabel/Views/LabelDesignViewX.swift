//
//  LabelDesignView.swift
//
//
//  Created by  on 16/3/22.
//

import SwiftUI
@available(macOS 12.0, *)
@available(iOS 15.0, *)
struct LabelDesignViewX: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
 
    @State private var offsetX = CGFloat.zero
    @State private var offsetY = CGFloat.zero
    
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var optionSettings: OptionSettings
    @EnvironmentObject var pageSettings: PageSettings
    @EnvironmentObject var shapes: ShapesX
    

    var body: some View {
        
        GeometryReader { geometry in
            VStack(spacing:0){

                RulerHViewX(offsetX: $offsetX, rulerWidth: geometry.size.width)
                    //.frame(width: geometry.size.width, height: 0.37*72.0, alignment: .topLeading)
                    .frame(width: geometry.size.width, height: horizontalSizeClass == .regular && verticalSizeClass == .regular ? 0.4*72.0 : 0.38*72.0, alignment: .topLeading)
                    .border(Color.gray)
                    .padding(0)
                HStack(spacing:0)
                {
                    RulerVViewX(offsetY: $offsetY, rulerHeight: geometry.size.height)
                        //.frame(width: 0.35*72.0, height: geometry.size.height, alignment: .leading)
                        .frame(width: horizontalSizeClass == .regular && verticalSizeClass == .regular ? 0.4*72.0 : 0.38*72.0, height: geometry.size.height, alignment: .leading)
                        .border(Color.gray)
                        .padding(0)
                    VStack(spacing:0){
                        ScrollView([.horizontal, .vertical]) {
                           
                                VStack {
                                    LabelViewX()
                                    .frame(width: pageSettings.labelWidth*appSettings.dpi, height: pageSettings.labelHeight*appSettings.dpi, alignment: .center)
                                    .scaleEffect(appSettings.zoomFactor)
                                }
                                .frame(width: pageSettings.labelWidth*appSettings.dpi*appSettings.zoomFactor, height: pageSettings.labelHeight*appSettings.dpi*appSettings.zoomFactor, alignment: .center)
                                .background(Color.white)
                                .background(GeometryReader {
                                    Color.clear.preference(key: ViewOffsetKeyY.self,
                                        value: $0.frame(in: .named("scroll")).origin.y)
                                    Color.clear.preference(key: ViewOffsetKeyX.self,
                                        value: $0.frame(in: .named("scroll")).origin.x)
                                })
                                .onPreferenceChange(ViewOffsetKeyY.self) { newValue in
        
                                        let rulerThickness = horizontalSizeClass == .regular && verticalSizeClass == .regular ? 0.4*72.0 : 0.38*72.0
                                        let labelHeight = pageSettings.labelHeight*appSettings.dpi*appSettings.zoomFactor
                                        let availableHeight = geometry.size.height - rulerThickness
                                        if offsetY != 0.0 ||
                                            appSettings.zoomingOrScrollY == "scroll" ||
                                            appSettings.zoomingOrScrollY == "zoomIn" ||
                                            (appSettings.zoomingOrScrollY == "zoomOut" &&
                                             offsetY == 0.0 &&
                                             labelHeight <= availableHeight)
                                        {
        
                                            offsetY=newValue//$0
                                            print("assigned new valueY")

                                        }
                                        appSettings.zoomingOrScrollY = "scroll"

                                    //}
                                }
                                .onPreferenceChange(ViewOffsetKeyX.self) { newValue in
              
                                        let rulerThickness = horizontalSizeClass == .regular && verticalSizeClass == .regular ? 0.4*72.0 : 0.38*72.0
                                        let labelWidth = pageSettings.labelWidth*appSettings.dpi*appSettings.zoomFactor
                                        let availableWidth = geometry.size.width - rulerThickness
                                    
                                        if offsetX != 0.0 ||
                                            appSettings.zoomingOrScrollX == "scroll" ||
                                            appSettings.zoomingOrScrollX == "zoomIn" ||
                                            (appSettings.zoomingOrScrollX == "zoomOut" &&
                                             offsetX == 0.0 &&
                                             labelWidth <= availableWidth)
                                        {
                                            offsetX=newValue//$0
                                            print("assigned new valueX")
                                        }
                                        appSettings.zoomingOrScrollX = "scroll"

                                    //}
                                }
                            

                        }
                        .coordinateSpace(name: "scroll")
                        .background(Color.gray)
                        .onTapGesture {
                            shapes.shapeList.forEach
                            {
                                    $0.isSelected = false
                            }
                            
                            optionSettings.showPropertiesView=0
                        }
                        
                    }
                    .frame(height: geometry.size.height, alignment: .leading)

                    
                }.padding(0)
            }
        }
    }
}

struct ViewOffsetKeyY: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct ViewOffsetKeyX: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
