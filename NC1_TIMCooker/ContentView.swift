//
//  ContentView.swift
//  NC1_TIMCooker
//
//  Created by Eldenabih Tavirazin Lutvie on 29/04/24.
//

import SwiftUI
import Photos
import CoreML

struct ContentView: View {
    @StateObject private var viewModel = MealListViewModel()
    @State private var hasIngredients = false
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    @State private var detectedIngredients = ""
    
    let model: IngredientDetector?
    
    
    var thePixelBuffer : CVPixelBuffer?
    
    var body: some View {
        NavigationStack{
            VStack {
                
                if !hasIngredients {
                    Spacer()
                    Image("fridge")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250)
                    Text("Let us help you cook with what you have! Upload your ingredients for some meal inspirations.").multilineTextAlignment(.center)
                    Spacer()
                    UploadButton(action: {
                        let status = PHPhotoLibrary.authorizationStatus()
                        
                        switch status {
                        case .notDetermined:
                            PHPhotoLibrary.requestAuthorization { newStatus in
                                if newStatus == .authorized {
                                    print("Access granted.")
                                } else {
                                    print("Access denied.")
                                }
                            }
                        case .restricted, .denied:
                            print("Access denied or restricted.")
                        case .authorized:
                            print("Access already granted.")
                            ImagePickerView.checkPermissionsAndOpenCamera(showCamera: showCamera) { granted in
                                // Handle permission result
                                if granted {
                                    self.showCamera = true // Present camera view
                                } else {
                                    // Permission denied, show an alert or handle appropriately
                                }
                            }
                        case .limited:
                            print("Access limited.")
                        @unknown default:
                            print("Unknown authorization status.")
                        }
                        viewModel.handleUploadPhoto()
                        hasIngredients = true
                        getIngredients()
                    })
                } else {
                    ScrollView{
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            ForEach(viewModel.meals) { meal in
                                NavigationLink {
                                    DetailView(meal: meal)
                                } label: {
                                    MealRow(meal: meal)
                                }
                            }
                        }
                    }
                    if let image = capturedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    } else {
                        // Placeholder view or text indicating no image captured
                    }
                    Spacer()
                    UploadButton(action: {
                        viewModel.handleUploadPhoto()
                        hasIngredients = false                    })
                }
            }
            .padding()
            .navigationTitle("Meal List")
        }
        .sheet(isPresented: $showCamera) { // Present camera view as a sheet
            ImagePickerView(image: $capturedImage, showCamera: $showCamera) // Bind image and showCamera state
        }
        .onAppear { // Call loadMeals on view appearance
            viewModel.loadMeals()
        }
        .onChange(of: capturedImage) { oldValue, newValue in
            if capturedImage != nil {
                getIngredients()
            }
        }
    }
    
    func getIngredients() {
        do {
            
            let config = MLModelConfiguration()
            let model = try IngredientDetector(configuration: config)
            guard let tempCapturedImage = capturedImage else {return}
            let resizedImage = tempCapturedImage.resized(to: CGSize(width: 416, height: 416))
            let resizedCapturedImage = self.resizeImage(image: resizedImage, targetSize: CGSizeMake(416.0, 416.0))
            let image = pixelBufferFromImage(image: resizedCapturedImage)
            let prediction = try model.prediction(imagePath: image, iouThreshold: 0.45, confidenceThreshold: 0.25)
            
//            for prediction in prediction {
//                //                    print("  Ingredient:", classification.label)
//                //                    print("    Confidence:", classification.confidence)
//                //                }
//            }
//            print(image)
            print("The prediction is:",prediction.coordinates)
//            print(prediction.featureNames)
//            print(prediction.coordinates)
            // more code here
            
//            if let classifications = prediction.classifications {
//                for classification in classifications {
//                    print("  Ingredient:", classification.label)
//                    print("    Confidence:", classification.confidence)
//                }
//            } else {
//                print("  No ingredients detected.")
//            }
        } catch {
            // something went wrong!
        }
    }
    
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
    
    func pixelBufferFromImage(image: UIImage) -> CVPixelBuffer {
        
        
        let ciimage = CIImage(image: image)
        //let cgimage = convertCIImageToCGImage(inputImage: ciimage!)
        let tmpcontext = CIContext(options: nil)
        let cgimage =  tmpcontext.createCGImage(ciimage!, from: ciimage!.extent)
        
        let cfnumPointer = UnsafeMutablePointer<UnsafeRawPointer>.allocate(capacity: 1)
        let cfnum = CFNumberCreate(kCFAllocatorDefault, .intType, cfnumPointer)
        let keys: [CFString] = [kCVPixelBufferCGImageCompatibilityKey, kCVPixelBufferCGBitmapContextCompatibilityKey, kCVPixelBufferBytesPerRowAlignmentKey]
        let values: [CFTypeRef] = [kCFBooleanTrue, kCFBooleanTrue, cfnum!]
        let keysPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        let valuesPointer =  UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        keysPointer.initialize(to: keys)
        valuesPointer.initialize(to: values)
        
        let options = CFDictionaryCreate(kCFAllocatorDefault, keysPointer, valuesPointer, keys.count, nil, nil)
        
        let width = cgimage!.width
        let height = cgimage!.height
        
        var pxbuffer: CVPixelBuffer?
        // if pxbuffer = nil, you will get status = -6661
        var status = CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                                         kCVPixelFormatType_32BGRA, options, &pxbuffer)
        status = CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0));
        
        let bufferAddress = CVPixelBufferGetBaseAddress(pxbuffer!);
        
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        let bytesperrow = CVPixelBufferGetBytesPerRow(pxbuffer!)
        let context = CGContext(data: bufferAddress,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: bytesperrow,
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue);
        context?.concatenate(CGAffineTransform(rotationAngle: 0))
        context?.concatenate(__CGAffineTransformMake( 1, 0, 0, -1, 0, CGFloat(height) )) //Flip Vertical
        //        context?.concatenate(__CGAffineTransformMake( -1.0, 0.0, 0.0, 1.0, CGFloat(width), 0.0)) //Flip Horizontal
        
        
        context?.draw(cgimage!, in: CGRect(x:0, y:0, width:CGFloat(width), height:CGFloat(height)));
        status = CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0));
        return pxbuffer!;
        
    }
    
}

struct MealRow: View {
    let meal: Meal
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 150, height: 130)
                .background(.white)
                .cornerRadius(15)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 0.50
                )
            Image(meal.imageUrl)
                .foregroundColor(.clear)
                .frame(width: 140, height: 105)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0, green: 0, blue: 0).opacity(0), .black]), startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(15)
                .offset(x: 0, y: -10)
            Text(meal.name)
                .font(Font.custom("SF Pro Text", size: 13))
                .foregroundColor(.black)
                .offset(x: -0.50, y: 55)
        }
        .frame(width: 177, height: 155)
    }
}




//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(model: <#IngredientDetector?#>)
//    }
//}

struct UploadButton: View {
    let action: () -> Void // Action to perform when button is tapped
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 343, height: 74)
                .background(Color(red: 0, green: 0.27, blue: 0.58))
                .cornerRadius(10)
            Text("Upload Photo")
                .font(Font.custom("SF Pro Text", size: 16).weight(.bold))
                .foregroundColor(.white)
        }
        .frame(width: 343, height: 74)
        .onTapGesture {
            action() // Perform the action when button is tapped
        }
    }
}

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { context in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return image
    }
}


//#Preview {
//    ContentView(model: <#IngredientDetector?#>)
//}
