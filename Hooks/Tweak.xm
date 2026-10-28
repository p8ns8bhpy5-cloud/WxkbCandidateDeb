#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static NSString *LogPath(void) {
    NSString *dir = NSHomeDirectory();
    return [dir stringByAppendingPathComponent:@"wxkb_debug.log"];
}

static void DLog(NSString *fmt, ...) {
    va_list args; va_start(args, fmt);
    NSString *msg = [[NSString alloc] initWithFormat:fmt arguments:args];
    va_end(args);
    NSLog(@"Wxkb: %@", msg);
    NSString *line = [NSString stringWithFormat:@"[%@] %@\n", [NSDate date], msg];
    NSString *path = LogPath();
    NSFileHandle *fh = [NSFileHandle fileHandleForWritingAtPath:path];
    if (fh) { [fh seekToEndOfFile]; [fh writeData:[line dataUsingEncoding:NSUTF8StringEncoding]]; [fh closeFile]; }
    else { [line writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil]; }
}

static const CGFloat kCandidateBarHeight = 34.0;

%group Tweak

%hook WBCandidateView

- (void)layoutSubviews {
    %orig;
    @autoreleasepool {
        NSInteger visibleCount = 0;
        for (UIView *sub in self.subviews) {
            if (!sub.hidden) visibleCount++;
        }
        DLog(@"layoutSubviews subs=%ld hidden=%d frame=%.0f", (long)self.subviews.count, self.hidden, self.frame.size.height);
        BOOL shouldShow = (self.subviews.count > 0);
        if (self.hidden == shouldShow) {
            self.hidden = !shouldShow;
            DLog(@"-> %@", shouldShow ? @"SHOW" : @"HIDE");
        }
        if (!self.hidden) {
            for (NSLayoutConstraint *c in self.constraints) {
                if (c.firstAttribute == NSLayoutAttributeHeight && fabs(c.constant - kCandidateBarHeight) > 0.5) {
                    c.constant = kCandidateBarHeight;
                    DLog(@"height -> %.0f", kCandidateBarHeight);
                }
            }
        }
    }
}

%end

%ctor {
    DLog(@"===== WxkbCandidate injected =====");
    Class v = objc_getClass("WBCandidateView");
    DLog(v ? @"WBCandidateView found" : @"WBCandidateView NOT found");
    %init(Tweak);
    DLog(@"hooks installed");
}
