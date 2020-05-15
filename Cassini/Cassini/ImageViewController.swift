//
//  ViewController.swift
//  Cassini
//
//  Created by Paramveer  on 2020-01-27.
//  Copyright © 2020 Paramveer . All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

var imageView = UIImageView()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    {
        didSet {
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 4
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    private var image: UIImage?{
        get {
            return imageView.image
        }
        set{
            spinner?.stopAnimating()
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            
        }
    }
    
    var imageURL:URL? {
        didSet {
            imageView.image = nil
            if view.window != nil{
               fetchImage()
                
            }
            
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil{
            fetchImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if imageURL == nil {
            imageURL = DemoURL.localIMG
        }
    }
    
    private func fetchImage(){
        if let url = imageURL {
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.imageURL{
                        self?.image = UIImage(data: imageData)
                    }
                }
                
            }
            
        }
        
    }


}

