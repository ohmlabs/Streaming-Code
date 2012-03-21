//
//  GalleryView.h
//
//  Created by Reg on 8/13/11.
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark Delegate

@class GalleryView;

@protocol GalleryViewDelegate

- (void) gallery:(GalleryView*)gallery didSelectColumnAtIndex:(NSUInteger)index;

- (BOOL) shouldEnablePagingForGallery:(GalleryView*)gallery;

@end

#pragma mark Datasource

@protocol GalleryViewDataSource

- (NSUInteger) numberOfColumnsInGallery:(GalleryView*)gallery;

- (id) gallery:(GalleryView*)gallery cellForColumnAtIndex:(NSUInteger)index;

@end

#pragma mark Class

@interface GalleryView : UIScrollView
{
	@private
	
	UIInterfaceOrientation lastLayoutOrientation;
	UIInterfaceOrientation lastSetContentOffsetOrientation;
	CGFloat currentPage;
	BOOL shouldLayout;
	
}

// delegate is inherited from UIScrollView.

@property (nonatomic, assign) IBOutlet id<GalleryViewDataSource> dataSource;

@end
