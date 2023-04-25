//
//  CameraViewController2.h
//  nexacroApp
//
//  Created by 신진우 on 2023/02/16.
//  Copyright © 2023 com.tobesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MultiQRBarcodeViewController : UIViewController
{
    bool isUseFrontCamera;
    bool isUseAutoSelect;
    bool isUseTextLabel;
    bool isUseSoundEffect;
    bool isUseAutoCapture;
    bool isUseTimer;
    bool isUseVibration;
    bool isUsePinchZoom;
    
    long selectingCount;
    NSInteger  barcodeFormat;
    NSInteger  limitCount;
    
    CGFloat  limitTime;
    CGFloat  zoomFactor;
    UIColor *boxColor;
    //NSMutableArray *seenElements;
}


@property bool isUseFrontCamera;
@property bool isUseTextLabel;
@property bool isUseSoundEffect;
@property bool isUseTimer;
@property bool isUseAutoCapture;
@property bool isUseVibration;
@property bool isUsePinchZoom;
@property bool isUnlimitedTime;

@property long selectingCount;
@property NSInteger  barcodeFormat;
@property NSInteger  limitCount;

@property CGFloat  limitTime;
@property CGFloat  zoomFactor;

@property UIColor* boxColor;

@end

NS_ASSUME_NONNULL_END
