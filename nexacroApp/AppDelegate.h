//
//  AppDelegate.h
//  nexacroApp
//
//  Created by 김재환 on 2016. 11. 24..
//  Copyright © 2016년 com.tobesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <nexacro/NexacroAppDelegate.h>
#import <nexacro/NexacroMainViewController.h>
#import "MultiQRBarcodePlugin.h"

@interface AppViewController : NexacroMainViewController
{
    
}

@property (nonatomic, assign) MultiQRBarcodePlugin *multiQRBarcodePlugin;

@end

@interface AppDelegate : NexacroAppDelegate <UIApplicationDelegate>
- (NexacroMainViewController*)initializeMainViewController;


@end
