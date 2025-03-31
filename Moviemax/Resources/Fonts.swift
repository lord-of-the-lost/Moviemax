//
//  Fonts.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

import UIKit

enum AppFont {
    case system
    case plusJakartaRegular
    case plusJakartaExtraLight
    case plusJakartaLight
    case plusJakartaMedium
    case plusJakartaSemiBold
    case plusJakartaBold
    case plusJakartaExtraBold
    
    case montserratThin
    case montserratExtraLight
    case montserratLight
    case montserratRegular
    case montserratMedium
    case montserratSemiBold
    case montserratBold
    case montserratExtraBold
    case montserratBlack
    
    func withSize(_ size: CGFloat) -> UIFont {
        switch self {
        case .system:
            return .systemFont(ofSize: size)
            
        case .plusJakartaRegular:
            let font = UIFont(name: "PlusJakartaSans-Regular", size: size)
            assert(font != nil, "PlusJakartaSans-Regular font not found")
            return font ?? .systemFont(ofSize: size)
            
        case .plusJakartaExtraLight:
            let font = UIFont(name: "PlusJakartaSansRoman-ExtraLight", size: size)
            assert(font != nil, "PlusJakartaSansRoman-ExtraLight font not found")
            return font ?? .systemFont(ofSize: size)
            
        case .plusJakartaLight:
            let font = UIFont(name: "PlusJakartaSansRoman-Light", size: size)
            assert(font != nil, "PlusJakartaSansRoman-Light font not found")
            return font ?? .systemFont(ofSize: size)
            
        case .plusJakartaMedium:
            let font = UIFont(name: "PlusJakartaSansRoman-Medium", size: size)
            assert(font != nil, "PlusJakartaSansRoman-Medium font not found")
            return font ?? .systemFont(ofSize: size)
            
        case .plusJakartaSemiBold:
            let font = UIFont(name: "PlusJakartaSansRoman-SemiBold", size: size)
            assert(font != nil, "PlusJakartaSansRoman-SemiBold font not found")
            return font ?? .systemFont(ofSize: size)
            
        case .plusJakartaBold:
            let font = UIFont(name: "PlusJakartaSansRoman-Bold", size: size)
            assert(font != nil, "PlusJakartaSansRoman-Bold font not found")
            return font ?? .systemFont(ofSize: size)
            
        case .plusJakartaExtraBold:
            let font = UIFont(name: "PlusJakartaSansRoman-ExtraBold", size: size)
            assert(font != nil, "PlusJakartaSansRoman-ExtraBold font not found")
            return font ?? .systemFont(ofSize: size)
            
        case .montserratThin:
            let font = UIFont(name: "Montserrat-Thin", size: size)
            assert(font != nil, "Montserrat-Thin font not found")
            return font ?? .systemFont(ofSize: size)
            
        case .montserratExtraLight:
            let font = UIFont(name: "MontserratRoman-ExtraLight", size: size)
            assert(font != nil, "MontserratRoman-ExtraLight font not found")
            return font ?? .systemFont(ofSize: size)
            
        case .montserratLight:
            let font = UIFont(name: "MontserratRoman-Light", size: size)
            assert(font != nil, "MontserratRoman-Light font not found")
            return font ?? .systemFont(ofSize: size)
            
        case .montserratRegular:
            let font = UIFont(name: "MontserratRoman-Regular", size: size)
            assert(font != nil, "MontserratRoman-Regular font not found")
            return font ?? .systemFont(ofSize: size)
            
        case .montserratMedium:
            let font = UIFont(name: "MontserratRoman-Medium", size: size)
            assert(font != nil, "MontserratRoman-Medium font not found")
            return font ?? .systemFont(ofSize: size)
            
        case .montserratSemiBold:
            let font = UIFont(name: "MontserratRoman-SemiBold", size: size)
            assert(font != nil, "MontserratRoman-SemiBold font not found")
            return font ?? .systemFont(ofSize: size)
            
        case .montserratBold:
            let font = UIFont(name: "MontserratRoman-Bold", size: size)
            assert(font != nil, "MontserratRoman-Bold font not found")
            return font ?? .systemFont(ofSize: size)
            
        case .montserratExtraBold:
            let font = UIFont(name: "MontserratRoman-ExtraBold", size: size)
            assert(font != nil, "MontserratRoman-ExtraBold font not found")
            return font ?? .systemFont(ofSize: size)
            
        case .montserratBlack:
            let font = UIFont(name: "MontserratRoman-Black", size: size)
            assert(font != nil, "MontserratRoman-Black font not found")
            return font ?? .systemFont(ofSize: size)
        }
    }
}
