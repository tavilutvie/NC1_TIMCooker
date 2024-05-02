//
//  DetailView.swift
//  NC1_TIMCooker
//
//  Created by Eldenabih Tavirazin Lutvie on 01/05/24.
//

import SwiftUI

struct DetailView: View {
  let meal: Meal

    var body: some View {
        ScrollView{
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 300, height: 200)
                    .background(
                        Image(meal.imageUrl)
                        //          AsyncImage(url: URL(string: meal.imageUrl)) // Replace with your actual image URL
                        //            .placeholder { ProgressView() }
                        //            .error { Image("placeholder-image") } // Replace with a placeholder image
                    )
                    .cornerRadius(25)
                    .offset(x: 0, y: -295.50)
                
                VStack{
                    Text(meal.name)
                        .font(Font.custom("SF Pro", size: 20).weight(.bold))
                        .lineSpacing(22)
                        .foregroundColor(.black)
                        .offset(x: 0, y: 200)
                    Text("Ingredients:\n" + meal.ingredients + "\n\nSteps:\n" + meal.instructions)
                    //        .font(Font.custom("SF Pro", size: 17).weight())
                        .lineSpacing(22)
                        .foregroundColor(.black)
                        .offset(x: 0, y: 230)
                }
            }
            .frame(width: 344, height: 791)
        }
    }
}

//#Preview {
//    DetailView()
//}
