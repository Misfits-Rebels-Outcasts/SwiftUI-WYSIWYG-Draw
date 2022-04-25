//
//  TextPropertiesView.swift
// (iOS)
//
//  Created by  on 23/4/21.
//

import SwiftUI

struct TextPropertiesViewX: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
     @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @EnvironmentObject var optionSettings: OptionSettings
    @EnvironmentObject var shapes: ShapesX
    @StateObject var textPropertiesViewModel: TextPropertiesViewModel
    @State private var letter = ""
    private let letters = ["Alpha", "Bravo", "Charlie"]
    
    var body: some View {

        NavigationView {
            Form {
                Section(header: Text("Text")){
                          
                    HStack{

                                                
                        TextField("Text", text: $textPropertiesViewModel.text)
                            .onChange(of: textPropertiesViewModel.text) { newValue in
                                
                                self.shapes.shapeList.forEach
                                {
                                    if $0.isSelected == true {
                                        let selectedText = $0 as! TextX
                                        
                                        if newValue.count > 200
                                        {
                                            selectedText.text = String(newValue.prefix(200))
                                        }
                                        else{
                                            selectedText.text = newValue
                                        }
                   
                                    }
                                }
                            }
                            //.padding(5).textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                Section(header: Text("Font")){
                    
                    Picker("Name", selection: $textPropertiesViewModel.fontName) {
                        ForEach(fontNames, id: \.self) {
                            Text($0)
                        }
                    }
                    .onChange(of: textPropertiesViewModel.fontName) { newValue in
                        self.shapes.shapeList.forEach
                        {
                            if $0.isSelected == true {
                                let selectedText = $0 as! TextX
                                selectedText.fontName = newValue
                            }
                        }
                    }
                    HStack{
                        Text("Color")
                        Spacer()
                        ColorPicker("", selection: $textPropertiesViewModel.textColor, supportsOpacity: false)
                          .onChange(of: textPropertiesViewModel.textColor) { newValue in
                              
                              self.shapes.shapeList.forEach
                              {
                                  if $0.isSelected == true {
                                      let selectedText = $0 as! TextX
                                      selectedText.textColor = newValue
                                  }
                              }
                          }.frame(width:100, height:30, alignment: .trailing)
                    }
                    HStack{
                        Text("Size")
                        Spacer()
          

                        Text("\(Int(textPropertiesViewModel.fontSize * 72.0/300.0))")

                    }
                    Slider(value: $textPropertiesViewModel.fontSize, in: 10...600 )
                        .onChange(of: textPropertiesViewModel.fontSize) { newValue in
                            self.shapes.shapeList.forEach
                            {
                                if $0.isSelected == true {
                                    let selectedText = $0 as! TextX
                                    selectedText.fontSize = newValue

                                }
                            }
                        }
                    //Spacer()
                }
                Section(header: Text("Horizontal Text Alignment")){
                    Picker("Text Alignment", selection: $textPropertiesViewModel.alignment) {
                        Label("Left", systemImage: "align.horizontal.left")
                            .labelStyle(.iconOnly)
                            .tag("Left")
                        Label("Center", systemImage: "align.horizontal.center")
                            .labelStyle(.iconOnly)
                            .tag("Center")
                        Label("Right", systemImage: "align.horizontal.right")
                            .labelStyle(.iconOnly)
                            .tag("Right")
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: textPropertiesViewModel.alignment) { newValue in
                        self.shapes.shapeList.forEach
                        {
                            if $0.isSelected == true {
                                let selectedText = $0 as! TextX
                                selectedText.horizontalTextAlignment = newValue
                            }
                        }
                    }
                }


                DimensionsPropertiesViewX(objectPropertiesViewModel:  textPropertiesViewModel)
             
                
            }
            .navigationTitle("Text")
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
        textPropertiesViewModel.setupSelectedProperties()

    }
    
}

