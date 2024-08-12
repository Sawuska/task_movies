//
//  NetworkMonitor.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import Alamofire
import RxSwift

// Unfortunately, 'onUpdatePerforming' has issues on the Simulator, it's only triggered
// when connection disappears, not when it appears again. The reason for this issue is
// a problem in the Simulator itself. On the device it works correctly.

final class NetworkMonitor {

    static let shared = NetworkMonitor()

    private let manager = NetworkReachabilityManager(host: "www.apple.com")
    private let isConnectedSubject = BehaviorSubject(value: true)

    var isConnected: Bool {
        manager?.isReachable ?? false
    }

    private init() {
        self.manager?.startListening(onUpdatePerforming: { status in
            let isConnected = status == .reachable(.cellular) || status == .reachable(.ethernetOrWiFi)
            self.isConnectedSubject.onNext(isConnected)
        })
    }

    func observeConnectedStatus() -> Observable<Bool> {
        isConnectedSubject
    }
}
