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

@interface ProtocolAdaptor : NSObject {
	NSString* usingProtocol;
}

@property (readonly,retain) NSString* usingProtocol;

- (id) init;

- (BOOL) initialize:(NSString*) url;
- (BOOL) setParam:(NSString*) value forKey:(NSString*) key;

- (NSDictionary*) getHTTPHeaders;
- (NSData*) encodeData:(NSData*) data andRange:(NSRange) range;
- (NSData*) decodeData:(NSData*) data andRange:(NSRange) range;

@end
