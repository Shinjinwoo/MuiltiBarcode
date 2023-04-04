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

#import <WebKit/WebKit.h>

#import "PluginResult.h"

@interface DeviceAPI : NSObject {

}

@property (nonatomic, retain) id webView;
@property (nonatomic, retain) NSDictionary *options;

- (DeviceAPI*) initWithWebView:(id)theWebView;

// nexacro.Hybrid 의 callback을 호출하기 위한 메서드.
- (NSString*) writeJavascript:(NSString*)javascript;

// nexacro.System 의 callback을 호출하기 위한 메서드.
- (NSString*) writeJavascriptEx:(NSString*)javascript;

// 리턴 데이터 중 js에서 문제 있는 character 치환
- (NSString*) getReplacedStringXML:(NSString*)javascript;
- (NSString*) getReplacedStringSSVCSV:(NSString*)javascript;
- (NSString*) getReplacedString:(NSString*)javascript;
- (NSString*) getReturnReplacedString:(NSString*)javascript;
@end

