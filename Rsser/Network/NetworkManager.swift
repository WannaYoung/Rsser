//
//  NetworkManager.swift
//  KLine
//
//  Created by yang on 2018/5/31.
//  Copyright © 2018年 yang. All rights reserved.
//

import UIKit
import HandyJSON
import Networking

class NetworkManager: NSObject {
    
    // 单例share
    static let share = NetworkManager()
    private override init(){ }
    
    // MARK: - GET请求
    
    /// GET网络请求
    ///
    /// - Parameters:
    ///   - homeUrl: 服务器host
    ///   - path: 请求api路径
    ///   - parama: 请求参数
    ///   - successHandler: 请求成功回调
    ///   - failureHandler: 请求失败回调
    func getDataWith<T: HandyJSON>(homeUrl: String = host, path: String, parama: [String: Any], successHandler: @escaping (T) -> Swift.Void, failureHandler: ((NSError) -> Swift.Void)? = nil) {
        let networking = Networking(baseURL: homeUrl)
        networking.get(path, parameters: parama) { (result) in
            switch result {
            case .success(let successResponse):
                NetworkHelper.networkPrint(host: homeUrl+path, request: parama, response: successResponse.dictionaryBody)
                if let response = T.deserialize(from: successResponse.dictionaryBody) {
                    successHandler(response)
                }
                break
            case .failure(let failureResponse):
                failureHandler?(failureResponse.error)
                break
            }
        }
    }
    
    // MARK: - POST请求
    
    /// POST网络请求
    ///
    /// - Parameters:
    ///   - homeUrl: 服务器host
    ///   - path: 请求api路径
    ///   - parama: 请求参数
    ///   - successHandler: 请求成功回调
    ///   - failureHandler: 请求失败回调
    func postDataWith<T: HandyJSON>(homeUrl: String = host, path: String, parama: [String: Any], successHandler: @escaping (T) -> Swift.Void, failureHandler: ((NSError) -> Swift.Void)? = nil) {
        let networking = Networking(baseURL: homeUrl)
        networking.post(path, parameterType: .json, parameters: parama) { (result) in
            switch result {
            case .success(let successResponse):
                NetworkHelper.networkPrint(host: homeUrl+path, request: parama, response: successResponse.dictionaryBody)
                if let response = T.deserialize(from: successResponse.dictionaryBody) {
                    successHandler(response)
                }
                break
            case .failure(let failureResponse):
                failureHandler?(failureResponse.error)
                break
            }
        }
    }
    
   // MARK: - 上传图片

    /// 上传图片
    ///
    /// - Parameters:
    ///   - homeUrl: 服务器host
    ///   - path: 请求api路径
    ///   - uploadImage: 上传的图片
    ///   - parama: 请求参数
    ///   - successHandler: 请求成功回调
    ///   - failureHandler: 请求失败回调
    func uploadImageWith<T: HandyJSON>(homeUrl: String = "", path: String = "", uploadImage: UIImage, parama: [String: Any] = [: ], successHandler: @escaping (T) -> Swift.Void, failureHandler: ((NSError) -> Swift.Void)? = nil) {
        let networking = Networking(baseURL: homeUrl)
        let imageData = uploadImage.jpegData(compressionQuality: 0.8)
        let imagePart = FormDataPart(type: .jpg, data: imageData!, parameterName: "photoFile", filename: "xxx.jpg")
        networking.post(path, parameters: parama, parts: [imagePart]) { (result) in
            switch result {
            case .success(let successResponse):
                NetworkHelper.networkPrint(host: homeUrl+path, request: parama, response: successResponse.dictionaryBody)
                if let response = T.deserialize(from: successResponse.dictionaryBody) {
                    successHandler(response)
                }
                break
            case .failure(let failureResponse):
                failureHandler?(failureResponse.error)
                break
            }
        }
    }
    
}
