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

#import "NexacroConfig.h"

@class NexacroNotificationManagerHandler;


@interface NexacroNotificationManager : NSObject {
    NexacroNotificationManagerHandler* handler;
    NSString* registrationId;
}

@property (readonly,strong) NexacroNotificationManagerHandler* handler;
@property (readwrite,retain) NSString* registrationId;

+ (NexacroNotificationManager*) sharedNotificationManager;

- (BOOL) isEnable;
- (void) configureNotification;
- (void) fireErrorEvent:(NSError*) error andTarget:(id) webview;
- (void) fireRegisterEvent:(NSData*) deviceToken andTarget:(id) webview;
- (void) fireNotificationEvent:(NSDictionary*) message andTarget:(id) webview;
@end


@interface NexacroNotificationManagerHandler : NSObject

-(void) handleError:(NSError*) error;
-(void) handleRegister:(NSString*) registrationId;
-(void) handleReceiveMessage:(NSDictionary*) messages;

@end
 
