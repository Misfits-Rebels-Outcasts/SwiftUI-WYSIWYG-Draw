/*
Copyright 2022 barcoderesource.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/*
 https://www.barcoderesource.com/barcodelabelappleapp.shtml
 
 https://www.barcoderesource.com/swiftui_view_vector_draw_wysiwyg.shtml
*/


import Foundation

public struct Industrial2of5 {

    public var inputData=""
    public var checkDigit=1
    public var humanReadableText=""
    
    init() {
        self.inputData="12345678"
        self.checkDigit=1
    }
    
    public init(_ inputData:String,_ checkDigit:Int) {
        self.inputData=inputData
        self.checkDigit=checkDigit
    }
    
    func filterInput (_ inputData:String) -> String {
        var retStr=""
        
        inputData.forEach { char in
            if let uchar = char.asciiValue {
                let barcodevalue=Int(uchar)

                if barcodevalue <= 57 && barcodevalue >= 48
                {
                    retStr = retStr + "\(char)"
                }
            }
        }
        
        return retStr
    }
    
    public mutating func encode () -> String {
        
        var cd=""
        var result=""
        var filtereddata = filterInput(inputData)
        let filteredlength=filtereddata.count
        
        if (checkDigit == 1)
        {
            if (filteredlength > 254)
            {
                filtereddata=String(filtereddata.prefix(254))
            }
            cd=generateCheckDigit(filtereddata);
        }
        else{
            
            if (filteredlength > 255)
            {
                filtereddata=String(filtereddata.prefix(255))
            }

            
        }
        filtereddata = filtereddata + cd
        humanReadableText=filtereddata

        result="{"+filtereddata+"}"


        return result
    }
    
    public func getHumanReadableText()->String{
        return humanReadableText
    }
        
    func generateCheckDigit(_ bdata:String)->String
    {
        var datalength=0
        var lastcharpos = 0
        var result=0
        var strResult=""
        var barcodechar=0
        var barcodevalue=0
        var toggle=1
        var sum=0
        
        datalength=bdata.count
        lastcharpos=datalength-1
        
        var x=lastcharpos
        while (x>=0)
        {
            barcodechar=(Int)(bdata[x].asciiValue!)
            barcodevalue=barcodechar-48
            if toggle == 1
            {
                sum += (barcodevalue*3);
                toggle = 0;
            }
            else
            {
                sum += barcodevalue;
                toggle = 1;
            }
            
            x=x-1
        }
        
        if sum % 10 == 0
        {
            result=0+48
        }
        else{
            result = (10 - (sum % 10)) + 48
        }
        
        strResult=strResult+String(UnicodeScalar(result)!)
        return strResult
        
    }


}

