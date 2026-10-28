#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static void DLog(NSString *fmt, ...) {
    va_list args; va_start(args, fmt);
    NSString *msg = [[NSString alloc] initWithFormat:fmt arguments:args];
    va_end(args);
    NSLog(@"Wxkb: %@", msg);
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"wxkb_debug.log"];
    NSString *line = [NSString stringWithFormat:@"[%@] %@\n", [NSDate date], msg];
    NSFileHandle *fh = [NSFileHandle fileHandleForWritingAtPath:path];
    if (fh) { [fh seekToEndOfFile]; [fh writeData:[line dataUsingEncoding:NSUTF8StringEncoding]]; [fh closeFile]; }
    else { [line writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil]; }
}

%group Tweak

%hook WBMainInputView

- (void)layoutSubviews {
    %orig;
    @autoreleasepool {
        DLog(@"WBMainInputView layoutSubviews, subviews=%ld", (long)self.subviews.count);
        for (UIView *v in self.subviews) {
            DLog(@"  subview: %@ frame=%.0f,%.0f", NSStringFromClass([v class]), v.frame.origin.y, v.frame.size.height);
            if ([NSStringFromClass([v class]) containsString:@"Logo"] || [NSStringFromClass([v class]) containsString:@"logo"]) {
                v.hidden = YES;
                DLog(@"  -> hidden logo view");
            }
        }
    }
}

%end

%ctor {
    DLog(@"===== WxkbCandidate injected =====");
    DLog(@"WBMainInputView: %s", objc_getClass("WBMainInputView") ? "found" : "NOT found");
    DLog(@"WBCandidateView: %s", objc_getClass("WBCandidateView") ? "found" : "NOT found");
    %init(Tweak);
    DLog(@"hooks installed");
}
