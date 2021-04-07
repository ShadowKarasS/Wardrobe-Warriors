 import Foundation
 import UIImage
 
 
 func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size

    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height

    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }

    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}
self.resizeImage(UIImage(named: "Image")!, targetSize: CGSizeMake(200.0, 200.0))


func getPixelColor(pos: CGPoint) -> UIColor {
    var pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
    var data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

    var pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4

    var r = CGFloat(data[pixelInfo])/ CGFloat(255.0)
    var g = CGFloat(data[pixelInfo+1])/ CGFloat(255.0)
    var b = CGFloat(data[pixelInfo+2])/ CGFloat(255.0)
    var a = CGFloat(data[pixelInfo+3])/ CGFloat(255.0)

    return UIColor(red: r, green: g, blue: b, alpha: a)
}
    let green = UIImage(named: "Image.png")
    let colorPixel = CGPoint(x: 100, y: 100)

    // Use your extension
    let greenColour = green.getPixelColor(colorPixel)

    // Dump RGBA values
    var redval: CGFloat = 0
    var greenval: CGFloat = 0
    var blueval: CGFloat = 0
    var alphaval: CGFloat = 0
    greenColour.getRed(&redval, green: &greenval, blue: &blueval, alpha: &alphaval)
    println("Image is r: \(redval) g: \(greenval) b: \(blueval) a: \(alphaval)")