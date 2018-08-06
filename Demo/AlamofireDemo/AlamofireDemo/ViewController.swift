//
//  ViewController.swift
//  AlamofireDemo
//
//  Created by bob on 2018/7/2.
//  Copyright © 2018年 wenbo. All rights reserved.
//

import UIKit
import Alamofire
import Tiercel

class ViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var url = "http://aiauat.4d.com.hk.s3-website-ap-southeast-1.amazonaws.com/IPOS/salesPresenter.zip"
    
    let downloadManager = TRManager()
    
    var cancelledData:Data?
    var downloadRequest:DownloadRequest!
    
    //指定下载路径
    let destination:DownloadRequest.DownloadFileDestination = { _, response in
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentURL.appendingPathComponent(response.suggestedFilename!)
        return (fileURL,[.removePreviousFile,.createIntermediateDirectories])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func biginAction(_ sender: Any) {
        
        print("开始下载")
//
//        if let cancelledData = self.cancelledData {
//            print("断点续传下载")
//            self.downloadRequest = Alamofire.download(resumingWith: cancelledData)
//        } else {
//            print("普通下载")
//            self.downloadRequest = Alamofire.download(self.url)
//        }
//        let utilityQueue = DispatchQueue.global(qos: .utility)
//
//        self.downloadRequest.downloadProgress(queue: utilityQueue) { progress in
//            self.progressView.setProgress(Float(progress.fractionCompleted), animated: true)
//            print("当前进度:\(progress.fractionCompleted*100)%")
//        }
//
//        self.downloadRequest.responseData { response in
//            switch response.result {
//            case .success( _):
//                DispatchQueue.main.async {
//                    print("路径:\(String(describing: response.destinationURL?.path))")
//                }
//            case .failure:
//                self.cancelledData = response.resumeData
//            }
//        }
        
        self.downloadManager.download(self.url, fileName: "小黄人1.mp4", progressHandler: { (task) in
            let progress = task.progress.fractionCompleted
            print("下载中, 进度：\(progress)")
        }, successHandler: { (task) in
            print("下载完成")
        }) { (task) in
            print("下载失败")
        }
    }
    
    @IBAction func stopAction(_ sender: Any) {
        print("暂停下载")
//        self.downloadRequest.cancel()
        
        self.downloadManager.cancel(self.url)
    }
    
    func test1() -> Void {
        
//        Alomofire.req
        Alamofire.request("https://httpbin.org/get").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
        
    }


}

