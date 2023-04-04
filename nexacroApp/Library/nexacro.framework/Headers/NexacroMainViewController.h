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
#import <WebKit/WebKit.h>
#import "NexacroResourceManager.h"
#import "NexacroUpdateManager.h"
#import "NexacroNotificationManager.h"
#import "NexacroLoader.h"

#define TAG_StartView 7777

#define H_STATUSBAR (20.0f)

@class DeviceApiExecuter;

@interface NexacroMainViewController : UIViewController {
    NexacroLoader * loader;
    NSURL *urlMakeCall;
    
    BOOL enableUpdate;
    NSString *saveXPushKey;
    BOOL fullScreen;            //statusBar 제거
    BOOL webviewLoaded;
}
@property (nonatomic, retain) NexacroLoader * loader;
@property (nonatomic, retain) id mainView;
@property (nonatomic, retain) NSString * saveXPushKey;
@property (nonatomic, retain) NSURL * urlMakeCall;

@property (nonatomic, assign, getter=isEnableUpdate) BOOL enableUpdate;
@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;
@property (nonatomic, assign, getter=isWebviewLoaded) BOOL webviewLoaded;

@property (nonatomic, readwrite, strong) DeviceApiExecuter *deviceApiExecuter;

+ (NSString*)applicationDocumentsDirectory;
+ (NSString*)pathForResource:(NSString*)resourcepath;

- (BOOL)callScript:(NSString*)script;

// 초기화 함수
- (id)initWithFullScreen:(BOOL)anFullScreen;
- (id)initWithFullScreen:(BOOL)anFullScreen enableUpdate:(BOOL)anEnableUpdate;

// SQLStatement에서 SQLConnection을 찾아 연결.
- (id)findSQLConn:(NSInteger)nID;

- (id)findPluginObject:(NSString*)objectId;

- (void)recvDataFromExtAPI: (NSString*)recvData;

- (void)exitFileDialog:(NSInteger)nID;

- (void)callBackOri:(UIInterfaceOrientation)interfaceOrientation;

// loading 배경, loading indicator표시
- (void)showLoadingView:(NSString*)text;

// loading 배경, loading indicator, loading progress 제거..
- (void)removeLoadingView;

//XPush
- (void)destroyXPush:(NSNotification*)noti;
- (void)saveXPush:(NSNotification*)noti;
- (void)foregroundXPush:(NSNotification*)noti;

- (void)RunPageLoad;

@end
