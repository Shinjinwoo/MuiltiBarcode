//
//  MultiBarcodePlugin.h
//  nexacroApp
//
//  Created by 신진우 on 2023/02/16.
//  Copyright © 2023 com.tobesoft. All rights reserved.
//

#import <PluginCommonNP/PluginCommonNP.h>

NS_ASSUME_NONNULL_BEGIN

@interface MultiQRBarcodePlugin : PluginCommon


-(void) sendEx:(int)cd eventID: (NSString*)eventID serviceID: (NSString*)SVCID andMsg: (NSString*) msg;

@end

NS_ASSUME_NONNULL_END
