//
//  ViewController.h
//  Gallery
//
//  Created by Reg on 8/13/11.
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GalleryView.h"

@interface ViewController : UIViewController<GalleryViewDelegate, GalleryViewDataSource> {
	UIScrollView *artistGallery;
	UIScrollView *albumGallery;
}

@property (strong, nonatomic) IBOutlet UIScrollView *artistGallery;
@property (strong, nonatomic) IBOutlet UIScrollView *albumGallery;

@end
