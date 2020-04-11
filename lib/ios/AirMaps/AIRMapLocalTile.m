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

@implementation AIRMapLocalTile {
    BOOL _pathTemplateSet;
    BOOL _tileSizeSet;
    BOOL _isBlocked;
    double _transparency;
}

- (void)setPathTemplate:(NSString *)pathTemplate{
    _pathTemplate = pathTemplate;
    _pathTemplateSet = YES;
    [self createTileOverlayAndRendererIfPossible];
    [self update];
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
    [self update];
}

- (void) createTileOverlayAndRendererIfPossible
{
    if (!_pathTemplateSet || !_tileSizeSet) return;
    self.tileOverlay = [[AIRMapLocalTileOverlay alloc] initWithURLTemplate:self.pathTemplate];
    self.tileOverlay.canReplaceMapContent = NO;
    self.tileOverlay.tileSize = CGSizeMake(_tileSize, _tileSize);
    self.renderer = [[MKTileOverlayRenderer alloc] initWithTileOverlay:self.tileOverlay];
    if (self.transparency) {
      self.renderer.alpha = self.transparency;
    }
}

- (void) update
{
    if (!_renderer) return;
    
    if (_map == nil) return;
    
    [_map removeOverlay:self];
    [_map addOverlay:self level:MKOverlayLevelAboveLabels];
}

- (void)reloadData {
    if (!_renderer) return;

    [self.renderer reloadData];
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
