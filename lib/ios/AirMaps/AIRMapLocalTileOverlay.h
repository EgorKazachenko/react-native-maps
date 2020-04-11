//
//  AIRMapLocalTileOverlay.h
//  Pods
//
//  Created by Peter Zavadsky on 04/12/2017.
//

#import <MapKit/MapKit.h>

@interface AIRMapLocalTileOverlay : MKTileOverlay

@property (nonatomic, copy) NSString* customPath;

-(void)setCustomPath:(NSString *)customPath;

@end
