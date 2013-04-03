//
//  YCViewController.m
//  YConnectSample
//
//  Created by koogawa on 2013/03/30.
//  Copyright (c) 2013年 Kosuke Ogawa. All rights reserved.
//

#import "YCViewController.h"

@interface YCViewController ()

@end

@implementation YCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    // ログインボタン
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(110.0f, 20.0f, 100.0f, 44.0f);
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(showLoginView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    // 取得したアクセストークンを表示
    CGRect accessTokenTextViewFrame = CGRectMake(20.0f, 84.0f, 280.0f, 124.0f);
    accessTokenTextView_ = [[UITextView alloc] initWithFrame:accessTokenTextViewFrame];
    accessTokenTextView_.editable = NO;
    [self.view addSubview:accessTokenTextView_];
    
    // チェックボタン
    checkTokenButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    checkTokenButton_.frame = CGRectMake(50.0f, 240.0, 100.0f, 44.0f);
    [checkTokenButton_ setTitle:@"CheckToken" forState:UIControlStateNormal];
    [checkTokenButton_ addTarget:self action:@selector(checkToken) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkTokenButton_];
    checkTokenButton_.enabled = NO;
    
    // ユーザー情報
    userInfoButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    userInfoButton_.frame = CGRectMake(170.0f, 240.0, 100.0f, 44.0f);
    [userInfoButton_ setTitle:@"UserInfo" forState:UIControlStateNormal];
    [userInfoButton_ addTarget:self action:@selector(userInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userInfoButton_];
    userInfoButton_.enabled = NO;
    
    // レスポンスを表示
    CGRect responseTextViewFrame = CGRectMake(20.0f, 304.0f, 280.0f, 124.0f);
    responseTextView_ = [[UITextView alloc] initWithFrame:responseTextViewFrame];
    responseTextView_.editable = NO;
    [self.view addSubview:responseTextView_];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoginView
{
    YCLoginViewController *loginViewController = [[YCLoginViewController alloc] init];
    loginViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)checkToken
{
    NSString *urlString = [NSString stringWithFormat:@"https://auth.login.yahoo.co.jp/yconnect/v1/checktoken?id_token=%@", idToken_];
    NSLog(@"checkToken url = %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *response = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    responseTextView_.text = response;
}

- (void)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"https://userinfo.yahooapis.jp/yconnect/v1/attribute?access_token=%@&schema=openid", accessToken_];
    NSLog(@"userInfo url = %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *response = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    responseTextView_.text = response;
}


#pragma mark - YCLoginViewControllerDelegate

- (void)loginController:(YCLoginViewController *)controller didSucceedWithAccessToken:(NSString *)accessToken idToken:(NSString *)idToken
{
    accessToken_ = accessToken;
    idToken_ = idToken;
    
    accessTokenTextView_.text = accessToken;
    checkTokenButton_.enabled = YES;
    userInfoButton_.enabled = YES;
}

- (void)loginController:(YCLoginViewController *)controller didFailWithError:(NSError *)error
{
    // なんかする
}

@end
