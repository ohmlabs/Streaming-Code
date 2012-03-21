//
//  OhmAppearance.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "OhmAppearance.h"

#import "AppleSampleCode.h"

@implementation OhmAppearance

+ (NSString*) defaultFontName
{
#if OHM_TARGET_4
	return @"Helvetica Neue";
#else
	return @"Helvetica";
#endif
}

#pragma mark Metrics

+ (CGFloat) characterIndexFontSize
{
	return 12.0F;
}

+ (CGFloat) artistCellFontSize
{
#if OHM_TARGET_4
	return 32.0F;
#else
	return 30.0F;
#endif
}

#pragma mark Colors

+ (UIColor*) defaultViewControllerBackgroundColor
{
#if OHM_TARGET_4
	// Gray.
	const CGFloat ComponentValue = 200.0F/255.0F;
	
	return [UIColor colorWithRed:ComponentValue green:ComponentValue blue:ComponentValue alpha:1.0F];
#else
	return nil;
#endif
}

+ (UIColor*) defaultTableViewBackgroundColor
{
	return [OhmAppearance defaultViewControllerBackgroundColor];
}

+ (UIColor*) playlistTableViewBackgroundColor
{
#if OHM_TARGET_4
	return [UIColor whiteColor];
#else
	return nil;
#endif
}

+ (UIColor*) nowPlayingViewControllerBackgroundColor
{
#if OHM_TARGET_4
	// Light gray.
	const CGFloat ComponentValue = 228.0F/255.0F;
	
	return [UIColor colorWithRed:ComponentValue green:ComponentValue blue:ComponentValue alpha:1.0F];
#else
	return [UIColor blackColor];
#endif
}

+ (UIColor*) windowBackgroundColor
{
#if OHM_TARGET_4
	return [UIColor whiteColor];
#else
	return nil;
#endif
}

+ (UIColor*) navigationBarTintColor
{
#if OHM_TARGET_4
    // Light gray.
	const CGFloat ComponentValue = 153.0F/255.0F;
	
	return [UIColor colorWithRed:ComponentValue green:ComponentValue blue:ComponentValue alpha:1.0F];
#else
	return nil;
#endif
}

+ (UIColor*) characterIndexTextColor
{
#if OHM_TARGET_4
	// Light gray.
	const CGFloat ComponentValue = 153.0F/255.0F;
	
	return [UIColor colorWithRed:ComponentValue green:ComponentValue blue:ComponentValue alpha:1.0F];
#else
	return [UIColor whiteColor];
#endif
}

+ (UIColor*) characterIndexBackgroundColor
{
	return [UIColor clearColor];
}

+ (UIColor*) queuedSongTableViewTextColor
{
	return [UIColor darkGrayColor];
}

+ (UIColor*) songTableViewTextColor
{
	return [UIColor darkTextColor];
}

+ (UIColor*) songTableViewBackgroundColor
{
	return nil;
}

+ (UIColor*) songTableViewCellBackgroundColor
{
	return [OhmAppearance defaultTableViewBackgroundColor];
}

+ (UIColor*) artistCellTextColor
{

	return [UIColor whiteColor];

}

+ (UIColor*) artistCellBackgroundColor
{
	return [UIColor clearColor];
}

#pragma mark Fonts

+ (UIFont*) defaultFontOfSize:(const CGFloat)size
{
	return [UIFont fontWithName:[OhmAppearance defaultFontName] size:size];
}

+ (UIFont*) characterIndexFont
{
#if OHM_TARGET_4	
	return [UIFont systemFontOfSize:[OhmAppearance characterIndexFontSize]];
#else
	return [UIFont systemFontOfSize:[OhmAppearance characterIndexFontSize]];
#endif
}

+ (UIFont*) artistCellFont
{
	return [UIFont fontWithName:[OhmAppearance defaultFontName] size:[OhmAppearance artistCellFontSize]];
}

#pragma mark Text Attributes

+ (NSDictionary*) defaultNavBarTextAttributes
{
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	
	UIFont* navBarFont = [OhmAppearance defaultFontOfSize:23.0F];
	
	UIColor* navBarTextColor = [UIColor whiteColor];
	
	[dict setValue:navBarFont forKey:UITextAttributeFont];
	[dict setValue:navBarTextColor forKey:UITextAttributeTextColor];
	
	return dict;
}

#pragma mark Styles

+ (UIStatusBarStyle) defaultStatusBarStyle
{

	return UIStatusBarStyleBlackOpaque;

}

+ (UIStatusBarStyle) nowPlayingStatusBarStyle
{

	return UIStatusBarStyleBlackOpaque;

}

#pragma mark Text Values

+ (NSString*) defaultSongTitle
{
    return NSLocalizedString(@"Untitled", @"Untitled");
}

+ (NSString*) defaultAlbumTitle
{
    return NSLocalizedString(@"no name", @"no name");
}

+ (NSString*) defaultArtistName
{
    return NSLocalizedString(@"no artist", @"no artist");
}

#pragma mark Reflection Support

+ (UIImage*) reflectedImageFromUIImageView:(UIImageView*)imageView withHeight:(NSUInteger)height
{
    return [AppleSampleCode reflectedImage:imageView withHeight:height];
}

@end
