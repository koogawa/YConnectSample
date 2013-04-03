//
//  YCLoginViewController.h
//  YConnectSample
//
//  Created by koogawa on 2013/03/30.
//  Copyright (c) 2013年 Kosuke Ogawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCLoginViewController;

@protocol YCLoginViewControllerDelegate
- (void)loginController:(YCLoginViewController *)controller didSucceedWithAccessToken:(NSString *)accessToken idToken:(NSString *)idToken;
- (void)loginController:(YCLoginViewController *)controller didFailWithError:(NSError *)error;
@end

@interface YCLoginViewController : UIViewController <UIWebViewDelegate>
{
    UIWebView *webView_;
}

@property (unsafe_unretained) id delegate;

@end
