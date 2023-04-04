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

@class NexacroUpdateItem, NexacroUpdateOS, NexacroUpdateDevice, NexacroUpdateResource;


@interface NexacroTypeDefinition : NSObject {
    NSMutableDictionary* protocolAdaptos;
    BOOL preventScreenshot;
    BOOL preventClipboard;
    BOOL preventCache;
    BOOL preventCookie;
    NexacroUpdateItem* updateItem;
}

@property (nonatomic,readwrite,retain) NSMutableDictionary* protocolAdaptos;
@property (nonatomic,readwrite, getter = isPreventScreenshot) BOOL preventScreenshot;
@property (nonatomic,readwrite, getter = isPreventClipboard) BOOL preventClipboard;
@property (nonatomic,readwrite, getter = isPreventCache) BOOL preventCache;
@property (nonatomic,readwrite, getter = isPreventCookie) BOOL preventCookie;
@property (nonatomic,readwrite,retain) NexacroUpdateItem* updateItem;

- (id) init;
- (id) initWithStream:(NSInputStream*) stream;
- (id) initWithData:(NSData*) data;
- (id) initWithURL:(NSURL*) url;
- (id) initWithBootstrap:(NSString*) bootstrap;
- (id) initWithBootstrapURL:(NSURL*) bootstrapUrl;

+ (NexacroTypeDefinition*) typeDefinition;
+ (NexacroTypeDefinition*) typeDefinitionWithStream:(NSInputStream*) stream;
+ (NexacroTypeDefinition*) typeDefinitionWithData:(NSData*) data;
+ (NexacroTypeDefinition*) typeDefinitionWithURL:(NSURL*) url;
+ (NexacroTypeDefinition*) typeDefinitionWithBootstrap:(NSString*) bootstrap;
+ (NexacroTypeDefinition*) typeDefinitionWithBootstrapURL:(NSURL*) bootstrapUrl;

- (BOOL) parseFromStream:(NSInputStream*)stream;
- (BOOL) parseFromData:(NSData*)data;
- (BOOL) parseFromURL:(NSURL*)url;
- (BOOL) parseFromBootstrap:(NSString*)bootstrap;

- (BOOL) loadFromStream:(NSInputStream*)stream;
- (BOOL) loadFromData:(NSData*)data;
- (BOOL) loadFromURL:(NSURL*)url;
- (BOOL) loadFromBootstrap:(NSString*) bootstrap;
- (BOOL) loadFromBootstrapURL:(NSURL*) bootstrapUrl;

- (void) writeToFile:(NSString*) aPath;
@end


@interface NexacroUpdate : NSObject {
    NSString* URL;
    NSString* engineURL;
    NSString* engineSetupKey;
    NSString* engineVersion;
}

@property (nonatomic,readwrite,retain) NSString* URL;
@property (nonatomic,readwrite,retain) NSString* engineURL;
@property (nonatomic,readwrite,retain) NSString* engineSetupKey;
@property (nonatomic,readwrite,retain) NSString* engineVersion;

@end


@interface NexacroUpdateItem : NexacroUpdate {
    NexacroTypeDefinition* typeDefinition;
    NSMutableDictionary* updateOSs;
    
    NSString* systemType;
    NSString* versionType;
    int timeout;
    int retry;
    NSString * autoupdate;
}

@property (nonatomic,readonly,strong) NexacroTypeDefinition* typeDefinition;
@property (nonatomic,readonly,retain) NSMutableDictionary* updateOSs;
@property (nonatomic,readwrite,retain) NSString * systemType;
@property (nonatomic,readwrite,retain) NSString * versionType;
@property (nonatomic,assign) int timeout;
@property (nonatomic,assign) int retry;
@property (nonatomic,readwrite,retain) NSString * autoupdate;

@property (nonatomic,readwrite,retain) NSString* updateType;

- (id) initWithTypeDefinition:(NexacroTypeDefinition*) definition;
+ (NexacroUpdateItem*) updateItemWithTypeDefinition:(NexacroTypeDefinition*) definition;
- (NSArray*) lookup:(NSString*) osType andDeviceType:(NSString*) deviceType;

@end


@interface NexacroUpdateOS : NexacroUpdate {
    NSString* type;
    
    NexacroUpdateItem* updateItem;
    NSMutableDictionary* updateDevices;
}

@property (nonatomic,readonly,retain) NSString* type;
@property (nonatomic,readonly,strong) NexacroUpdateItem* updateItem;
@property (nonatomic,readonly,retain) NSMutableDictionary* updateDevices;

- (id) initWithType:(NSString*) osType andUpdateItem:(NexacroUpdateItem*) update;
+ (NexacroUpdateOS*) updateOSWithType:(NSString*) osType andUpdateItem:(NexacroUpdateItem*) update;
- (NSArray*) lookup:(NSString*) deviceType;

@end


@interface NexacroUpdateDevice : NexacroUpdate {
    NSString* type;
    
    NexacroUpdateOS* updateOS;
    NSMutableArray* updateResources;
}

@property (nonatomic,readonly,retain) NSString* type;
@property (nonatomic,readonly,strong) NexacroUpdateOS* updateOS;
@property (nonatomic,readonly,retain) NSMutableArray* updateResources;

- (id) initWithType:(NSString*) deviceType andUpdateOS:(NexacroUpdateOS*) os;
+ (NexacroUpdateDevice*) updateDeviceWithType:(NSString*) deviceType andUpdateOS:(NexacroUpdateOS*) os;

@end


@interface NexacroUpdateResource : NSObject {
    NexacroUpdateDevice* updateDevice;
    NSString* type;
    NSString* file;
    NSString* targetPath;
    NSString* version;
    BOOL failpass;
    
    BOOL archived;
    BOOL theme;
    BOOL engine;
    BOOL image;
    BOOL resource;
}

@property (nonatomic,readonly,strong) NexacroUpdateDevice* updateDevice;
@property (nonatomic,readwrite,retain) NSString* type;
@property (nonatomic,readwrite,retain) NSString* file;
@property (nonatomic,readwrite,retain) NSString* targetPath;
@property (nonatomic,readwrite,retain) NSString* version;
@property (nonatomic,readwrite,getter = isFailpass) BOOL failpass;

@property (nonatomic,readwrite,getter = isArchived) BOOL archived;
@property (nonatomic,readwrite,getter = isTheme) BOOL theme;
@property (nonatomic,readwrite,getter = isEngine) BOOL engine;
@property (nonatomic,readwrite,getter = isImage) BOOL image;
@property (nonatomic,readwrite,getter = isResource) BOOL resource;

- (id) initWithType:(NSString*)resourceType andFile:(NSString*) filename andUpdateDevice:(NexacroUpdateDevice*) device;
+ (NexacroUpdateResource*) updateResourceWithType:(NSString*)resourceType andFile:(NSString*) filename andUpdateDevice:(NexacroUpdateDevice*) device;
- (NSString*) getFilename;
- (NSURL*) getURL;

- (BOOL)isApplicationEngine;

@end
