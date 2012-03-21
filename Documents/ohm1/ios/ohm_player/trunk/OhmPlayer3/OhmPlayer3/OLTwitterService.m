//
//  OLTwitterService.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "OLTwitterService.h"

#import "Post.h"

#import <QuartzCore/QuartzCore.h> // For CALayer access...

static NSString* const NIB_NAME_YOUTUBE_VIEW = @"OLTwitterServiceYouTube";
static NSString* const NIB_NAME_CHANNEL_VIEW = @"OLTwitterServiceChannel";

@implementation OLTwitterService

#pragma mark Properties

@synthesize viewLoadPoint;

#pragma mark Protected Methods

- (UIView*) genericCell:(NSString*)labelText
{
	if (!labelText) return nil;
	
	static NSString*		CELL_FONTNAME		= @"Helvetica";
	static const CGFloat	CELL_FONTSIZE		= 30.0F;
	static const CGFloat	CELL_FONTSIZE_MIN	= 10.0F;
	
	NSParameterAssert([labelText length]);
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
	
	UIFont* font				= [UIFont fontWithName:CELL_FONTNAME size:CELL_FONTSIZE];
	UIColor* textColor			= [UIColor whiteColor];
	UIColor* backgroundColor	= [UIColor blueColor];
	
	label.text					= labelText;
	label.font					= font;
	label.textColor				= textColor;
	label.backgroundColor		= backgroundColor;
	label.textAlignment			= UITextAlignmentCenter;
	label.lineBreakMode			= UILineBreakModeTailTruncation;
	label.minimumFontSize		= CELL_FONTSIZE_MIN;
	
	[label.layer setBorderColor:[UIColor greenColor].CGColor];
	[label.layer setBorderWidth:1.0F];
	
	label.adjustsFontSizeToFitWidth = YES;
	[label sizeToFit];
	
	const CGFloat Side = 44.0F;
	
	label.frame = CGRectMake(0.0F, 0.0F, Side, Side);
	
	return label;
}

- (UIView*) youTubeTweetView
{
	[[NSBundle mainBundle] loadNibNamed:NIB_NAME_YOUTUBE_VIEW owner:self options:nil];
	
	UIView* result = self.viewLoadPoint;
	self.viewLoadPoint = nil;
	return result;
}

- (UIView*) channelTweetView
{
	[[NSBundle mainBundle] loadNibNamed:NIB_NAME_CHANNEL_VIEW owner:self options:nil];
	
	UIView* result = self.viewLoadPoint;
	self.viewLoadPoint = nil;
	return result;
}

#pragma mark Public Methods

+ (BOOL) originatedPost:(Post*)post
{
	return YES; // ISSUE: All posts originate from Twitter in 1.0.
				
	//return [post.type hasPrefix:POST_TYPE_TWEET_PREFIX];
}

- (id) wireCellForPost:(Post*)post
{
	return (post.type) ? [self genericCell:[NSString stringWithFormat:@"*%@", post.type]] : nil;
}

- (id) wireViewForPost:(Post*)post
{		
	NSParameterAssert(post.type);
	
	if (!post.type) return nil;

	// $$$$$ ISSUE: these constants are defined inside the Post class.
	// This class should probably create the post objects?
	
	UIView* view = nil;
	
	if ([post.type isEqualToString:@"tw_youTube"])
	{
		view = [self youTubeTweetView]; 
	}
	else if ([post.type isEqualToString:@"tw_OhmChannel"])
	{
		view = [self channelTweetView];
	}
	else
	{
		view = [self genericCell:[NSString stringWithFormat:@"V-%@", post.type]];
		view.backgroundColor = [UIColor brownColor];
	}

	[view.layer setBorderWidth:1.0F];
	[view.layer setBorderColor:[UIColor redColor].CGColor];

	return view;
}

+ (OLTwitterService*) sharedInstance
{
	static OLTwitterService* instance = nil;
	
	if (instance) return instance;
	
	@synchronized (self)
	{
		if (!instance)
		{
			instance = [[OLTwitterService alloc] init];
		}
	}
	
	return instance;
}

@end
