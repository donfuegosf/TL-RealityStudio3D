// Enums.swift
import Foundation

enum ActiveAlert: Identifiable {
    case clearConfirm
    case error
    case unsupportedFile
    case deleteConfirm(String)

    var id: String {
        switch self {
        case .clearConfirm:
            return "clearConfirm"
        case .deleteConfirm(let fileName):
            return "deleteConfirm_\(fileName)"
        case .error:
            return "error"
        case .unsupportedFile:
            return "unsupportedFile"
        }
    }
}
