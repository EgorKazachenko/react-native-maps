//
//  AIRMapLocalTileManager.m
//  AirMaps
//
//  Created by Peter Zavadsky on 01/12/2017.
//  Copyright © 2017 Christopher. All rights reserved.
//

#import <React/RCTBridge.h>
#import <React/RCTConvert.h>
#import <React/RCTConvert+CoreLocation.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import <React/UIView+React.h>
#import "AIRMapMarker.h"
#import "AIRMapLocalTile.h"

#import "AIRMapLocalTileManager.h"

@interface AIRMapLocalTileManager()

@end

@implementation AIRMapLocalTileManager


RCT_EXPORT_MODULE()

- (UIView *)view
{
    AIRMapLocalTile *tile = [AIRMapLocalTile new];
    tile.bridge = self.bridge;
    return tile;
}

RCT_EXPORT_VIEW_PROPERTY(pathTemplate, NSString)
RCT_EXPORT_VIEW_PROPERTY(tileSize, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(opacity, CGFloat)


RCT_EXPORT_METHOD(forceUpdate:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        id view = viewRegistry[reactTag];
        if (![view isKindOfClass:[AIRMapLocalTile class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting AIRMap, got: %@", view);
        } else {
            [(AIRMapLocalTile *) view forceUpdate];
        }
    }];
}

@end
