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
#import "NexacroUpdateManager.h"

@interface NexacroLoader : NSObject <UIAlertViewDelegate, NexacroUpdateManagerStateDelegate> {
    BOOL bLoader;
    
    UIViewController* viewController;
}

@property (nonatomic) BOOL bLoader;
@property (nonatomic,strong) UIViewController* viewController;

- (void)checkUpdate;
- (void)updateFinish;

@end
