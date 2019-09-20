//
//  ViewController.swift
//  AssignmentTest
//
//  Created by Krishna on 19/09/19.
//  Copyright © 2019 Krishna. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import PDFKit
import WebKit

class ViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    var pdfView = PDFView()
    var imgView = UIImageView()
    var webView = WKWebView()
    
    //MARK: - View lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        let aSerialQueue = DispatchQueue(label: "my.label")
        
        aSerialQueue.sync {
            // The code inside this closure will be executed synchronously.
            aSerialQueue.sync {
                // The code inside this closure should also be executed synchronously and on the same queue that is still executing the outer closure ==> It will keep waiting for it to finish ==> it will never be executed ==> Deadlock.
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - Collectionview Data source and delegate -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as! ContentCollectionViewCell
        switch indexPath.item {
        case 0:
            cell.lblTitle.text = "Video"
            cell.imgViewContent.image = #imageLiteral(resourceName: "video")
        case 1:
            cell.lblTitle.text = "Image"
            cell.imgViewContent.image = #imageLiteral(resourceName: "image")
        case 2:
            cell.lblTitle.text = "Doc"
            cell.imgViewContent.image = #imageLiteral(resourceName: "doc")
        case 3:
            cell.lblTitle.text = "Pdf"
            cell.imgViewContent.image = #imageLiteral(resourceName: "pdf")
        default:
            cell.lblTitle.text = ""
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            playVideo()
            print("Play video")
        case 1:
            displayImage()
            print("image")
        case 2:
            displayDocFile()
            print("Doc view")
        case 3:
            displayPdf()
            print("pdf view")
        default:
            print("")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 16) / 2, height: 165)
    }
    
    //MARK: - Display view -
    func playVideo() {
        guard let path = Bundle.main.path(forResource: "video", ofType:"mp4") else {
            debugPrint("video.mp4 not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    func displayImage(){
        imgView = UIImageView(frame: self.view.bounds)
        imgView.backgroundColor = .white
        imgView.image = #imageLiteral(resourceName: "iphoneX")
        imgView.contentMode = .scaleAspectFit
        self.view.addSubview(imgView)
        addBackButton()
    }
    
    func displayDocFile(){
        webView.frame = self.view.bounds
        self.view.addSubview(webView)
        let docURL = Bundle.main.path(forResource: "Test", ofType: ".doc")!
        let docContents = try! Data(contentsOf: URL(fileURLWithPath: docURL))
        let urlStr = "data:application/msword;base64," + docContents.base64EncodedString()
        let url = URL(string: urlStr)!
        let request = URLRequest(url: url)
        self.webView.load(request)
        addBackButton()
    }
    
    func displayPdf(){
        pdfView = PDFView(frame: self.view.bounds)
        pdfView.backgroundColor = .white
        self.view.addSubview(pdfView)
        // Fit content in PDFView.
        pdfView.autoScales = true
        // Load Sample.pdf file.
        let fileURL = Bundle.main.url(forResource: "sample", withExtension: "pdf")
        pdfView.document = PDFDocument(url: fileURL!)
        addBackButton()
    }
    
    //Add Back button
    func addBackButton(){
        let btnClose = UIButton(frame: CGRect(x: 0, y: 8, width: 100, height: 100))
        btnClose.addTarget(self, action: #selector(btnCloseClicked), for: .touchUpInside)
        btnClose.setTitleColor(UIColor.black, for: .normal)
        btnClose.setTitle("Close", for: .normal)
        self.view.addSubview(btnClose)
    }
    
    //MARK: - Button Action -
    @objc func btnCloseClicked(sender : UIButton){
        pdfView.removeFromSuperview()
        imgView.removeFromSuperview()
        webView.removeFromSuperview()
        sender.removeFromSuperview()
    }
}

