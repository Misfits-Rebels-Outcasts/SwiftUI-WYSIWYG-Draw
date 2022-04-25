//
//  DimensionPropertiesViewX.swift
//
//
//  Created by  on 21/4/22.
//
import SwiftUI

struct DimensionsPropertiesViewX: View {
    

    @EnvironmentObject var shapes: ShapesX
    @StateObject var objectPropertiesViewModel: ObjectBaseViewModel
    
    var body: some View {

                Section(header: Text("Dimensions (Pixels)")){
                          
                    HStack{
                        Text("X")
                        Spacer()
                                                
                        TextField("X", text: $objectPropertiesViewModel.x)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                            .fixedSize()
                            .onChange(of: objectPropertiesViewModel.x) { newValue in
                                self.shapes.shapeList.forEach
                                {
                                    let trimStr = newValue.count > 4 ? String(newValue.prefix(4)) : newValue
                                    if $0.isSelected == true {
                                        let selectedText = $0 //as! TextX
                                        if let n = NumberFormatter().number(from: trimStr) {
                                            
                                            //number is assumed to be in inch x 72pixels
                                            let xIn72 = CGFloat(truncating: n)
                                            let widthIn300 = CGFloat($0.size.width)/2.0
                                            let finalX = xIn72*300.0/72.0 + widthIn300
                                            //print("imvs:",selectedText.imageViewSize.width)
                                            //print("sts:",selectedText.size.width)
                                            //print("fx:",finalX)

                                            if finalX >= 0.0 &&
                                                finalX <= selectedText.canvasSize.width
                                            {
                                                selectedText.location.x = finalX
                                            }
                                            
                                            //set to max so that behavior seems ok
                                            if finalX > selectedText.canvasSize.width
                                            {
                                                selectedText.location.x = selectedText.canvasSize.width
                                            }
                                                                                
                                            print(selectedText.location.x)
                                        }
                                    }
                                }
                            }
                    }//HStack
                    HStack{
                        Text("Y")
                        Spacer()
                        TextField("Y", text: $objectPropertiesViewModel.y)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                            .fixedSize()
                            .onChange(of: objectPropertiesViewModel.y) { newValue in
                                self.shapes.shapeList.forEach
                                {
                                    let trimStr = newValue.count > 4 ? String(newValue.prefix(4)) : newValue
                                    if $0.isSelected == true {
                                        let selectedText = $0 //as! TextX
                                        if let n = NumberFormatter().number(from: trimStr) {
                                            
                                            //number is assumed to be in inch x 72pixels
                                            let yIn72 = CGFloat(truncating: n)
                                            let heightIn300 = CGFloat($0.size.height)/2.0
                                            let finalY = yIn72*300.0/72.0 + heightIn300

                                            if finalY >= 0.0 &&
                                                finalY <= selectedText.canvasSize.height
                                            {
                                                selectedText.location.y = finalY
                                            }
                                            
                                            //set to max so that behavior seems ok
                                            if finalY > selectedText.canvasSize.height
                                            {
                                                selectedText.location.y = selectedText.canvasSize.height
                                            }
                                            print(selectedText.location.y)
                                        }
                                    }
                                }
                            }
                    }//HStack
                    
                    HStack{
                        Text("Width")
                        Spacer()
                        TextField("Width", text: $objectPropertiesViewModel.width)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                            .fixedSize()
                            .onChange(of: objectPropertiesViewModel.width) { newValue in
                                self.shapes.shapeList.forEach
                                {
                                    let trimStr = newValue.count > 4 ? String(newValue.prefix(4)) : newValue
                                    if $0.isSelected == true {
                                        let selectedText = $0 //as! TextX
                                        if let n = NumberFormatter().number(from: trimStr) {
                                            
                                            //number is assumed to be in inch x 72pixels
                                            let widthIn72 = CGFloat(truncating: n)
                                            let finalWidth = widthIn72*300.0/72.0
                                    
                                            if finalWidth > 0.0 &&
                                                finalWidth < selectedText.canvasSize.width
                                            {
                                                selectedText.size.width = finalWidth
                                            }
                                            
                                            if finalWidth < 80.0
                                            {
                                                selectedText.size.width = 80.0
                                            }

                                            //set to max so that behavior seems ok
                                            if finalWidth > selectedText.canvasSize.width - 20
                                            {
                                                selectedText.size.width = selectedText.canvasSize.width - 20
                                            }
                                            
                                            //update x as width changes in both directions
                                            objectPropertiesViewModel.x = String(format: "%.0f", (selectedText.location.x - CGFloat(selectedText.size.width)/2.0) * 72.0 / 300.0)
                                            print(selectedText.size.width)
                                        }
                                    }
                                }
                            }
                    }//HStack
                    
                    HStack{
                        Text("Height")
                        Spacer()
                        TextField("Height", text: $objectPropertiesViewModel.height)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                            .fixedSize()
                            .onChange(of: objectPropertiesViewModel.height) { newValue in
                                self.shapes.shapeList.forEach
                                {
                                    let trimStr = newValue.count > 4 ? String(newValue.prefix(4)) : newValue
                                    if $0.isSelected == true {
                                        let selectedText = $0 //as! TextX
                                        if let n = NumberFormatter().number(from: trimStr) {
                                            
                                            //number is assumed to be in inch x 72pixels
                                            let heightIn72 = CGFloat(truncating: n)
                                            let finalHeight = heightIn72*300.0/72.0
                                    
                                            if finalHeight > 0.0 &&
                                                finalHeight < selectedText.canvasSize.height
                                            {
                                                selectedText.size.height = finalHeight
                                            }
                                            
                                            if finalHeight < 80.0
                                            {
                                                selectedText.size.height = 80.0
                                            }
                                        
                                            //set to max so that behavior seems ok
                                            if finalHeight > selectedText.canvasSize.height - 20
                                            {
                                                selectedText.size.height = selectedText.canvasSize.height - 20
                                            }
                                            //update x as width changes in both directions
                                            objectPropertiesViewModel.y = String(format: "%.0f", (selectedText.location.y - CGFloat(selectedText.size.height)/2.0) * 72.0 / 300.0)

                                            print(selectedText.size.height)
                                        }
                                    }
                                }
                            }
                    }//HStack
                    


        }
        Section(header: Text("zIndex (Higher values are in front)")){
            HStack{
                TextField("zIndex", text: $objectPropertiesViewModel.zIndex)
                    .onChange(of: objectPropertiesViewModel.zIndex) { newValue in
                        self.shapes.shapeList.forEach
                        {
                            if $0.isSelected == true {
                                let selectedText = $0 //as! ShapeX
                                selectedText.zIndex = Double(newValue) ?? 0.0
                                selectedText.zIndex = selectedText.zIndex > 100.0 ? 100.0 : selectedText.zIndex
                                selectedText.zIndex = selectedText.zIndex < -100.0 ? -100.0 : selectedText.zIndex

                            }
                             
                        }
                    }
            }
        }
    }
    
    func setupViewModel()
    {
        //textPropertiesViewModel.setupSelectedProperties()

    }
    
}

