//
//  CellStyle.swift
//  CameraApp
//
//  Created by Tin/Perry/ServiceDev on 23/11/2023.
//

import UIKit

class SnapFlowLayout : UICollectionViewFlowLayout{
    enum FlowLayout : Int {
        case style3d = 1
        case normal
    }
    var currentStyle : FlowLayout = .normal
    let activeDistance: CGFloat = 10
    var zoomFactor: CGFloat {
        return currentStyle == .normal ? 0.0 : 72/32
    }
    override init(){
        super.init()
        scrollDirection = .horizontal
        minimumLineSpacing = 11
        itemSize = currentStyle == .normal ? CGSize(width: 59, height: 31) : CGSize(width: 32, height: 32)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepare() {
        guard let collectionView = self.collectionView else { fatalError() }
        
        let horizontalInsets = 10.0
        let verticalInsets = (collectionView.frame.height - collectionView.adjustedContentInset.top -
                              collectionView.adjustedContentInset.bottom - itemSize.height) / 2
        
        self.sectionInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets,
                                         bottom: verticalInsets, right: horizontalInsets)
        
        super.prepare()
    }
  
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView!.contentInset.left
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView!.bounds.size.width, height: collectionView!.bounds.size.height)
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        
        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }

    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as? UICollectionViewFlowLayoutInvalidationContext
        context?.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context!
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            guard let collectionView = collectionView else { return nil }
        
            let rectAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
            let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
            
            for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
                let distance = visibleRect.midX - attributes.center.x
                let normalizedDistance = distance / activeDistance
                guard let cell = collectionView.cellForItem(at: attributes.indexPath) else {return rectAttributes}
                if currentStyle == .normal {
                    if distance.magnitude < activeDistance {
                        cell.backgroundColor = .black.withAlphaComponent(0.7)
                        cell.layer.cornerRadius = 15
                        cell.clipsToBounds = true
                    } else {
                        cell.backgroundColor = .clear
                    }
                }else {
                    if distance.magnitude < activeDistance {
                        let zoom = 1 + zoomFactor * (1 - normalizedDistance.magnitude)
                        attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                        attributes.zIndex = Int(zoom.rounded())
                        cell.layer.borderWidth = 1
                        cell.layer.cornerRadius = attributes.bounds.height/2
                        cell.layer.borderColor = UIColor.black.cgColor
                        cell.clipsToBounds = true
                    } else {
                        cell.backgroundColor = .clear
                        cell.layer.borderWidth = 0.0
                    }
                }
             
            }

            return rectAttributes
        }
    
}


public class ZoomAndSnapFlowLayout: UICollectionViewFlowLayout {
    
    private var activeDistance: CGFloat = 120
    private var zoomFactor: CGFloat = 0.0
    
    override init() {
        super.init()
        
        scrollDirection = .horizontal
        minimumLineSpacing = 30
        minimumInteritemSpacing = 40
        itemSize = CGSize(width: 75, height: 150)
    }
    
    convenience public init(itemSize: CGSize) {
        self.init()
        self.itemSize = itemSize
    }
    
    convenience public init(itemSize: CGSize, minimumLineSpacing: CGFloat) {
        self.init()
        self.itemSize = itemSize
        self.minimumLineSpacing = minimumLineSpacing
    }
    
    convenience public init(itemSize: CGSize, minimumLineSpacing: CGFloat, activeDistance: CGFloat, zoomFactor: CGFloat) {
        self.init()
        self.itemSize = itemSize
        self.minimumLineSpacing = minimumLineSpacing
        self.activeDistance = activeDistance
        self.zoomFactor = zoomFactor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func prepare() {
        guard let collectionView = collectionView else { fatalError() }
        let verticalInsets = (collectionView.frame.height - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom - itemSize.height) / 2
        let horizontalInsets = (collectionView.frame.width - collectionView.adjustedContentInset.right - collectionView.adjustedContentInset.left - itemSize.width) / 2
        sectionInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
        
        super.prepare()
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        let rectAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size )
        for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
            let distance = visibleRect.midX - attributes.center.x
            let zoom = 2 -  distance.magnitude/200
            attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
            if distance.magnitude < self.activeDistance {
                
    
                attributes.zIndex = Int(zoom.rounded())
            }
        }
        
        return rectAttributes
    }


    
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }
        
        // Add some snapping behaviour so that the zoomed cell is always centered
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2
        
        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate layout so that every cell get a chance to be zoomed when it reaches the center of the screen
        return true
    }
    
    override public func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
    
}
