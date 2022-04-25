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

public struct POSTNET {

    
    public var inputData=""
    public var humanReadableText=""
    
    init() {
        self.inputData="12345678"
    }
    
    public init(_ inputData:String) {
        self.inputData=inputData
    }

    func getPOSTNETValue(_ inputChar:Character) -> Int {
         return (Int)(inputChar.asciiValue!) - 48
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

        if (filteredlength > 11)
        {
            filtereddata=String(filtereddata.prefix(11))
        }

        cd=generateCheckDigit(filtereddata);

        humanReadableText=filtereddata+cd
        result="{"+filtereddata+cd+"}"
        return result
    
        
    }
    
    public func getHumanReadableText()->String{
        return humanReadableText
    }
    
    func getPOSTNETCharacter(_ inputdecimal:Int) -> String
    {
        return String(UnicodeScalar(inputdecimal+48)!)
    }
    
    func generateCheckDigit(_ bdata:String)->String
    {
        var datalength=0
        var sum = 0
        var result = -1
        var strResult=""
        
        datalength=bdata.count
        if datalength>0
        {
            for x in 0...datalength-1
            {
                let barcodechar = bdata[x]
                sum = sum + getPOSTNETValue(barcodechar)
            }
        }
        
        result=sum % 10
        if result != 0
        {
            result = 10 - result
        }
        
        strResult=getPOSTNETCharacter(result)
        
        return strResult
        
    }


}
