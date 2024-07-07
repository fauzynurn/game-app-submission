//
//  NetworkUtil.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 05/06/24.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    private func defaultValue<T>(forType type: T.Type) -> T {
        switch type {
        case is String.Type:
            return ("" as? T)!
        case is Int.Type:
            return (0 as? T)!
        case is Double.Type:
            return (0.0 as? T)!
        case is [String: Any].Type:
            return ([String: Any]() as? T)!
        case is [[String: Any]].Type:
            return ([[String: Any]()] as? T)!
        default:
            return ("" as? T)!
        }
    }
    func getValue<ValueType>(as type: ValueType.Type, fromKey key: String) -> ValueType {
        if let value = self[key] as? ValueType {
            return value
        } else {
            return defaultValue(forType: ValueType.self)
        }
    }
}
