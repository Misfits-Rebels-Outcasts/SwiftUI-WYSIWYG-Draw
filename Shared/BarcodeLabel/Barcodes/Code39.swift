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

extension String {
    subscript (index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }

    subscript (range: Range<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.startIndex)
        let stopIndex = self.index(self.startIndex, offsetBy: range.startIndex + range.count)
        return self[startIndex..<stopIndex]
    }

}

public struct Code39 {

    let CODE39MAP = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","-","."," ","$","/","+","%"]
    
    public var inputData=""
    public var checkDigit=1
    public var humanReadableText=""
    
    init() {
        self.inputData="12345678"
        self.checkDigit=1
    }
    
    public init(_ inputData:String, _ checkDigit:Int) {
        self.inputData=inputData
        self.checkDigit=checkDigit
    }

    func getCode39Value(_ inputChar:Character) -> Int {
        
        guard let cVal = CODE39MAP.firstIndex(of: "\(inputChar)") else {
            return -1
        }
     
        return cVal;
    }
    
    func filterInput (_ inputData:String) -> String {
        var retStr=""
        inputData.forEach { char in
            if (CODE39MAP.contains("\(char)"))
            {
                retStr = retStr + "\(char)"
            }
        }
        return retStr
    }
    
    public mutating func encode () -> String {
        
        var cd=""
        var result=""
        var filtereddata = filterInput(inputData)
        let filteredlength=filtereddata.count
        
        if (checkDigit==1)
        {
            if (filteredlength > 254)
            {
                filtereddata=String(filtereddata.prefix(254))
            }
            cd=generateCheckDigit(filtereddata);
        }
        else
        {
            if (filteredlength > 255)
            {
                filtereddata=String(filtereddata.prefix(255))
            }
        }
        result="*"+filtereddata+cd+"*"
        humanReadableText=result
        return result
    
        
    }
    
    public func getHumanReadableText()->String{
        return humanReadableText
    }
    
    func getCode39Character(_ inputdecimal:Int) -> String
    {
        let str=CODE39MAP[inputdecimal]
        return str
    }
    
    func generateCheckDigit(_ bdata:String)->String
    {
        var datalength=0
        var sum = 0
        var result = -1
        var strResult=""
        
        datalength=bdata.count
        //guard the for loop
        if datalength>0
        {
            for x in 0...datalength-1
            {
                let barcodechar = bdata[bdata.index(bdata.startIndex, offsetBy: x)]
                sum = sum + getCode39Value(barcodechar);
            }
        }
        result=sum % 43
        strResult=getCode39Character(result)
        
        return strResult
        
    }


}
