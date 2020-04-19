#import "AIRMapLocalTileOverlayRenderer.h"
#import <MapKit/MapKit.h>
#import <CoreServices/CoreServices.h>

@implementation AIRMapLocalTileOverlayRenderer

- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {    
    MKTileOverlayPath path = [self tilePathForMapRect:mapRect andZoomScale:zoomScale];
    NSString* tileFilePath = [self stringForTilePath:path];

    if ([[NSFileManager defaultManager] fileExistsAtPath:tileFilePath]) {
        return YES;
    } else {
        return NO;
    };
}

- (void) drawMapRect: (MKMapRect) mapRect zoomScale: (MKZoomScale) zoomScale inContext: (CGContextRef) ctx
{
    MKTileOverlayPath path = [self tilePathForMapRect:mapRect andZoomScale:zoomScale];
    NSString* tileFilePath = [self stringForTilePath:path];
        
    if ([[NSFileManager defaultManager] fileExistsAtPath:tileFilePath]) {
                
        NSData* imageData = [NSData dataWithContentsOfFile:tileFilePath];
        
        UIImage* image = [UIImage imageWithData:imageData];
        
        UIGraphicsBeginImageContext(image.size);
        
        CGContextRef context=(UIGraphicsGetCurrentContext());
        
        CGContextRotateCTM (context, M_PI);
        CGContextScaleCTM(context, -1.0, 1.0);
        CGContextTranslateCTM(context, 0.0, -image.size.height);

        [image drawAtPoint:CGPointMake(0, 0)];
        
        UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGImageRef ref = img.CGImage;
//        CGImageRelease(ref);
        
        CGRect theRect = [self rectForMapRect:mapRect];
        
        CGContextAddRect(ctx, theRect);
        CGContextDrawImage(ctx, theRect, ref);
    }
}

-(MKTileOverlayPath)tilePathForMapRect:(MKMapRect)mapRect andZoomScale:(MKZoomScale)zoom {
    int zoom_level = [self zoomLevelForZoomScale:zoom];
    //print("mercPt: " + String(mercatorPoint))

    MKCoordinateRegion map_region = MKCoordinateRegionForMapRect(mapRect);
    
    int tileX = (int)(floor((map_region.center.longitude + 180.0) / 360.0 * pow(2.0, zoom_level)));
    int tileY = (int)(floor((1.0 - log(tan(map_region.center.latitude * M_PI/180.0) + 1.0 / cos(map_region.center.latitude * M_PI/180.0)) / M_PI) / 2.0 * pow(2.0, zoom_level)));

    MKTileOverlayPath path;
    
    path.x = tileX;
    path.y = tileY;
    path.z = zoom_level;
    path.contentScaleFactor = 1;
    
    return path;
}

-(NSString*)stringForTilePath:(MKTileOverlayPath)path {
    NSMutableString *tileFilePath = [self.customPath mutableCopy];
    
    [tileFilePath replaceOccurrencesOfString: @"{x}" withString:[NSString stringWithFormat:@"%li", (long)path.x] options:0 range:NSMakeRange(0, tileFilePath.length)];
    [tileFilePath replaceOccurrencesOfString:@"{y}" withString:[NSString stringWithFormat:@"%li", (long)path.y] options:0 range:NSMakeRange(0, tileFilePath.length)];
    [tileFilePath replaceOccurrencesOfString:@"{z}" withString:[NSString stringWithFormat:@"%li", (long)path.z] options:0 range:NSMakeRange(0, tileFilePath.length)];
    
    return tileFilePath;
}

-(int)zoomLevelForZoomScale:(MKZoomScale)zoomScale {
    double real_scale = zoomScale;
    int z = (log2(real_scale)+19.0);
    return z;
}

@end

