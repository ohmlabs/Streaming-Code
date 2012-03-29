
#import <UIKit/UIKit.h>


@interface ConfigViewController : UIViewController {
    IBOutlet UITextView *textView;
    IBOutlet UIButton	*button1;
    IBOutlet UIButton	*button2;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIButton *button1;
@property (nonatomic, retain) IBOutlet UIButton *button2;

@end
