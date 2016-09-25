//
//  HBNetWorkTools.swift
//  weibo
//
//  Created by hebing on 16/9/25.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit
import AFNetworking

enum HTTPMethod {
    case GET
    case POST
    
}

class HBNetWorkTools: AFHTTPSessionManager {
    static let sharedTools:AFHTTPSessionManager={
        let tool: AFHTTPSessionManager = AFHTTPSessionManager()
//        tool.responseSerializer.acceptableContentTypes=
            tool.responseSerializer.acceptableContentTypes?.insert("text/html")
//        tool.responseSerializer.acceptableContentTypes=//OC里面可以接收,swift里面没有返回值
            tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tool
        
    }()
    

        func request(method:HTTPMethod, URLString: String, parameters: Any?,finish:@escaping (Any?,Error? )->())-> () {
            
            let successCallBack = {(task: URLSessionDataTask ,responsObject: Any?)-> () in
                
                finish(responsObject, nil)
                
            }
            let errorCallBack = {(task: URLSessionDataTask? ,error: Error?)-> () in
                
                finish(nil, error)
                
            }
            
        
        if method == .GET {
            
            self.get(URLString, parameters: parameters, progress: nil, success: successCallBack, failure: errorCallBack)
        }else{
            
             self.post(URLString, parameters: parameters, progress: nil, success: successCallBack, failure: errorCallBack)
            
            
            
        }
        
        
    }
    
    
    

}
