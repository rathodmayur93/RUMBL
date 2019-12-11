//
//  PresentAnimator.swift
//  RUMBL
//
//  Created by ds-mayur on 12/10/19.
//  Copyright © 2019 Mayur Rathod. All rights reserved.
//

import Foundation
import UIKit

/// A way that view controllers can provide information about the photo-detail transition animation.
public protocol PhotoDetailTransitionAnimatorDelegate: class {

    /// Called just-before the transition animation begins. Use this to prepare your VC for the transition.
    func transitionWillStart()

    /// Called right-after the transition animation ends. Use this to clean up your VC after the transition.
    func transitionDidEnd()

    /// The animator needs a UIImageView for the transition;
    /// eg the Photo Detail screen should provide a snapshotView of its image,
    /// and a collectionView should do the same for its image views.
    func referenceImage() -> UIImage?

    /// The frame for the imageView provided in `referenceImageView(for:)`
    func imageFrame() -> CGRect?
}

/// Controls the "noninteractive push animation" used for the PhotoDetailViewController
public class PhotoDetailPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate let fromDelegate: PhotoDetailTransitionAnimatorDelegate
    fileprivate let photoDetailVC: PlayerViewController

    /// The snapshotView that is animating between the two view controllers.
    fileprivate let transitionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()

    /// If fromDelegate isn't PhotoDetailTransitionAnimatorDelegate, returns nil.
    init?(
        fromDelegate: Any,
        toPhotoDetailVC photoDetailVC: PlayerViewController
    ) {
        guard let fromDelegate = fromDelegate as? PhotoDetailTransitionAnimatorDelegate else {
            return nil
        }
        self.fromDelegate = fromDelegate
        self.photoDetailVC = photoDetailVC
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.38
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // As of 2014, you're meant to use .view(forKey:) instead of .viewController(forKey:).view to get the views.
        // It's not in the original 2013 WWDC talk, but it's in the 2014 one!
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        //let fromVCTabBarController = transitionContext.viewController(forKey: .from)?.locketTabBarController

        let containerView = transitionContext.containerView
        toView?.alpha = 0
        [fromView, toView]
            .compactMap { $0 }
            .forEach {
                containerView.addSubview($0)
        }
        let transitionImage = fromDelegate.referenceImage()!
        transitionImageView.image = transitionImage
        transitionImageView.frame = fromDelegate.imageFrame()
            ?? PhotoDetailPushTransition.defaultOffscreenFrameForPresentation(image: transitionImage, forView: toView!)
        let toReferenceFrame = PhotoDetailPushTransition.calculateZoomInImageFrame(image: transitionImage, forView: toView!)
        containerView.addSubview(self.transitionImageView)

        self.fromDelegate.transitionWillStart()
        self.photoDetailVC.transitionWillStart()

        let duration = self.transitionDuration(using: transitionContext)
        let spring: CGFloat = 0.95
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: spring) {
            self.transitionImageView.frame = toReferenceFrame
            toView?.alpha = 1
        }
        animator.addCompletion { (position) in
            assert(position == .end)

            self.transitionImageView.removeFromSuperview()
            self.transitionImageView.image = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.photoDetailVC.transitionDidEnd()
            self.fromDelegate.transitionDidEnd()
        }
        
        animator.startAnimation()
    }

    /// If no location is provided by the fromDelegate, we'll use an offscreen-bottom position for the image.
    private static func defaultOffscreenFrameForPresentation(image: UIImage, forView view: UIView) -> CGRect {
        var result = PhotoDetailPushTransition.calculateZoomInImageFrame(image: image, forView: view)
        result.origin.y = view.bounds.height
        return result
    }

    /// Because the photoDetailVC isn't laid out yet, we calculate a default rect here.
    // TODO: Move this into PhotoDetailViewController, probably!
    private static func calculateZoomInImageFrame(image: UIImage, forView view: UIView) -> CGRect {
        let rect = CGRect.makeRect(aspectRatio: image.size, insideRect: view.bounds)
        return rect
    }
}
