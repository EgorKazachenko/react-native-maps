//
//  AIRMapLocalTile.m
//  AirMaps
//
//  Created by Peter Zavadsky on 01/12/2017.
//  Copyright © 2017 Christopher. All rights reserved.
//

#import "AIRMapLocalTile.h"
#import <React/UIView+React.h>
#import "AIRMapLocalTileOverlay.h"
#import "AIRMapLocalTileOverlayRenderer.h"

@implementation AIRMapLocalTile {
    BOOL _pathTemplateSet;
    double _transparency;
}

- (void)setPathTemplate:(NSString *)pathTemplate{
    _pathTemplate = pathTemplate;
    _pathTemplateSet = YES;
    
    if ([_map.overlays containsObject:self]) {
        self.renderer.customPath = _pathTemplate;
         
        [self.renderer setNeedsDisplay];
    } else {
        [self createTileOverlayAndRendererIfPossible];
    }
}

-(void)setActive:(BOOL)active {
    if (active && self.renderer) {        
        [self.renderer setNeedsDisplay];
    }
}

- (void)setTransparency:(double)transparency {
    _transparency = transparency;
    if (_renderer) {
        self.renderer.alpha = transparency;
    }
}

- (void) createTileOverlayAndRendererIfPossible
{
    self.tileOverlay = [[AIRMapLocalTileOverlay alloc] initWithURLTemplate:self.pathTemplate];
    self.tileOverlay.canReplaceMapContent = NO;
    self.tileOverlay.tileSize = CGSizeMake(512.0f, 512.0f);
    self.renderer = [[AIRMapLocalTileOverlayRenderer alloc] initWithTileOverlay:self.tileOverlay];
    self.renderer.customPath = _pathTemplate;
    
    if (self.transparency) {
        self.renderer.alpha = self.transparency;
    }
}


#pragma mark MKOverlay implementation

- (CLLocationCoordinate2D) coordinate
{
    return self.tileOverlay.coordinate;
}

- (MKMapRect) boundingMapRect
{
    return self.tileOverlay.boundingMapRect;
}

- (BOOL)canReplaceMapContent
{
    return self.tileOverlay.canReplaceMapContent;
}

@end
