//
//  Reachability.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import Foundation
import SystemConfiguration
import CoreTelephony

func isNetworkConnectionExist() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)

    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }

    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }

    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    let isWWAN = flags.contains(.isWWAN)
    if isReachable {
        if isWWAN {
            let networkInfo = CTTelephonyNetworkInfo()
            let carrierType = networkInfo.serviceCurrentRadioAccessTechnology
            print(carrierType?.first?.value.description ?? "Unknow")
        }
    }
    return (isReachable && !needsConnection)
}
