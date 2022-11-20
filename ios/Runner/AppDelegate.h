#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>


@interface AppDelegate : FlutterAppDelegate
@property (nonatomic, strong) FlutterEngine *engine;

@end

@interface BinaryCodec : NSObject<FlutterMessageCodec>

@end
