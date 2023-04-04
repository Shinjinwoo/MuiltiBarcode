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
#import "NexacroTypeDefinition.h"
#import "nexacro/ProtocolAdaptor.h"


@interface ResourceFile : NSObject {
    NSString* path;
    NSString* xfdl;
    NSString* serviceXfdl;
    NSString* xadl;
    NSInteger size;
}

@property (nonatomic,readwrite,retain) NSString* path;
@property (nonatomic,readwrite,retain) NSString* xfdl;
@property (nonatomic,readwrite,retain) NSString* serviceXfdl;
@property (nonatomic,readwrite,retain) NSString* xadl;
@property (nonatomic,readwrite) NSInteger size;

- (id) initWithPath:(NSString*) aPath;
+ (ResourceFile*) resourceFileWithPath:(NSString*) aPath;

- (NSString*) getResourceName;

@end


@interface Resource : NSObject {
    NSMutableDictionary* appFiles;
    NSMutableDictionary* themeFiles;
    NSMutableDictionary* serviceFiles;
}

@property (nonatomic,readonly,retain) NSMutableDictionary* appFiles;
@property (nonatomic,readonly,retain) NSMutableDictionary* themeFiles;
@property (nonatomic,readonly,retain) NSMutableDictionary* serviceFiles;

- (id) init;
- (id) initWithStream:(NSInputStream*) stream;
- (id) initWithData:(NSData*) data;
- (id) initWithURL:(NSURL*) url;

+ (Resource*) resource;
+ (Resource*) resourceWithStream:(NSInputStream*) stream;
+ (Resource*) resourceWithData:(NSData*) data;
+ (Resource*) resourceWithURL:(NSURL*) url;

- (ResourceFile*) appResourceFileFromArchiveName:(NSString*) archiveName andPath:(NSString*) path andResourceName:(NSString*) resourceName;
- (ResourceFile*) appResourceFileFromArchiveName:(NSString*) archiveName andPath:(NSString*) path andXADLName:(NSString*) xadlName andXFDLName:(NSString*) xfdlName;
- (ResourceFile*) themeResourceFileFromArchiveName:(NSString*) archiveName andPath:(NSString*) path andSize:(NSInteger) size;
- (void)themeResourceFileFromXthemeName:(NSString *)xthemeName;

- (void) appendAppFilesFromEntryFile:(NSString*) aPath withArchiveName:(NSString*) archiveName;
- (void) writeToFile:(NSString*) aPath;
- (void) buildToJavascriptFile:(NSString*) aPath;

- (BOOL) parseFromStream:(NSInputStream*)stream;
- (BOOL) parseFromData:(NSData*)data;
- (BOOL) parseFromURL:(NSURL*)url;

- (BOOL) loadFromStream:(NSInputStream*)stream;
- (BOOL) loadFromData:(NSData*)data;
- (BOOL) loadFromURL:(NSURL*)url;

@end

@class NexacroConfig, NexacroTypeDefinition, NexacroErrorDefinition;


@interface NexacroResourceManager : NSObject {
    NexacroConfig* config;
    NexacroTypeDefinition* typeDefinition;
    NexacroErrorDefinition* errorDefinition;
    NSString* appPath;
    NSString* cachePath;
    NSString* tmpPath;
    NSString* startupFilename;
    NSString* updateURL;
	NSString* bootstrapURL;
    NSString* archiveBootstrapPath;
    BOOL existArchive;
    BOOL direct;
    BOOL offlineMode;
}

@property (readwrite,retain) NexacroConfig* config;
@property (readwrite,retain) NexacroTypeDefinition* typeDefinition;
@property (readonly, retain) NexacroErrorDefinition* errorDefinition;
@property (readwrite,retain) NSString* appPath;
@property (readwrite,retain) NSString* cachePath;
@property (readwrite,retain) NSString* tmpPath;
@property (readwrite,retain) NSString* startupFilename;
@property (readwrite,retain) NSString* updateURL;
@property (readwrite,retain) NSString* bootstrapURL;
@property (nonatomic,readwrite,retain) NSString* archiveBootstrapPath;
@property (readwrite,assign,getter=isExistArchive) BOOL existArchive;
@property (readwrite,assign,getter=isDirect) BOOL direct;
@property (readwrite,assign,getter=isOfflineMode) BOOL offlineMode;

+ (NexacroResourceManager*) sharedResourceManager;

- (NSURL*) startupURL;
- (NSURL*) baseURL;

- (NSString*) startupHTMLString;

- (ProtocolAdaptor*) protocolAdaptorWithName:(NSString*) name;

- (void) setBootstrapURL:(NSString*) aBootstrapURL isDirect:(BOOL) anDirect;

- (BOOL) loadConfigFromFile:(NSString*) file;
- (BOOL) loadConfigFromStream:(NSInputStream*) stream;
- (BOOL) loadConfigFromData:(NSData*) data;
- (BOOL) loadConfigFromURL:(NSURL*) url;

- (BOOL) loadTypeDefinitionFromFile:(NSString*) file;
- (BOOL) loadTypeDefinitionFromStream:(NSInputStream*) stream;
- (BOOL) loadTypeDefinitionFromData:(NSData*) data;
- (BOOL) loadTypeDefinitionFromURL:(NSURL*) url;

- (BOOL) loadBootstrapFromFile:(NSString*) file;
- (BOOL) loadBootstrapFromURL:(NSURL*) url;

- (BOOL) loadErrorDefinitionFromFile:(NSString*) file;
- (BOOL) loadErrorDefinitionFromStream:(NSInputStream*) stream;
- (BOOL) loadErrorDefinitionFromData:(NSData*) data;
- (BOOL) loadErrorDefinitionFromURL:(NSURL*) url;
- (BOOL) loadErrorDefinitionFromFile:(NSString*) file language:(NSString*) aLanguage;
- (BOOL) loadErrorDefinitionFromStream:(NSInputStream*) stream language:(NSString*) aLanguage;
- (BOOL) loadErrorDefinitionFromData:(NSData*) data language:(NSString*) aLanguage;
- (BOOL) loadErrorDefinitionFromURL:(NSURL*) url language:(NSString*) aLanguage;

- (Resource*) resourceFromFile:(NSString*) file;
- (Resource*) resourceFromStream:(NSInputStream*) stream;
- (Resource*) resourceFromData:(NSData*) data;
- (Resource*) respurceFromURL:(NSURL*) url;

- (NSArray *)getXthemeNameFromResourceInfo:(Resource *)resourceInfo;
- (NSString *)getXthemePathFromXthemeName:(NSString *)xthemeName;

@end
