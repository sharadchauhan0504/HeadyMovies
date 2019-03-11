//
//  ImageDownloader.swift
//  GitHubSearch
//
//  Created by Sharad S. Chauhan on 04/01/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import UIKit

class ImageDownloader: UIImageView {
    
    let imageCache = NSCache<NSString, AnyObject>()
    
    func downloadImageFrom(url: URL, imageMode: UIView.ContentMode) {
        contentMode = imageMode
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
        } else {
            let activityIndicator    = UIActivityIndicatorView(style: .white)
            activityIndicator.center = self.center
            self.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    let imageToCache = UIImage(data: data)
                    self.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                    self.image = imageToCache
                }
                }.resume()
        }
    }
}
