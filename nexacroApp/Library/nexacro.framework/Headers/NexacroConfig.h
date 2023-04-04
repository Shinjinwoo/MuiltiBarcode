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

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ApplicationDialogPosition) {ApplicationDialogPositionTop = 0, ApplicationDialogPositionCenter, ApplicationDialogPositionBottom};

@interface ApplicationConfig : NSObject {
    ApplicationDialogPosition dialogPosition;
    BOOL useWKWebView;
    BOOL fileLogging;
    BOOL quiet;
}
@property (nonatomic,readwrite) ApplicationDialogPosition dialogPosition;
@property (nonatomic,readwrite,getter = isUseWKWebView) BOOL useWKWebView;
@property (nonatomic,readwrite) BOOL fileLogging;
@property (nonatomic,readwrite,getter = isQuiet) BOOL quiet;

- (id) init;
+ (ApplicationConfig*) config;

- (void) setDialogPositionWithString:(NSString*) position;

@end

@interface NotificationConfig : NSObject {
    BOOL enable;
    NSString* handlerName;
}

@property (nonatomic,readwrite,getter = isEnable) BOOL enable;
@property (nonatomic,readwrite,retain) NSString* handlerName;

- (id) init;
+ (NotificationConfig*) config;

@end

@interface UpdatorConfig : NSObject {
    BOOL force;
    BOOL cancelable;
    BOOL restart;
    BOOL errormsg;
    BOOL quiet;
}

@property (nonatomic,readwrite,getter = isForce) BOOL force;
@property (nonatomic,readwrite,getter = isCancelable) BOOL cancelable;
@property (nonatomic,readwrite,getter = isRestart) BOOL restart;
@property (nonatomic,readwrite,getter = isErrormsg) BOOL errormsg;
@property (nonatomic,readwrite,getter = isQuiet) BOOL quiet;

- (id) init;
+ (NotificationConfig*) config;

@end

@interface PushServerConfig : NSObject {
    BOOL requestMissingMessage;
    NSString* bundleId;
}

@property (nonatomic,readwrite,getter = isRequestMissingMessage) BOOL requestMissingMessage;
@property (nonatomic,readwrite,retain) NSString* bundleId;

- (id) init;
+ (PushServerConfig*) config;

@end

@interface SplashConfig : NSObject {
    NSString* scaletype;
    NSString* backgroundcolor;
}

@property (nonatomic,readwrite,retain) NSString* scaletype;
@property (nonatomic,readwrite,retain) NSString* backgroundcolor;

- (id) init;
+ (SplashConfig*) config;

@end

@interface NexacroConfig : NSObject {
    ApplicationConfig* ApplicationConfig;
    NotificationConfig* notificationConfig;
    UpdatorConfig* updatorConfig;
    PushServerConfig* pushServerConfig;
    SplashConfig* splashConfig;
}

@property (nonatomic,readonly,retain) ApplicationConfig* applicationConfig;
@property (nonatomic,readonly,retain) NotificationConfig* notificationConfig;
@property (nonatomic,readonly,retain) UpdatorConfig* updatorConfig;
@property (nonatomic,readonly,retain) PushServerConfig* pushServerConfig;
@property (nonatomic,readonly,retain) SplashConfig* splashConfig;

- (id) init;
- (id) initWithStream:(NSInputStream*) stream;
- (id) initWithData:(NSData*) data;
- (id) initWithURL:(NSURL*) url;

+ (NexacroConfig*) config;
+ (NexacroConfig*) configWithStream:(NSInputStream*) stream;
+ (NexacroConfig*) configWithData:(NSData*) data;
+ (NexacroConfig*) configWithURL:(NSURL*) url;

- (BOOL) parseFromStream:(NSInputStream*)stream;
- (BOOL) parseFromData:(NSData*)data;
- (BOOL) parseFromURL:(NSURL*)url;

- (BOOL) loadFromStream:(NSInputStream*)stream;
- (BOOL) loadFromData:(NSData*)data;
- (BOOL) loadFromURL:(NSURL*)url;

@end
