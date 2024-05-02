//
//  ContentView.swift
//  NC1_TIMCooker
//
//  Created by Eldenabih Tavirazin Lutvie on 29/04/24.
//

import SwiftUI
import Photos

struct ContentView: View {
    @ObservedObject private var viewModel = MealListViewModel()
    @State private var hasIngredients = true
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    
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
                    //                    Text("Take a photo to scan your ingredients!").multilineTextAlignment(.center)
                    //                    UploadButton(action: {
                    //                        hasIngredients = true
                    //                    })
                    //                    Button("Upload Photo") {
                    //                        hasIngredients = true
                    //                    }
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
                    Spacer()
                    UploadButton(action: {
                        viewModel.handleUploadPhoto()
//                        hasIngredients = false
                    })
                    //                    Button("Upload Photo") {
                    //                        hasIngredients = false
                    //                    }.background(.blue)
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
    }
    
}

//let mealData = [
//    Meal(name: "Pasta Primavera", imageUrl: "spaghetti"),
//    Meal(name: "Chicken Fajitas", imageUrl: "corndog"),
//    Meal(name: "Vegetarian Chili", imageUrl: "pie"),
//    Meal(name: "Pasta Primavera", imageUrl: "spaghetti"),
//    Meal(name: "Chicken Fajitas", imageUrl: "corndog"),
//    Meal(name: "Vegetarian Chili", imageUrl: "pie"),
//    Meal(name: "Pasta Primavera", imageUrl: "spaghetti"),
//    Meal(name: "Chicken Fajitas", imageUrl: "corndog"),
//    Meal(name: "Vegetarian Chili", imageUrl: "pie"),
//    Meal(name: "Pasta Primavera", imageUrl: "spaghetti"),
//    Meal(name: "Chicken Fajitas", imageUrl: "corndog"),
//    Meal(name: "French Omelette", imageUrl: "omelette"),
//]

//struct Meal: Identifiable {
//    let id = UUID()
//    let name: String
//    let imageUrl: String
//}

//struct MealRow: View {
//    let meal: Meal
//
//    var body: some View {
//        HStack {
//            Image(meal.imageUrl)
//                .resizable()
//                .frame(width: 50, height: 50)
//                .clipped()
//            Text(meal.name)
//        }
//    }
//}

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




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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


#Preview {
    ContentView()
}
