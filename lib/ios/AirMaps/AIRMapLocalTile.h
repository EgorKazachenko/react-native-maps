//
//  AIRMapLocalTile.h
//  AirMaps
//
//  Created by Peter Zavadsky on 01/12/2017.
//  Copyright © 2017 Christopher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "AIRMapLocalTileOverlay.h"
#import "AIRMapLocalTileOverlayRenderer.h"

#import <React/RCTComponent.h>
#import <React/RCTView.h>
#import "AIRMapCoordinate.h"
#import "AIRMap.h"
#import "RCTConvert+AirMap.h"

@class RCTBridge;

@interface AIRMapLocalTile : MKAnnotationView <MKOverlay>

@property (nonatomic, weak) AIRMap *map;
@property (nonatomic, weak) RCTBridge *bridge;

@property (nonatomic, strong) AIRMapLocalTileOverlay *tileOverlay;
@property (nonatomic, strong) AIRMapLocalTileOverlayRenderer *renderer;

@property (nonatomic, copy) NSString *pathTemplate;
@property (nonatomic, assign) CGFloat tileSize;
@property double transparency;

- (void)reloadData;

#pragma mark MKOverlay protocol

@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic, readonly) MKMapRect boundingMapRect;
//- (BOOL)intersectsMapRect:(MKMapRect)mapRect;
- (BOOL)canReplaceMapContent;

@end
