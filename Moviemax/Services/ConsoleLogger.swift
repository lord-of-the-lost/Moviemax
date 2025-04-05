//
//  ConsoleLogger.swift
//  Moviemax
//
//  Created by Николай Игнатов on 04.04.2025.
//

import Foundation

struct ConsoleLogger {
    static func i(_ items: Any...) {
#if DEBUG
        print(items)
#endif
    }
}
