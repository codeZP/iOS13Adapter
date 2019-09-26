//
//  ViewController.m
//  Adapter
//
//  Created by mac on 2019/9/26.
//  Copyright © 2019 CodeZP. All rights reserved.
//

#import "ViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
@interface ViewController () <ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDButton *btn = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleWhiteOutline];
        [btn addTarget:self action:@selector(signApple) forControlEvents:UIControlEventTouchUpInside];
        btn.center = self.view.center;
        btn.cornerRadius = 20;
        [self.view addSubview:btn];
    } else {
        
    }
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xing"]];
    imageV.frame = CGRectMake(50, 100, 30, 30);
    [self.view addSubview:imageV];
}

- (void)signApple API_AVAILABLE(ios(13.0)) {
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *request = [provider createRequest];
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        
        ASAuthorizationController *vc = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        vc.delegate = self;
        vc.presentationContextProvider = self;
        [vc performRequests];
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0))
{
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]])       {
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        
        NSString *state = credential.state;
        NSString *userID = credential.user;
        NSPersonNameComponents *fullName = credential.fullName;
        NSString *email = credential.email;
        NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding]; // refresh token
        NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding]; // access token
        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
        
        NSLog(@"state: %@", state);
        NSLog(@"userID: %@", userID);
        NSLog(@"fullName: %@", fullName);
        NSLog(@"email: %@", email);
        NSLog(@"authorizationCode: %@", authorizationCode);
        NSLog(@"identityToken: %@", identityToken);
        NSLog(@"realUserStatus: %@", @(realUserStatus));
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0))
{
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    NSLog(@"%@", errorMsg);
}


- (void)setupUI {
    if (@available(iOS 13.0, *)) {
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor redColor];
            }else {
                return [UIColor yellowColor];
            }
        }];
        self.view.backgroundColor = color;
    } else {
        self.view.backgroundColor = [UIColor greenColor];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    NSLog(@"------------------");
    [self setupUI];
}


@end
