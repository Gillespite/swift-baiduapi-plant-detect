//
//  resultView.swift
//  SwiftUICamera
//
//  Created by Jill on 2021/2/24.
//  Copyright © 2021 Mohammad Azam. All rights reserved.
//

import SwiftUI





struct HandleBar: View {
    
    var body: some View {
        Rectangle()
            .frame(width: 50, height: 5)
            .foregroundColor(Color(.systemGray5))
            .cornerRadius(10)
    }
}
@available(iOS 14.0, *)
struct resultView: View {
    @EnvironmentObject var model:dataModel
    @State var str:String="正在计算...."
    
    var body: some View {
        
        VStack{
            HandleBar()
                .padding(.top)
            HStack{
                Spacer()
                Text(str)
                    .font(.title)
                    .fontWeight(.black)
                Spacer()
            }
            ScrollView{
                Spacer(minLength: 10)
                //Text(des)
                if let data=model.data{
                    ForEach(0..<data.result!.count){ i in
                        if let des=data.result?[i].baike_info?.description,let img=data.result?[i].baike_info?.image_url{
                            cell2(img_url: img, des: des,score: data.result![i].score, name: data.result![i].name)
                                .onAppear{
                                    if i==0{
                                        str="识别结果"
                                        model.text=data.result![i].name+"-"+String(format: "%.2f", data.result![i].score*100)+"%"
                                    }
                                }
                        }
                        else{
                            cell(score: data.result![i].score, name: data.result![i].name)
                                .onAppear{
                                    if i==0{
                                        str="识别结果"
                                        model.text=data.result![i].name+"-"+String(format: "%.2f", data.result![i].score*100)+"%"
                                    }
                                }
                        }
                    }
                }
            }
        }
    }
}
@available(iOS 14.0, *)
struct cell2: View {
    let img_url:String
    let des:String
    let score:Double
    let name:String
    var body: some View {
        HStack{
            NetworkImage(url:URL(string: img_url))
                .aspectRatio(contentMode: .fill)
                .frame(width:150,height:280)
                .clipped()
                .padding(.trailing,-7)
            VStack{
                HStack{
                    Spacer()
                    Text(name)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                }.padding(.trailing,9)
                .padding(.top,9)
                HStack{
                    Spacer()
                    Text("概率为")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                        .padding(.bottom,-3)
                        .padding(.trailing,-9)
                    
                    Text(String(format: "%.2f", score*100)+"%")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                }.padding(.trailing,9)
                Text(des)
                    .fontWeight(.heavy)
                    .font(.system(size:15))
                    .lineLimit(15)
                    .foregroundColor(.white)
                    .padding(.leading)
                    .padding(.trailing,9)
                    .shadow(radius: 4)
            }
        }
        .frame(height:250)
        .cornerRadius(20)
        
        .background(
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 5))
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("DarkGreen"),Color("LightGreen")]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
        )
        .padding(.horizontal)
    }
}


struct cell: View {
    let score:Double
    let name:String
    var body: some View {
        HStack{
            HStack{
                Text("概率为"+String(format: "%.2f", score*100)+"%")
                    .font(.system(size: 20))
                    .shadow(radius: 4)
                    .foregroundColor(.white)
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
                            gradient: Gradient(colors:[Color("LightGreen"),Color("DarkGreen")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
        )
        .padding(.horizontal)
        
    }
}


@available(iOS 14.0, *)
struct resultView_Previews: PreviewProvider {
    static var previews: some View {
        resultView()
    }
}


