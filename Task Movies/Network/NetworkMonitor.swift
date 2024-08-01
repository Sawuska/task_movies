//
//  NetworkMonitor.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import Alamofire
import RxSwift

final class NetworkMonitor {
    private let manager = NetworkReachabilityManager(host: "www.apple.com")

    func start() -> Observable<Bool> {
        return Observable<Bool>.create { observable in
            self.manager?.startListening(onUpdatePerforming: { status in
                observable.onNext(status == .reachable(.cellular) || status == .reachable(.ethernetOrWiFi))
            })
            return Disposables.create {
                self.manager?.stopListening()
            }
        }
    }
}
