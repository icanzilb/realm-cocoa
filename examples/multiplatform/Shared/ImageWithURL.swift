//
//  ImageWithURL.swift
//  RealmShowcase
//
//  Created by Marin Todorov on 3/31/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import Foundation

//
// Adds a method to all image view classes to load
// and image from a URL and display it
//

#if os(watchOS)
import WatchKit
extension WKInterfaceImage {
    func setImageWithURL(url: NSURL, placeholder: UIImage? = nil) {
        setImage(placeholder)
        NSURLSession.sharedSession().dataTaskWithURL(url) {[weak self] data, response, error in
            if let data = data {
                dispatch_async(dispatch_get_main_queue(), {
                    self?.setImage(UIImage(data: data))
                })
            }
        }.resume()
    }
}
#else

#if os(iOS) || os(tvOS)
import UIKit
typealias Image = UIImage
typealias ImageView = UIImageView
#elseif os(OSX)
import Cocoa
typealias Image = NSImage
typealias ImageView = NSImageView
#endif

extension ImageView {
    func setImageWithURL(url: NSURL, placeholder: Image? = nil) {
        image = placeholder
        NSURLSession.sharedSession().dataTaskWithURL(url) {[weak self] data, response, error in
            if let data = data {
                dispatch_async(dispatch_get_main_queue(), {
                    self?.image = Image(data: data)
                })
            }
        }.resume()
    }
}
#endif