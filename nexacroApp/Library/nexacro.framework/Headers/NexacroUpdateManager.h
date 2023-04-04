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
#import "NexacroLoader.h"


enum {
    NexacroSynchronizeUpdateStateType = 0,
    NexacroDowloadUpdateStateType = 1,
    NexacroDecompressUpdateStateType = 2,
    NexacroProcessUpdateStateType = 3
};
typedef NSUInteger NexacroUpdateStateType;

@class NexacroUpdateResource;


@interface NexacroUpdateState : NSObject {
    NexacroUpdateStateType type;
    NexacroUpdateResource* resource;
    NSUInteger status;
}

@property (readwrite) NexacroUpdateStateType type;
@property (readwrite,strong) NexacroUpdateResource* resource;
@property (readwrite) NSUInteger status;

- (id) init;
+ (NexacroUpdateState*) updateState;
- (void) didChangeStatus:(NSUInteger) aStatus andType:(NexacroUpdateStateType) stateType andResource:(NexacroUpdateResource*) updateResource;

@end

@protocol NexacroUpdateManagerDelegate, NexacroUpdateManagerStateDelegate;


@interface NexacroUpdateManager : NSObject /*<NSFileManagerDelegate>*/ {
    id <NexacroUpdateManagerDelegate> delegate;
    id <NexacroUpdateManagerStateDelegate> stateDelegate;
    
    NSString* osType;
    NSString* deviceType;
    
    NexacroUpdateState* state;
    NSMutableArray* outdatedResources;
    BOOL autoUpdate;
    
    BOOL updateFail; //업데이트 실패 할 경우, File에 저장하지 않도록 한다.

}

@property (nonatomic,strong) id <NexacroUpdateManagerDelegate> delegate;
@property (nonatomic,strong) id <NexacroUpdateManagerStateDelegate> stateDelegate;

@property (readonly,retain) NSString* osType;
@property (readonly,retain) NSString* deviceType;

@property (readonly,retain) NexacroUpdateState* state;
@property (readonly,retain) NSMutableArray* outdatedResources;
@property (nonatomic,readwrite,assign,getter = isAutoUpdate) BOOL autoUpdate;
@property (nonatomic) BOOL updateFail;

@property (nonatomic, readwrite, strong) NSMutableArray *errorMsg;

+ (NexacroUpdateManager*) sharedUpdateManager;

- (NSArray*) resources;
- (void) synchronizeLocal;
- (void) synchronizeUpdateServer;
- (void) update;
- (void) install;
- (void) ipaInstall:(NSString*)link;
- (NSString *)getInHouseLink;
- (void)removeInHouseLinkInfo;

- (BOOL) shouldSynchronizeURL:(NSString*) url;
- (BOOL) shouldSynchronizeAsset:(NSString*) asset;
- (BOOL) shouldDownloadResource:(NexacroUpdateResource*) resource toPath:(NSString*) aPath;
- (void) didSuccessResource:(NexacroUpdateResource*) resource;

- (BOOL)didSucceedLastTime;

- (BOOL)inHouseVersionIsNewer:(NexacroUpdateResource*)resource;
- (BOOL)isInHouseUpdateAvailable;
- (BOOL)isInstalled;

@end


@protocol NexacroUpdateManagerDelegate <NSObject>

@required
- (BOOL) updateManager:(NexacroUpdateManager*) manager shouldSynchronizeURL:(NSString*) url;
- (BOOL) updateManager:(NexacroUpdateManager*) manager shouldSynchronizeAsset:(NSString*) asset;
- (BOOL) updateManager:(NexacroUpdateManager*) manager shouldDownloadResource:(NexacroUpdateResource*) resource toPath:(NSString*) aPath;
- (void) updateManager:(NexacroUpdateManager*) manager didSuccessResource:(NexacroUpdateResource*) resource;
@end


@protocol NexacroUpdateManagerStateDelegate <NSObject>

@optional
- (void) updateManager:(NexacroUpdateManager *)manager updateErrorOccurred:(NSError *) error;
- (void) updateManagerDidUpdateState:(NexacroUpdateManager*) manager;

@end
