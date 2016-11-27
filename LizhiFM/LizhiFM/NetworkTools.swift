//
//  NetworkTools.swift
//  LizhiFM
//
//  Created by JLB on 2016/11/24.
//  Copyright © 2016年 LB. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTools: NSObject {

    static let shareInstance = NetworkTools()

    lazy var HTTPSessionManager: AFHTTPSessionManager = {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/xml") as? Set<String>
        return manager
    }()

    func getData(id :String, index: UInt, completeHandler:@escaping (_ dict: NSDictionary)->(), errorHandler:@escaping (_ error: Error)->()) {
        let urlString = "https://t1.lizhi.fm/service/sonos/api"
        let url = URL(string: urlString)
        let bodyString = generateGetMetadataHTTPBody(id: id, index: index)
        let request = NSMutableURLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.addValue("\"http://www.sonos.com/Services/1.1#getMetadata\"", forHTTPHeaderField: "SOAPAction")
        request.addValue("text/xml; charset=\"utf-8\"", forHTTPHeaderField: "Content-Type")
        request.addValue("Linux UPnP/1.0 Sonos/31.3-22220 (MDCR_x86_64_MacBook8,1)", forHTTPHeaderField: "User-Agent")
        request.httpMethod = "POST"
        request.httpBody = bodyString.data(using: String.Encoding.utf8)

        let task = self.HTTPSessionManager.dataTask(with: request as URLRequest, completionHandler: {(response: URLResponse, data: Any?, error: Error?) in
            if (nil != error) {
                errorHandler(error!)
            } else {
                let dictResponse = NSDictionary.init(xmlData: data as! Data!)
                let soapBody = dictResponse?.object(forKey: "soap:Body") as! NSDictionary
                let metadataResponse = soapBody.object(forKey: "getMetadataResponse") as! NSDictionary
                let metadataResult = metadataResponse.object(forKey: "getMetadataResult") as! NSDictionary
                let mediaCollection = metadataResult.object(forKey: "mediaCollection") as! NSArray
                let arrayM = NSMutableArray(capacity: mediaCollection.count)
                let total = metadataResult.object(forKey: "total")

                for dict in mediaCollection {
                    let container = Container.mj_object(withKeyValues: dict)
                    arrayM.add(container!)
                }

                completeHandler(["data":arrayM.copy(), "total":total!])
            }
        })

        task.resume()
    }

    func getMetadata(container :Container?, index: UInt, completeHandler:@escaping (_ dict: NSDictionary)->(), errorHandler:@escaping (_ error: Error)->()) {
        let urlString = "https://t1.lizhi.fm/service/sonos/api"
        let url = URL(string: urlString)
        let id = (nil == container?.id) ? "root" : container?.id
        let bodyString = generateGetMetadataHTTPBody(id: id!, index: index)
        let request = NSMutableURLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.addValue("\"http://www.sonos.com/Services/1.1#getMetadata\"", forHTTPHeaderField: "SOAPAction")
        request.addValue("text/xml; charset=\"utf-8\"", forHTTPHeaderField: "Content-Type")
        request.addValue("Linux UPnP/1.0 Sonos/31.3-22220 (MDCR_x86_64_MacBook8,1)", forHTTPHeaderField: "User-Agent")
        request.httpMethod = "POST"
        request.httpBody = bodyString.data(using: String.Encoding.utf8)

        let task = self.HTTPSessionManager.dataTask(with: request as URLRequest, completionHandler: {(response: URLResponse, data: Any?, error: Error?) in
            if (nil != error) {
                errorHandler(error!)
            } else {
                let dictResponse = NSDictionary.init(xmlData: data as! Data!)
                let soapBody = dictResponse?.object(forKey: "soap:Body") as! NSDictionary
                let metadataResponse = soapBody.object(forKey: "getMetadataResponse") as! NSDictionary
                let metadataResult = metadataResponse.object(forKey: "getMetadataResult") as! NSDictionary
                let total = metadataResult.object(forKey: "total")
                var key: String

                if ("playlist" == container?.itemType) {
                    key = "mediaMetadata"

                    let mediaCollection = metadataResult.object(forKey: key) as! NSArray
                    let arrayM = NSMutableArray(capacity: mediaCollection.count)

                    for dict in mediaCollection {
                        let track = Track.mj_object(withKeyValues: dict)
                        arrayM.add(track!)
                    }

                    completeHandler(["data":arrayM.copy(), "total":total!])
                } else {
                    key = "mediaCollection"
                    let mediaCollection = metadataResult.object(forKey: key) as! NSArray
                    let arrayM = NSMutableArray(capacity: mediaCollection.count)

                    for dict in mediaCollection {
                        let container = Container.mj_object(withKeyValues: dict)
                        arrayM.add(container!)
                    }

                    completeHandler(["data":arrayM.copy(), "total":total!])
                }
            }
        })
        
        task.resume()
    }

    func generateGetMetadataHTTPBody(id: String, index: UInt) -> String {
        let indexString = String(index)
        let XMLString = "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Header><credentials xmlns=\"http://www.sonos.com/Services/1.1\"></credentials></soap:Header><soap:Body><getMetadata xmlns=\"http://www.sonos.com/Services/1.1\"><id>" + id + "</id><index>" + indexString + "</index><count>100</count></getMetadata></soap:Body></soap:Envelope>"
        return XMLString
    }

}
