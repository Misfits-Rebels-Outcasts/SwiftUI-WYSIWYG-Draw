/*
Copyright 2022 barcoderesource.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import SwiftUI

struct TemplateViewX: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
   
    @EnvironmentObject var optionSettings: OptionSettings
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var pageSettings: PageSettings
    @EnvironmentObject var shapes: ShapesX
    @StateObject var templateViewModel: TemplateViewModel
    @StateObject var tempPageSettings: PageSettings = PageSettings()
    
    init(templateViewModel: TemplateViewModel) {
        _templateViewModel=StateObject(wrappedValue: templateViewModel)

        if templateViewModel.type == "envelope-landscape"
        {
            templateViewModel.previewFactor = 0.15
        }
        else{
            templateViewModel.previewFactor = 0.25
        }
            
    }
    
    var body: some View {

        let templatePreview = ZStack {
            ForEach(tempPageSettings.labelList) { iLabel in
                VStack {
                    TemplateLabelViewX()
                    .frame(width: tempPageSettings.labelWidth*72, height: tempPageSettings.labelHeight*72, alignment: .center)
                }
                .frame(width: tempPageSettings.labelWidth*72, height: tempPageSettings.labelHeight*72, alignment: .center)
                .border(Color.gray, width:2.0)
                .position(x: iLabel.x, y: iLabel.y)
            }
        }
        .frame(width: tempPageSettings.pageWidth*72, height: tempPageSettings.pageHeight*72, alignment: .topLeading)
        .border(Color.gray, width:2.0)
        .background(Color.white)

        NavigationView {

            Form {
            
                Section(header: Text("Preview")){
                    HStack{
                        Spacer()
                        VStack
                        {
                            VStack {
                                templatePreview
                            }
                            .scaleEffect(templateViewModel.previewFactor)
                        }
                        .frame(width: tempPageSettings.pageWidth*72*templateViewModel.previewFactor, height: tempPageSettings.pageHeight*72*templateViewModel.previewFactor, alignment: .center)
                        .padding()
                        Spacer()
                    }
                }
                Section(header: Text("Category")){
                    Picker("Category", selection: $templateViewModel.category) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    .onChange(of: templateViewModel.category) { newValue in
                        labelTemplates = labelTemplatesAll.filter {
                            $0[1].contains(templateViewModel.category) && $0[2].contains("Standard")
                        }
                        
                        if templateViewModel.category == "Labels"
                        {
                            vendors = vendorsLabels
                        }
                        else if templateViewModel.category == "Envelopes"
                        {
                            vendors = ["Standard"]
                        }
                        else if templateViewModel.category == "Cards & Tags"
                        {
                            vendors = vendorsCards
                        }
                        else if templateViewModel.category == "Papers"
                        {
                            vendors = ["Standard"]
                        }
                        
                        templateViewModel.templateCount = labelTemplates.count
                        print(":",templateViewModel.templateCount)
                        templateViewModel.selectedTemplateIndex = 0
                        templateViewModel.setupPageSettingsAndTemplateModel(tempPageSettings: tempPageSettings ,selectedTemplateIndex: 0)
                  
                    }
                    
                    Picker("Vendor", selection: $templateViewModel.vendor) {
                        ForEach(vendors, id: \.self) {
                            Text($0)
                        }
                    }
                    .onChange(of: templateViewModel.vendor) { newValue in
                        labelTemplates = labelTemplatesAll.filter {
                            $0[1].contains(templateViewModel.category) && $0[2].contains(templateViewModel.vendor)
                        }
                        templateViewModel.templateCount = labelTemplates.count
                        print(":",templateViewModel.templateCount)
                        templateViewModel.selectedTemplateIndex = 0
                        templateViewModel.setupPageSettingsAndTemplateModel(tempPageSettings: tempPageSettings ,selectedTemplateIndex: 0)
                    }
                     
                }
                
                Section(header: Text("Template")){

                    Picker(selection: $templateViewModel.selectedTemplateIndex, label: Text("")) {
                        //https://stackoverflow.com/questions/58504575/view-is-not-rerendered-in-nested-foreach-loop
                        ForEach(0..<templateViewModel.templateCount, id: \.self) { index in //inner ForEach
                            VStack{
                                HStack{
                                    Text(labelTemplates[index][0]).font(.subheadline)
                                    Spacer()
                                }
                                HStack{
                                    Text(labelTemplates[index][3])
                                    Spacer()
                                }
                            }
                        }
                    }
                    .onChange(of: templateViewModel.selectedTemplateIndex) { newValue in
                        
                        templateViewModel.setupPageSettingsAndTemplateModel(tempPageSettings: tempPageSettings,selectedTemplateIndex: newValue)
                    }
                    //https://stackoverflow.com/questions/58352798/swiftui-picker-does-not-update-correctly-when-changing-datasource
                    //.id(templateViewModel.category)
                }
                Section(header: Text("Page Dimensions (Read Only)")){
                    HStack() {
                        Text("Units")
                        Spacer()
                        TextField("Measurements", text: $templateViewModel.units)
                            .foregroundColor(Color.black).disabled(true).fixedSize().multilineTextAlignment(.trailing)
                    }
                    HStack() {
                        Text("Width")
                        Spacer()
                        TextField("Page Width", text: $templateViewModel.pageWidth)
                            .foregroundColor(Color.black).disabled(true).fixedSize().multilineTextAlignment(.trailing)
                    }
                    HStack() {
                        Text("Height")
                        Spacer()
                        TextField("Page Height", text: $templateViewModel.pageHeight)
                            .foregroundColor(Color.black).disabled(true).fixedSize().multilineTextAlignment(.trailing)
                    }
                    HStack() {
                        Text("Left Margin")
                        Spacer()
                        TextField("Left Margin", text: $templateViewModel.leftMargin)
                            .foregroundColor(Color.black).disabled(true).fixedSize().multilineTextAlignment(.trailing)
                    }
                    HStack() {
                        Text("Top Margin")
                        Spacer()
                        TextField("Top Margin", text: $templateViewModel.topMargin)
                            .foregroundColor(Color.black).disabled(true).fixedSize().multilineTextAlignment(.trailing)
                    }
                }
                Section(header: Text("Label Dimensions (Read Only)")){
                    HStack() {
                        Text("Width")
                        Spacer()
                        TextField("Label Width", text: $templateViewModel.labelWidth)
                            .foregroundColor(Color.black).disabled(true).fixedSize().multilineTextAlignment(.trailing)
                    }
                    HStack() {
                        Text("Height")
                        Spacer()
                        TextField("Height", text: $templateViewModel.labelHeight)
                            .foregroundColor(Color.black).disabled(true).fixedSize().multilineTextAlignment(.trailing)
                    }
                    HStack() {
                        Text("No. of Rows")
                        Spacer()
                        TextField("TNumber of Rows", text: $templateViewModel.numRows)
                            .foregroundColor(Color.black).disabled(true).fixedSize().multilineTextAlignment(.trailing)
                    }
                    HStack() {
                        Text("No. of Columns")
                        Spacer()
                        TextField("TNumber of Columns", text: $templateViewModel.numCols)
                            .foregroundColor(Color.black).disabled(true).fixedSize().multilineTextAlignment(.trailing)
                    }
                    HStack() {
                        Text("Horizontal Space")
                        Spacer()
                        TextField("Horizontal Space", text: $templateViewModel.hSpace)
                            .foregroundColor(Color.black).disabled(true).fixedSize().multilineTextAlignment(.trailing)
                    }
                    HStack() {
                        Text("Vertical Space")
                        Spacer()
                        TextField("Vertical Space", text: $templateViewModel.vSpace)
                            .foregroundColor(Color.black).disabled(true).fixedSize().multilineTextAlignment(.trailing)
                    }

                }
                
            }
            .navigationTitle("Label Templates")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .primaryAction) {
                        Button("Create") {
                            createLabel()
                        }
                }
                ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            //optionSettings.showPropertiesView=0 //set back to 0
                            //restoreOriginalLabel()
                            //pageSettings.dpi=72.0
                            //optionSettings.action = "Design"
                            optionSettings.showPropertiesSheet=false

                        }
                }
                
            }
        } //For,
        .onAppear(perform: populateForm)
                    
    }

    func createLabel()
    {
        print("create:",templateViewModel.name,":",templateViewModel.description)
        optionSettings.action = "Design"
        optionSettings.showPropertiesSheet = false
        
        let x=templateViewModel.selectedTemplateIndex
        
        //new and startup will use appSettings dpi
        pageSettings.dpi=appSettings.dpi
        
        self.templateViewModel.setupPageSettings(selectedTemplateIndex: x)
        
        shapes.shapeList=[ShapeX]()
        appSettings.zoomFactor = horizontalSizeClass == .regular && verticalSizeClass == .regular ? 0.5 : 0.28

    }
    
    func populateForm()
    {
        print("populateForm:",templateViewModel.category,":",templateViewModel.vendor)
        
        labelTemplates = labelTemplatesAll.filter {
            $0[1].contains(templateViewModel.category) && $0[2].contains(templateViewModel.vendor)
        }
        print("templatescount:",labelTemplates.count)
        templateViewModel.templateCount = labelTemplates.count

        if templateViewModel.category == "Labels"
        {
            vendors = vendorsLabels
        }
        else if templateViewModel.category == "Envelopes"
        {
            vendors = ["Standard"]
        }
        else if templateViewModel.category == "Cards & Tags"
        {
            vendors = vendorsCards
        }
        else if templateViewModel.category == "Papers"
        {
            vendors = ["Standard"]
        }
            
        for x in 0...labelTemplates.count-1
        {
            
            if labelTemplates[x][0] == templateViewModel.name &&
                labelTemplates[x][1] == templateViewModel.category &&
                labelTemplates[x][2] == templateViewModel.vendor &&
                labelTemplates[x][3] == templateViewModel.description
            {
                print("found:",x)
                templateViewModel.selectedTemplateIndex = x
            }
        }
        tempPageSettings.name = pageSettings.name
        tempPageSettings.category = pageSettings.category
        tempPageSettings.vendor = pageSettings.vendor
        tempPageSettings.description = pageSettings.description
        tempPageSettings.type = pageSettings.type
        tempPageSettings.pageWidth = pageSettings.pageWidth
        tempPageSettings.pageHeight = pageSettings.pageHeight
        tempPageSettings.labelWidth = pageSettings.labelWidth
        tempPageSettings.labelHeight = pageSettings.labelHeight
        tempPageSettings.hSpace = pageSettings.hSpace
        tempPageSettings.vSpace = pageSettings.vSpace
        tempPageSettings.numRows = pageSettings.numRows
        tempPageSettings.numCols = pageSettings.numCols
        print(tempPageSettings.numRows)
        print(tempPageSettings.numCols)
        tempPageSettings.leftMargin = pageSettings.leftMargin
        tempPageSettings.topMargin = pageSettings.topMargin
        tempPageSettings.generateLabels(dpi:72)

    }
    
}

