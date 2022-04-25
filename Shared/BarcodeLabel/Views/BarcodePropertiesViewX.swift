//
//  TextPropertiesView.swift
// (iOS)
//
//  Created by  on 23/4/21.
//

import SwiftUI

struct BarcodePropertiesViewX: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @EnvironmentObject var optionSettings: OptionSettings
    @EnvironmentObject var shapes: ShapesX
    @StateObject var barcodePropertiesViewModel: BarcodePropertiesViewModel

    var body: some View {

        NavigationView {
            Form {
                Section(header: Text("Input")){
                
                    HStack{


                        TextField("Input", text: $barcodePropertiesViewModel.input)
                            .onChange(of: barcodePropertiesViewModel.input) { newValue in
                                
                                self.shapes.shapeList.forEach
                                {
                                    if $0.isSelected == true {
                                        let selectedBarcode = $0 as! BarcodeX
                                        //selectedBarcode.text = String(newValue.prefix(30))
                                        selectedBarcode.input = newValue
                                        encodeBarcode(selectedBarcode: selectedBarcode)

                                    }
                                }
                            }
 
                    }
                    
       
                    
                }
                Section(header: Text("Barcode Options")){
                    Picker("Symbology", selection: $barcodePropertiesViewModel.symbology) {
                        ForEach(barcodeNames, id: \.self) {
                            Text($0)
                        }
                    }
                    .onChange(of: barcodePropertiesViewModel.symbology) { newValue in
                        if barcodePropertiesViewModel.skipOnChange == false
                        {
                            self.shapes.shapeList.forEach
                            {
                                print("symbology on change")
                                if $0.isSelected == true {
                                    let selectedBarcode = $0 as! BarcodeX
                                    selectedBarcode.symbology = newValue
                                    reselectBarcode(selectedBarcode: selectedBarcode)
                                }
                            }
                        }
                        else{
                            barcodePropertiesViewModel.skipOnChange = false
                        }
                    }
                    
                    Toggle("Check Digit", isOn: $barcodePropertiesViewModel.checkDigit)
                        .onChange(of: barcodePropertiesViewModel.checkDigit) { newValue in
                            self.shapes.shapeList.forEach
                            {
                                if $0.isSelected == true {
                                    let selectedBarcode = $0 as! BarcodeX
                                    selectedBarcode.checkDigit = newValue
                                    encodeBarcode(selectedBarcode: selectedBarcode)
                                }
                            }
                        }                        
                        .disabled(barcodePropertiesViewModel.symbology == "POSTNET" ? true : false)
                    
                }
                
                
                Section(header: Text("Barcode")){
                   
                    
                    Picker("Font", selection: $barcodePropertiesViewModel.fontName) {
                        ForEach(barcodeFontNames, id: \.self) {
                            Text($0)
                        }
                    }
                    .onChange(of: barcodePropertiesViewModel.fontName) { newValue in
                        self.shapes.shapeList.forEach
                        {
                            if $0.isSelected == true {
                                let selectedBarcode = $0 as! BarcodeX
                                selectedBarcode.fontName = newValue
                            }
                        }
                    }
                    HStack{
                        Text("Color")
                        Spacer()
                        ColorPicker("", selection: $barcodePropertiesViewModel.textColor, supportsOpacity: false)
                          .onChange(of: barcodePropertiesViewModel.textColor) { newValue in
                              
                              self.shapes.shapeList.forEach
                              {
                                  if $0.isSelected == true {
                                      let selectedBarcode = $0 as! BarcodeX
                                      selectedBarcode.textColor = newValue
                                  }
                              }
                          }.frame(width:100, height:30, alignment: .trailing)
                    }
                    HStack{
                        Text("Size")
                        Spacer()

                        //AA11
                        Text("\(Int(barcodePropertiesViewModel.fontSize * 72.0/300.0))")
                        //Text("\(Int(barcodePropertiesViewModel.fontSize))")
                    }
                    Slider(value: $barcodePropertiesViewModel.fontSize, in: 10...600 )
                        .onChange(of: barcodePropertiesViewModel.fontSize) { newValue in
                            self.shapes.shapeList.forEach
                            {
                                if $0.isSelected == true {
                                    let selectedBarcode = $0 as! BarcodeX
                                    selectedBarcode.fontSize = newValue
  
                                }
                            }
                        }
                    //Spacer()
                }
                
                Section(header: Text("Human Readable Text")){
                   
                    
                    Picker("Font", selection: $barcodePropertiesViewModel.hrFontName) {
                        ForEach(fontNames, id: \.self) {
                            Text($0)
                        }
                    }
                    .onChange(of: barcodePropertiesViewModel.hrFontName) { newValue in
                        self.shapes.shapeList.forEach
                        {
                            if $0.isSelected == true {
                                let selectedBarcode = $0 as! BarcodeX
                                selectedBarcode.hrFontName = newValue
                            }
                        }
                    }
                    HStack{
                        Text("Color")
                        Spacer()
                        ColorPicker("", selection: $barcodePropertiesViewModel.hrTextColor, supportsOpacity: false)
                          .onChange(of: barcodePropertiesViewModel.hrTextColor) { newValue in
                              
                              self.shapes.shapeList.forEach
                              {
                                  if $0.isSelected == true {
                                      let selectedBarcode = $0 as! BarcodeX
                                      selectedBarcode.hrTextColor = newValue
                                  }
                              }
                          }.frame(width:100, height:30, alignment: .trailing)
                    }
                    HStack{
                        Text("Size")
                        Spacer()

                        Text("\(Int(barcodePropertiesViewModel.hrFontSize * 72.0/300.0))")
               
                    }
                    Slider(value: $barcodePropertiesViewModel.hrFontSize, in: 10...600 )
                        .onChange(of: barcodePropertiesViewModel.hrFontSize) { newValue in
                            self.shapes.shapeList.forEach
                            {
                                if $0.isSelected == true {
                                    let selectedBarcode = $0 as! BarcodeX
                                    selectedBarcode.hrFontSize = newValue

                                }
                            }
                        }
                    //Spacer()
                }
                
                Section(header: Text("Horizontal Alignment")){
                    Picker("Text Alignment", selection: $barcodePropertiesViewModel.alignment) {
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
                    .onChange(of: barcodePropertiesViewModel.alignment) { newValue in
                        self.shapes.shapeList.forEach
                        {
                            if $0.isSelected == true {
                                let selectedBarcode = $0 as! BarcodeX
                                selectedBarcode.horizontalTextAlignment = newValue
                            }
                        }
                    }
                }

                DimensionsPropertiesViewX(objectPropertiesViewModel:  barcodePropertiesViewModel)

                
            }
            .navigationTitle("Barcode")
            
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
        print("setupViewModel")
        barcodePropertiesViewModel.setupSelectedProperties()
        
        

    }
    
    
    func encodeBarcode(selectedBarcode :BarcodeX)
    {
        print("encodeBarcodeencodeBarcodeencodeBarcode")
        var checkDigit = 0
        if barcodePropertiesViewModel.checkDigit
        {
            checkDigit = 1
        }
        
        if barcodePropertiesViewModel.symbology == "Code 39"
        {
            var code39 = Code39(barcodePropertiesViewModel.input,checkDigit)
            selectedBarcode.barcode = code39.encode()
            selectedBarcode.humanReadableText = code39.getHumanReadableText()
            //selectedBarcode.fontName = "CCode39_S3"
            //selectedBarcode.fontSize = 18 * 300.0/72.0
        }
        else if barcodePropertiesViewModel.symbology == "Industrial 2 of 5"
        {
            var ind2of5 = Industrial2of5(barcodePropertiesViewModel.input,checkDigit)
            selectedBarcode.barcode = ind2of5.encode()
            selectedBarcode.humanReadableText = ind2of5.getHumanReadableText()
            //selectedBarcode.fontName = "CCodeIND2of5_S3"
            //selectedBarcode.fontSize = 18 * 300.0/72.0
        }
        else if barcodePropertiesViewModel.symbology == "POSTNET"
        {
            var postnet = POSTNET(barcodePropertiesViewModel.input)
            selectedBarcode.barcode = postnet.encode()
            selectedBarcode.humanReadableText = postnet.getHumanReadableText()
            //selectedBarcode.fontName = "CCodeIPostnet"
            //selectedBarcode.fontSize = 9 * 300.0/72.0
        }

        
    }
    
    func reselectBarcode(selectedBarcode :BarcodeX)
    {
        print("reselectBarcode")
        //check digit depends on the new symbology selected
        /*
        var checkDigit = 0
        if barcodePropertiesViewModel.checkDigit
        {
            checkDigit = 1
        }
        */
        
        if barcodePropertiesViewModel.symbology == "Code 39"
        {
            var code39 = Code39(barcodePropertiesViewModel.input,0)
            barcodePropertiesViewModel.checkDigit = false
            barcodePropertiesViewModel.fontName = "CCode39_S3"
            barcodePropertiesViewModel.fontSize = 99.0
            
            selectedBarcode.barcode = code39.encode()
            selectedBarcode.humanReadableText = code39.getHumanReadableText()
            selectedBarcode.fontName = "CCode39_S3"
            selectedBarcode.fontSize = 18 * 300.0/72.0
        }
        else if barcodePropertiesViewModel.symbology == "Industrial 2 of 5"
        {
            var ind2of5 = Industrial2of5(barcodePropertiesViewModel.input,0)
            barcodePropertiesViewModel.checkDigit = false
            barcodePropertiesViewModel.fontName = "CCodeIND2of5_S3"
            barcodePropertiesViewModel.fontSize = 99.0
            selectedBarcode.barcode = ind2of5.encode()
            selectedBarcode.humanReadableText = ind2of5.getHumanReadableText()
            selectedBarcode.fontName = "CCodeIND2of5_S3"
            selectedBarcode.fontSize = 18 * 300.0/72.0
        }
        else if barcodePropertiesViewModel.symbology == "POSTNET"
        {
            var postnet = POSTNET(barcodePropertiesViewModel.input)
            //selectedBarcode.checkDigit = true
            barcodePropertiesViewModel.checkDigit = true
            barcodePropertiesViewModel.fontName = "CCodeIPostnet"
            barcodePropertiesViewModel.fontSize = 38.0

            selectedBarcode.barcode = postnet.encode()
            selectedBarcode.humanReadableText = postnet.getHumanReadableText()
            selectedBarcode.fontName = "CCodeIPostnet"
            selectedBarcode.fontSize = 9 * 300.0/72.0
        }

        
    }
}

