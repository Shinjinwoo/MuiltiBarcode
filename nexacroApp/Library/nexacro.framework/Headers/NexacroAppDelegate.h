//==============================================================================
//
//  TOBESOFT Co., Ltd.
//  Copyright 2017 TOBESOFT Co., Ltd.
//  All Rights Reserved.
//
//  NOTICE: TOBESOFT permits you to use, modify, and distribute this file
//          in accordance with the terms of the license agreement accompanying it.
//
//  Readme URL: http://www.nexacro.co.kr/legal/nexacro17-public-license-readme-1.0.html
//
//==============================================================================

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NexacroLoader.h"
#import "NexacroUpdateViewController.h"
#import "NexacroMainViewController.h"


@interface NexacroAppDelegate : NSObject  <UIApplicationDelegate, UIAlertViewDelegate>{
    NexacroUpdateViewController *updateViewcontroller;      //Update & Loading 화면
    NexacroMainViewController *mainViewController;          //WebView 화면
    
    BOOL bNetworkAvailable;                                 //Network(3G & WIFI) 사용 가능 여부
    NSLock *settingAccessLock;
    
    UIImage *splashScreen_P;                                //Splash Screen Portrait
    UIImage *splashScreen_L;                                //Splash Screen Landscape
    
    float systemVolume;                                     //SET Audio Volume
    BOOL statusBarStyle;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NexacroLoader *loader;
@property (nonatomic, retain) NexacroUpdateViewController *updateViewcontroller;
@property (nonatomic, retain) NexacroMainViewController *mainViewController;
@property (nonatomic, retain) NSLock * settingAccessLock;
@property (nonatomic, retain) UIImage * splashScreen_P;
@property (nonatomic, retain) UIImage * splashScreen_L;
@property (nonatomic) float systemVolume;
@property (nonatomic) BOOL statusBarStyle;
@property (nonatomic, retain) NSData *deviceToken;
@property (nonatomic, retain) UINavigationController *navc;

- (NexacroMainViewController *)initializeMainViewController;

- (void)networkCheck;
- (void)setbNetworkAvailable:(BOOL)bFlag;
- (BOOL)getbNetworkAvailable;

- (UIImage *)getCurOrientImage;
- (UIImage *)getCurOrientImageWith:(UIInterfaceOrientation)o;

- (void)loaderFail;
- (void)updaterFail;
@end
