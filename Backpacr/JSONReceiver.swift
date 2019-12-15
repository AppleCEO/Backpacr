//
//  JSONReceiver.swift
//  Backpacr
//
//  Created by joon-ho kil on 2019/12/11.
//  Copyright © 2019 joon-ho kil. All rights reserved.
//

import Foundation
import RxSwift

struct JSONReceiver {
    static func getList(page: Int) -> Observable<ProductList> {
        let url = "https://2jt4kq01ij.execute-api.ap-northeast-2.amazonaws.com/prod/products?page="+String(page)
        let result = Observable.just(url)
            .compactMap {
                URL(string: $0)
            }.map { urlString in
                Observable<ProductList>.create { observable in
                    let task = URLSession.shared.dataTask(with: urlString) { (data, response, error) in
                        guard let data = data else {
                            print("load data failed")
                            return
                        }
                        
                        let decoder: JSONDecoder = JSONDecoder()
                        do {
                            let parsingResult =  try decoder.decode(ProductList.self, from: data)
                            observable.onNext(parsingResult)
                            observable.onCompleted()
                        } catch {
                            observable.onError(error)
                        }
                    }
                    task.resume()
                    return Disposables.create()
                }
            }.flatMap { $0 }

        return result
    }
    
    static func getDetail(id: Int) -> Observable<ProductDetail> {
        let url = "https://2jt4kq01ij.execute-api.ap-northeast-2.amazonaws.com/prod/products/"+String(id)
        let result = Observable.just(url)
            .compactMap {
                URL(string: $0)
            }.map { urlString in
                Observable<ProductDetail>.create { observable in
                    let task = URLSession.shared.dataTask(with: urlString) { (data, response, error) in
                        guard let data = data else {
                            print("load data failed")
                            return
                        }
                        
                        let decoder: JSONDecoder = JSONDecoder()
                        do {
                            let productDetail =  try decoder.decode(ProductDetail.self, from: data)
                            observable.onNext(productDetail)
                            observable.onCompleted()
                        } catch {
                            observable.onError(error)
                        }
                    }
                    task.resume()
                    return Disposables.create()
                }
            }.flatMap { $0 }

        return result
    }
}
