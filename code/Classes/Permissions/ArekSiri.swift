//
//  ArekSiri.swift
//  arek
//
//  Created by Ennio Masi on 13/03/2017.
//  Copyright © 2017 Ennio Masi. All rights reserved.
//

import Foundation

import Intents

open class ArekSiri: ArekBasePermission, ArekPermissionProtocol {
    open var identifier: String = "ArekSiri"
    
    public init() {
        let data = ArekLocalizationManager(permission: self.identifier)
        
        super.init(initialPopupData: ArekPopupData(title: data.initialTitle, message: data.initialMessage, image: data.image),
                   reEnablePopupData: ArekPopupData(title: data.reEnableTitle, message:  data.reEnableMessage, image: data.image))
    }
    
    public override init(configuration: ArekConfiguration? = nil,  initialPopupData: ArekPopupData? = nil, reEnablePopupData: ArekPopupData? = nil) {
        super.init(configuration: configuration, initialPopupData: initialPopupData, reEnablePopupData: reEnablePopupData)
    }
    
    open func status(completion: @escaping ArekPermissionResponse) {
        if #available(iOS 10.0, *) {
            INPreferences.requestSiriAuthorization({ (status) in
                switch status {
                case .authorized:
                    return completion(.authorized)
                case .restricted, .denied:
                    return completion(.denied)
                case .notDetermined:
                    return completion(.notDetermined)
                }
            })
        } else {
            return completion(.notAvailable)
        }
    }
    
    open func askForPermission(completion: @escaping ArekPermissionResponse) {
        if #available(iOS 10.0, *) {
            INPreferences.requestSiriAuthorization { (status) in
                switch status {
                case .authorized:
                    print("[🚨 Arek 🚨] 👨‍🏫 permission authorized by user ✅")
                    return completion(.authorized)
                case .restricted, .denied:
                    print("[🚨 Arek 🚨] 👨‍🏫 permission denied by user ⛔️")
                    return completion(.denied)
                case .notDetermined:
                    print("[🚨 Arek 🚨] 👨‍🏫 permission not determined 🤔")
                    return completion(.notDetermined)
                }
            }
        } else {
            print("[🚨 Arek 🚨] 👨‍🏫 permission only available from iOS 10 ⛔️")
            return completion(.notAvailable)
        }
    }
}
