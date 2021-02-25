//
//  resultView.swift
//  SwiftUICamera
//
//  Created by Jill on 2021/2/24.
//  Copyright © 2021 Mohammad Azam. All rights reserved.
//

import SwiftUI



struct resultView: View {
    @EnvironmentObject var model:dataModel
    @State var str:String="正在计算...."
    var body: some View {
        NavigationView {
            VStack{
                Text(str)
                if let data=model.data {
                    ForEach(0..<data.result!.count){
                        cell(score: data.result![$0].score, name: data.result![$0].name)
                            .onAppear{
                                str="结果为"
                            }
                    }
                }
            }
        }.navigationBarTitle("识别结果")
    }
}

struct cell: View {
    let score:Double
    let name:String
    var body: some View {
        VStack{
            HStack{
                Text("概率为"+String(format: "%.2f", score*100)+"%")
                    .font(.system(size: 20))
                    .shadow(radius: 4)
                Spacer()
                
                VStack(alignment: .trailing){
                    Text(name)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    Text("Spaceholder")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
            }
            .padding(.vertical,12)
            
        }
        .frame(height: 80)
        .padding(.leading, 23)
        .padding(.trailing, 15)
        .background(
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 4))
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.white,.green]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
        )
        .padding(.horizontal)
        
    }
}

struct resultView_Previews: PreviewProvider {
    static var previews: some View {
        resultView()
    }
}


