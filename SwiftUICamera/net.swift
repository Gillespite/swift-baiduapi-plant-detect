//
//  net.swift
//  SwiftUICamera
//
//  Created by Jill on 2021/2/24.
//  Copyright © 2021 Mohammad Azam. All rights reserved.
//

import Foundation
import SwiftUI


class dataModel:ObservableObject{
    @Published var data:test_model? = nil
    @Published var img:UIImage? = nil
}


struct test_model:Codable{
    struct baike_info_item:Codable{
        let baike_url:String?
        let image_url:String?
        let description:String?
    }
    struct result_item:Codable {
        let score:Double
        let name:String
        let baike_info:baike_info_item?
    }
    let log_id:Int
    let result:[result_item]?
    let error_msg:String?
    let error_code:Int?
}

func base64ToBase64url(base64: String) -> String {
    let base64url = base64
        .replacingOccurrences(of: "+", with: "%2B")
        .replacingOccurrences(of: "/", with: "%2F")
        .replacingOccurrences(of: "=", with: "%3D")
        //.replacingOccurrences(of: "\n", with: "🃏")
    return base64url
}

func toBase64 (img: UIImage) -> String {
    let temp=img.jpegData(compressionQuality: 0.05)?.base64EncodedString() ?? ""
    let temp2=base64ToBase64url(base64: temp)
    return temp2
}


class api{
    func getPost(str2:String,completion:@escaping (test_model)->()){
        let token="24.e460797add0e73a6ea80c5c6ec758cc4.2592000.1616653240.282335-23691787"
        let url="https://aip.baidubce.com/rest/2.0/image-classify/v1/plant?access_token="+token
        
        
        let uri=URL(string: url)
        var request=URLRequest(url: uri!)
        
        //print("str!!!!!!!!!!!:"+str)
        request.httpMethod="POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        
        //不能用这种方式!!!!! 用下面三行的办法!!!!!
        //let params:[String : Any]=["image":str2]
        //request.httpBody = try! JSONSerialization.data(withJSONObject: params)
        let post="image="+str2+"&top_num=4&baike_num=4"
        //let post="image="+str2+"&baike_num=4&top_num=4"
        let post2=post.data(using: .utf8)
        request.httpBody=post2
        
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            //print(data!)
            let data=try! JSONDecoder().decode(test_model.self, from: data!)
            //print(posts.access_token)
            DispatchQueue.main.async {
                completion(data)
            }
        }
        .resume()
    }
}

//let uri=URL(string: url+token)
//URLSession.shared.dataTask(with: uri!) { (data, _, _) in
//    let posts=try! JSONDecoder().decode(test_model.self, from: data!)
//    //print(posts.access_token)
//    DispatchQueue.main.async {
//        completion(posts)
//    }
//}
//.resume()

//Text(str)
//    .padding()
//    .onAppear{
//        api().getPost{ (post) in
//            str=post.access_token
//        }
//    }
