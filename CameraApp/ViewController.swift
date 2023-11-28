//
//  ViewController.swift
//  CameraApp
//
//  Created by Tin/Perry/ServiceDev on 22/11/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var featuresCameraView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var songNameView: UIView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var timeVideoCollectionView: UICollectionView!
    private var starringScrollingOffset = CGPoint.zero
    private var collectionViewStyle = SnapFlowLayout()
    private var centerCell : TimeVideoCollectionViewCell?
    
   private var filterCellStyle = ZoomAndSnapFlowLayout(itemSize: CGSize(width: 42, height: 42), minimumLineSpacing: 35, activeDistance: 200, zoomFactor: 0.3)
//  private var filterCellStyle = ScalingCarouselCustomLayout(height: 42, ratio: 1.0)
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.filterCollectionView.dataSource = self
            self.filterCollectionView.delegate = self
            self.filterCollectionView.register(UINib(nibName: "FilterCameraCell", bundle: nil), forCellWithReuseIdentifier: "FilterCameraCell")
            self.filterCollectionView.collectionViewLayout = filterCellStyle
            self.timeVideoCollectionView.register(UINib(nibName: "TimeVideoCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "TimeVideoCollectionViewCell")
            self.timeVideoCollectionView.dataSource = self
            self.timeVideoCollectionView.delegate = self
            self.timeVideoCollectionView.collectionViewLayout = collectionViewStyle
            self.viewSetup()
        }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout: CGFloat = self.timeVideoCollectionView.bounds.width/5 - 10
        let sideInsert = (self.timeVideoCollectionView.frame.width / 2) - layout/2
        self.timeVideoCollectionView.contentInset = UIEdgeInsets(top: 0, left: sideInsert , bottom: 0, right: sideInsert)
        
        self.timeVideoCollectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredHorizontally, animated: false)

//        self.filterCollectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredHorizontally, animated: false)
        self.filterCellStyle.calculateSize()
    }
    
    func viewSetup(){
        //Camera View
        cameraView.layer.cornerRadius = 20
        cameraView.backgroundColor = .gray
        // Song View
        self.songNameView.layer.cornerRadius = 10
        self.songNameView.layer.masksToBounds = true
        self.songNameView.backgroundColor = .black.withAlphaComponent(0.4)
        //TimeVideo Collection
        self.timeVideoCollectionView.backgroundColor = .clear
        self.filterCollectionView.backgroundColor = .clear
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView {
            return 20
        } else if collectionView == timeVideoCollectionView{
            return 3
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == timeVideoCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeVideoCollectionViewCell", for: indexPath) as? TimeVideoCollectionViewCell else {return UICollectionViewCell()}
            return cell
        } else if collectionView == filterCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCameraCell", for: indexPath) as? FilterCameraCell else  {return UICollectionViewCell()}
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    
}





