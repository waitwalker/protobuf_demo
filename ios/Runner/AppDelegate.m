#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "ResponseMessage.pbobjc.h"

@implementation BinaryCodec


- (id _Nullable)decode:(NSData * _Nullable)message {
    NSError *err;
    ResponseMessage *data = [[ResponseMessage alloc]initWithData:message error:&err];
    return data;
}

- (NSData * _Nullable)encode:(id _Nullable)message {
    ResponseMessage *response = message;
    return response.data;
}

+ (nonnull instancetype)sharedInstance {
    static BinaryCodec *codec;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (codec == nil) {
            codec = [BinaryCodec new];
        }
    });
    return codec;
}

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    FlutterViewController *vc = (FlutterViewController *)self.window.rootViewController;
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"flutter_method_channel_protobuf" binaryMessenger:vc.binaryMessenger];
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"batchProtoBufToNative"]){
            FlutterStandardTypedData *fx = call.arguments[@"data"];
            NSError *err;
            ResponseMessage *response = [ResponseMessage parseFromData:fx.data error:&err];
            NSLog(@"Flutter侧传递过来的数据：%@",response.methodName);
            result(@"收到了");
        }
    }];
    
    FlutterBasicMessageChannel *messageChannel = [FlutterBasicMessageChannel messageChannelWithName:@"flutter_basic_message_channel_protobuf" binaryMessenger:vc.binaryMessenger codec:[BinaryCodec sharedInstance]];
    [messageChannel setMessageHandler:^(id  _Nullable message, FlutterReply  _Nonnull callback) {
        ResponseMessage *response = message;
        NSLog(@"接收到Flutter侧数据:%@",response.content);
        
        ResponseMessage *res = [[ResponseMessage alloc]init];
        res.content = @"已经收到你传过来的消息";
        res.methodName = @"callBack";
        res.age = 15;
        callback(res);
    }];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
