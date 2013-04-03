//
//  YCLoginViewController.m
//  YConnectSample
//
//  Created by koogawa on 2013/03/30.
//  Copyright (c) 2013年 Kosuke Ogawa. All rights reserved.
//

#import "YCLoginViewController.h"

@interface YCLoginViewController ()

@end

@implementation YCLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"ログイン";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ナビゲーションバーにキャンセルボタンを追加
    UIBarButtonItem *cancelButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                  target:self
                                                  action:@selector(didTapCancelButton)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    webView_ = [[UIWebView alloc] init];
	webView_.delegate = self;
	webView_.frame = self.view.bounds;
	webView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	webView_.scalesPageToFit = YES;
	[self.view addSubview:webView_];

    NSString *rand = [self randAsciiString:41];
    
    NSString *address = [NSString stringWithFormat:@"https://auth.login.yahoo.co.jp/yconnect/v1/authorization?response_type=token+id_token&client_id=%@&redirect_uri=%@&scope=openid+profile+email+address&nonce=%@&display=touch", CLIENT_ID, REDIRECT_URL, rand];
    NSURL *url = [NSURL URLWithString:address];
    
    // ブラウザ表示
    [webView_ loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 長さを指定してランダムなASCII文字列を生成
- (NSString *)randAsciiString:(NSUInteger)length
{
    srand(time(NULL));
	NSString *chars = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSRange range = NSMakeRange(0, [chars length] - 1);
	NSMutableString *str = [NSMutableString stringWithCapacity:length];
	for (int i = 0; i < length; i++) {
        NSUInteger randInt = range.location + (NSUInteger)(rand() * (range.length + 1.0) / (RAND_MAX + 1.0));
		[str appendString:[chars substringWithRange:NSMakeRange(randInt, 1)]];
	}
	return str;
}

- (void)didTapCancelButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIWebView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    NSString *decodedUrlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//    NSLog(@"urlString = %@", decodedUrlString);

    if ([urlString hasPrefix:REDIRECT_URL])
    {
        // パラメータ部分を切り出す (scheme:#param)
        NSArray *querys = [decodedUrlString componentsSeparatedByString:@"#"];
        if ([querys count] != 2) return NO;
        NSString *query = [querys objectAtIndex:1];
        
        // パラメータを解析
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (NSString *param in [query componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
        }

        NSString *accessToken = [params objectForKey:@"access_token"];
        NSString *idToken = [params objectForKey:@"id_token"];
        
        if (accessToken != nil && idToken != nil)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Login Success!"
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
            
            if ([self.delegate respondsToSelector:@selector(loginController:didSucceedWithAccessToken:idToken:)]) {
                [self.delegate loginController:self didSucceedWithAccessToken:accessToken idToken:idToken];
            }
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Login Failed!"
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
            
            if ([self.delegate respondsToSelector:@selector(loginController:didFailWithError:)]) {
                [self.delegate loginController:self didFailWithError:nil];
            }
        }

        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
