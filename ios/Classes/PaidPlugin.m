#import "PaidPlugin.h"
#import <sys/stat.h>
#import <sys/sysctl.h>

@implementation PaidPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.ihongwu/paid"
            binaryMessenger:[registrar messenger]];
  PaidPlugin* instance = [[PaidPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"getRawPaidFields"]) {
    NSDictionary *fields = @{
      @"initTime": [self getFileTime] ?: @"",
      @"updateTime": [self getSysU] ?: @"",
      @"bootTime": [self bootTimeInSec] ?: @""
    };
    result(fields);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSString *)getFileTime {
    struct stat info;
    int res = stat("/var/mobile", &info);
    if (res != 0) {
        return @"";
    }
    struct timespec time = info.st_birthtimespec;
    return [NSString stringWithFormat:@"%ld.%09ld", (long)time.tv_sec, (long)time.tv_nsec];
}

- (NSString *)getSysU {
    NSString *information = @"L3Zhci9tb2JpbGUvTGlicmFyeS9Vc2VyQ29uZmlndXJhdGlvblByb2ZpbGVzL1B1YmxpY0luZm8vTUNNZXRhLnBsaXN0";
    NSData *data = [[NSData alloc] initWithBase64EncodedString:information options:0];
    NSString *path = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    if (attrs) {
        NSDate *date = [attrs objectForKey:NSFileCreationDate];
        if ([date isKindOfClass:[NSDate class]]) {
            return [NSString stringWithFormat:@"%.6f", [date timeIntervalSince1970]];
        }
    }
    return @"";
}

- (NSString *)bootTimeInSec {
    struct timeval boottime;
    size_t len = sizeof(boottime);
    int mib[2] = { CTL_KERN, KERN_BOOTTIME };
    if (sysctl(mib, 2, &boottime, &len, NULL, 0) < 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%ld", (long)boottime.tv_sec];
}

@end
