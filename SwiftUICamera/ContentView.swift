//
//  ContentView.swift
//  SwiftUICamera
//
//  Created by Mohammad Azam on 2/10/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var switch_test = false
    //@State private var image: UIImage?
    
    @State var str:String!="fuck"
    
    @EnvironmentObject var model:dataModel
    
    var body: some View {
        
        NavigationView {
            VStack {
                Spacer()
                Image(uiImage: model.img ?? UIImage(named: "placeholder")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(30)
                    .frame(minWidth: 0, idealWidth: 250, maxWidth: 300, minHeight: 0, idealHeight: 300, maxHeight: 340)
                Spacer()
                
                Text(model.data?.error_msg ?? ( model.data?.result![0].name ?? "等待输入..."))
                    .font(.system(size: 20))
                Spacer()
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
                        },
                        .default(Text("拍摄")) {
                            self.showImagePicker = true
                            self.sourceType = .camera
                        },
                        .cancel()
                    ])
                }
                
                Button(action:{
                    if let img=model.img{
                        let str2=toBase64(img: img)
                        //let str3="12345678"
                        str = str2
                        api().getPost(str2:str) { (data) in
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
            ImagePicker(image: self.$model.img, isShown: self.$showImagePicker, sourceType: self.sourceType)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}