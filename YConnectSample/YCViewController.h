//
//  YCViewController.h
//  YConnectSample
//
//  Created by koogawa on 2013/03/30.
//  Copyright (c) 2013年 Kosuke Ogawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCLoginViewController.h"

@interface YCViewController : UIViewController <YCLoginViewControllerDelegate>
{
    UITextView  *accessTokenTextView_;
    UITextView  *responseTextView_;
    
    UIButton    *checkTokenButton_;
    UIButton    *userInfoButton_;
    
    NSString    *accessToken_;
    NSString    *idToken_;
}

@end
