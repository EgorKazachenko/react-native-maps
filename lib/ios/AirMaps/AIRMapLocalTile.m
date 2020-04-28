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
    BOOL _tileSizeSet;
    BOOL _isBlocked;
    BOOL _transparencySet;
    double _transparency;
}

- (void)setPathTemplate:(NSString *)pathTemplate{
    _pathTemplate = pathTemplate;
    _pathTemplateSet = YES;
    [self createTileOverlayAndRendererIfPossible];
    // [self update];
}

- (void)setTransparency:(double)transparency {
    _transparency = transparency;
    if (_renderer) {
        self.renderer.alpha = transparency;
    }
}

- (void)setTileSize:(CGFloat)tileSize{
    _tileSize = tileSize;
    _tileSizeSet = YES;
    [self createTileOverlayAndRendererIfPossible];
    // [self update];
}

- (void) createTileOverlayAndRendererIfPossible
{
    
    if (!_pathTemplateSet || !_tileSizeSet) return;

    if (![_map.overlays containsObject:self]) {
        self.tileOverlay = [[AIRMapLocalTileOverlay alloc] initWithURLTemplate:self.pathTemplate];
        self.tileOverlay.canReplaceMapContent = NO;
//        self.tileOverlay.tileSize = CGSizeMake(_tileSize, _tileSize);
        self.renderer = [[AIRMapLocalTileOverlayRenderer alloc] initWithTileOverlay:self.tileOverlay];
        self.renderer.customPath = _pathTemplate;
        if (self.transparency) {
            self.renderer.alpha = self.transparency;
        }
    } else {
//        [_map removeOverlay:self];
//        [_map addOverlay:self level:MKOverlayLevelAboveLabels];
//        self.tileOverlay.customPath = self.pathTemplate;
        self.renderer.customPath = _pathTemplate;
       [self.renderer setNeedsDisplayInMapRect:MKMapRectWorld];
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
