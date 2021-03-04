//
//  ContentView.swift
//  SwiftUICamera
//
//  Created by Mohammad Azam on 2/10/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//

import SwiftUI


@available(iOS 14.0, *)
struct ContentView: View {
    
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var switch_test = false
    
    
    @EnvironmentObject var model:dataModel
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image(uiImage: model.img ?? UIImage(named: "placeholder")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 330, height: 330)
                    .clipped()
                    .cornerRadius(30)
                    .overlay(
                        Text(model.data?.error_msg ?? ( model.text ?? "请选择图片"))
                            .fontWeight(.heavy)
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(30)
                            .opacity(0.8)
                            .padding()
                        ,alignment: .bottomTrailing
                    )
                Spacer()
                
                //Text(model.data?.error_msg ?? ( model.data?.result![0].name ?? "等待输入..."))
                    //.font(.system(size: 20))
                //Spacer()
                //Text(model.data?.result[0].name ?? "good")
                
                //Text(str)
                Button(action: {
                    self.showSheet = true
                }){
                    HStack {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.title)
                        Text("选择图片")
                            .fontWeight(.semibold)
                            .font(.title)
                    }
                    .frame(minWidth: 0, maxWidth: 330)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                    .padding(.horizontal, 20)
                }
                //.padding()
                
                
                .actionSheet(isPresented: $showSheet) {
                    ActionSheet(title: Text("选择照片"), message: Text("Select Photo"), buttons: [
                        .default(Text("照片")) {
                            self.showImagePicker = true
                            self.sourceType = .photoLibrary
                            model.data=nil
                            model.text=nil
                            //model.isChoose="照片已选择,开始识别吧!"
                        },
                        .default(Text("拍摄")) {
                            self.showImagePicker = true
                            self.sourceType = .camera
                            model.data=nil
                            model.text=nil
                            //model.isChoose="照片已选择,开始识别吧!"
                        },
                        .cancel()
                    ])
                }
                
                Button(action:{
                    if let img=model.img{
                        let str2=toBase64(img: img)
                        //let str3="12345678"
                        //str = str2
                        api().getPost(str2:str2) { (data) in
                            self.model.data=data
                            //str=String(self.model.data!.result![0].score*100)
                        }
                        //print(dataa)
                        self.switch_test=true
                    }
                    
                }){
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.title)
                        Text("开始识别")
                            .fontWeight(.semibold)
                            .font(.title)
                    }
                    .frame(minWidth: 0, maxWidth: 330)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                    .padding(.horizontal, 20)
                    
                }
                .sheet(isPresented: self.$switch_test) {
                    resultView()
                }
                Spacer()
            }
            .navigationBarTitle("植物识别")
            
        }.sheet(isPresented: $showImagePicker) {
            //图片再此被传入model.img中
            ImagePicker(image: self.$model.img, isShown: self.$showImagePicker, sourceType: self.sourceType)
        }
    }
}



@available(iOS 14.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
