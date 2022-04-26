# SwiftUI-WYSIWYG-Draw

This source code explores how to use SwiftUI for developing a What-You-See-Is-What-You-Get (WYSIWYG) vector drawing app. A WYSIWYG vector drawing app can be thought of as one that renders different objects such as a rectangle, an ellipse, a text, or other shapes on a canvas; 
the moving of objects around a canvas by dragging; and changing object properties by tapping on objects. 
This is illustrated in the screenshot of an iOS app below. 
Specifically, this article explores the use of a SwiftUI View as the "Drawing Canvas" instead of using a Core Graphics Canvas or a SwiftUI Canvas.

<img src="https://www.barcoderesource.com/iosimages/WYSIWYG_SwiftUI.png" width="405" height="590">

## Some points on the design
<a href=https://www.barcoderesource.com/swiftui_view_vector_draw_wysiwyg.shtml>https://www.barcoderesource.com/swiftui_view_vector_draw_wysiwyg.shtml</a>

## The proof of concept app
<a href=https://apps.apple.com/us/app/barcode-label/id1620797490>Barcode & Label</a>

## Why use SwiftUI View as the drawing canvas?

When developing a vector drawing app in the Apple ecosystem, things that come immediately onto the mind are Core Graphics or SwiftUI Canvas. Both are extremely fast, easy to use, and provide a canvas for us to draw on. Naturally, both are good choices as the canvas of a drawing app. However, when the drawing app requires WYSIWYG behavior, a Swift developer realizes that handling of object interactions such as drag, move, and resize, requires the use of Apple's Gestures and Events.

This makes it hard for a Swift developer to ignore the use of a SwiftUI View as the "Drawing Canvas". This is because all Apple's Gestures and Events are directly supported by a SwiftUI View. If one is to take a step back and think about it, a SwiftUI View is designed by Apple for User Interface (UI) development, and such a View already naturally supports all the behavior required by a WYSIWYG app: rendering views and objects, and supporting gestures and events. The use of a SwiftUI View as the "Drawing Canvas" also does not prevent us from using Core Graphics, SwiftUI Canvas, or even Metal for rendering the underlying object that requires special treatment, as all three can be represented as a SwiftUI View easily.
