//
//  RulerVView.swift
//
//
//  Created by  on 15/3/22.
//

import SwiftUI
@available(iOS 15.0, *)
struct RulerVViewX: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
     @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
   
    @Binding var offsetY: CGFloat
    var rulerHeight: CGFloat
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var pageSettings: PageSettings
    var body: some View {
        Canvas { context, size in
            
            var dpi = 72.0*appSettings.dpiScale
            if appSettings.units != "Inches"
            {
                dpi = dpi / 2.54
            }
            //let heighty = 1.0*72.0*appSettings.dpiScale*appSettings.zoomFactor
            let heighty = pageSettings.labelHeight*72.0*appSettings.dpiScale*appSettings.zoomFactor
            //let thickness = 0.35*72.0
            let thickness = horizontalSizeClass == .regular && verticalSizeClass == .regular ? 0.4*72.0 : 0.38*72.0
            //let heighty = 11*72.0
            let spacingy = 0.1*dpi*appSettings.zoomFactor
            let countx = heighty / spacingy
            //let rightx = thickness
            let heightSmallTicks = 0.1*72.0
            
            
            let spacingyBig = 1.0*dpi*appSettings.zoomFactor
            let countxBig = heighty / spacingyBig
            //print("countxBig:",countxBig,":",heighty,":",spacingyBig)
            //let rightxBig = thickness
            let heightBigTicks = 0.2*72.0
            
            let spacingyMed = 1.0*dpi*appSettings.zoomFactor
            let countxMed = heighty / spacingyMed
            //let rightxMed = thickness
            let heightMedTicks = 0.155*72.0
          
            //let pixelAdjust = 1.0
            //let stackSpaceAdjust = 2.0
            
            
            var countzero = offsetY / spacingy
            let xpath = CGMutablePath()

            countzero = countzero < 0.0 ? 0.0 : countzero
            var currenty = offsetY
            for _ in 0...Int(countzero)
            {
                if (spacingy > 2.0) //prevent too small space between small ticks in centimeters
                {
                if currenty > 0.0
                {
                    xpath.move(to: CGPoint(x: thickness, y: currenty))
                    xpath.addLine(to: CGPoint(x: thickness-heightSmallTicks , y: currenty))
                    currenty -= spacingy
                }
                }
            }
  
                        
            //var initialy = thickness + spacingy + stackSpaceAdjust + pixelAdjust //2 is the vstack spacing betwwen reular and displayview
            //var initialy = offsetY + 0.155*72.0 //+ thickness
            var initialy = offsetY
            //1 is a little adjustment
            currenty = initialy
            //var darkColor: UIColor = UIColor.black
            let path = CGMutablePath()
            
            for _ in 1...Int(countx)
            {
                if (spacingy > 2.0) //prevent too small space between small ticks in centimeters
                {
                path.move(to: CGPoint(x: thickness, y: currenty))
                path.addLine(to: CGPoint(x: thickness-heightSmallTicks , y: currenty))
                currenty += spacingy
                }
            }
            let storecurrenty=currenty
            
            //initialy = thickness + stackSpaceAdjust + pixelAdjust
            //initialy = offsetY + 0.155*72.0 //+ thickness
            initialy = offsetY
            currenty = initialy
            
            print("thickness:",thickness)
            print("offsetY:",offsetY)
            print("currenty:",currenty)
            
            for ty in 0...Int(countxBig)+1
            {
                
                let textPoint = CGPoint(x: thickness-heightBigTicks-6, y: currenty)
                let text = Text(String(ty)).font(.system(size: 11))
                context.draw(text, at: textPoint, anchor: .center)
                
                path.move(to: CGPoint(x: thickness, y: currenty))
                path.addLine(to: CGPoint(x: thickness-heightBigTicks , y: currenty))
                currenty += spacingyBig
            }
            
            let initialOffsetDueToRulerH = 0.5*dpi*appSettings.zoomFactor
            

            initialy = offsetY + initialOffsetDueToRulerH
            
            currenty = initialy

            for _ in 0...Int(countxMed)
            {
                path.move(to: CGPoint(x: thickness, y: currenty))
                path.addLine(to: CGPoint(x: thickness-heightMedTicks , y: currenty))
                currenty += spacingyMed
            }
                                    
            context.stroke(
                Path(path),
                with: .color(.black),
                lineWidth: 1)
            
            currenty = storecurrenty
            var countend = (rulerHeight - currenty) / spacingy
            //countend = countend < 0.0 ? 0.0 : countend
            countend = countend < 1.0 ? 1.0 : countend
            for _ in 1...Int(countend)
            {
                if (spacingy > 2.0) //prevent too small space between small ticks in centimeters
                {
                xpath.move(to: CGPoint(x: thickness, y: currenty))
                xpath.addLine(to: CGPoint(x: thickness-heightSmallTicks , y: currenty))
                currenty += spacingy
                }
            }
            
            context.stroke(
                Path(xpath),
                with: .color(.black),
                lineWidth: 1.0)
        }.background(colorScheme == .dark ? Color(UIColor.lightGray) : Color.white)
    }
}

