//
//  LabelMainViewModel.swift
//
//
//  Created by  on 23/3/22.
//
import SwiftUI

class ImagePropertiesViewModel: ObjectBaseViewModel {

    func setupSelectedProperties()
    {
        self.shapes.shapeList.forEach
        {
            if $0.isSelected == true {
                if $0 is ImageX
                {
                    let selectedShape = $0 as! ImageX
                    
                    let tX = (selectedShape.location.x - CGFloat(selectedShape.size.width)/2.0) * 72.0 / 300.0
                    let tY = (selectedShape.location.y - CGFloat(selectedShape.size.height)/2.0) * 72.0 / 300.0
                    let tWidth = selectedShape.size.width * 72.0 / 300.0
                    let tHeight = selectedShape.size.height * 72.0 / 300.0
                    let tzIndex = selectedShape.zIndex
                    super.setupSelectedProperties(x:tX,y:tY,width:tWidth,height:tHeight,zIndex:tzIndex)

                }

            }
        }
    }
    
  

}
