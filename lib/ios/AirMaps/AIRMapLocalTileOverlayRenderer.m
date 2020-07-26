#import "AIRMapLocalTileOverlayRenderer.h"
#import <MapKit/MapKit.h>
#import <CoreServices/CoreServices.h>

@implementation AIRMapLocalTileOverlayRenderer

- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
       
    MKTileOverlayPath mapPath = [self pathForMapRect:mapRect zoomScale:zoomScale];
    MKTileOverlayPath imagePath = [self imagePath:mapPath];
    
    NSString *imageURL = [self stringForTilePath:imagePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageURL]) {
        return YES;
    };

    return NO;
}

-(NSString*)stringForTilePath:(MKTileOverlayPath)path {
    NSMutableString *tileFilePath = [self.customPath mutableCopy];

    [tileFilePath replaceOccurrencesOfString: @"{x}" withString:[NSString stringWithFormat:@"%li", (long)path.x] options:0 range:NSMakeRange(0, tileFilePath.length)];
    [tileFilePath replaceOccurrencesOfString:@"{y}" withString:[NSString stringWithFormat:@"%li", (long)path.y] options:0 range:NSMakeRange(0, tileFilePath.length)];
    [tileFilePath replaceOccurrencesOfString:@"{z}" withString:[NSString stringWithFormat:@"%li", (long)path.z] options:0 range:NSMakeRange(0, tileFilePath.length)];

    return tileFilePath;
}

- (NSInteger) zoomScaleToZoomLevel:(MKZoomScale)zoomScale {
    return log2(zoomScale) + 19;
}

- (MKTileOverlayPath)pathForMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
    MKTileOverlay *tileOverlay = (MKTileOverlay *)self.overlay;

    NSInteger x = round(mapRect.origin.x * zoomScale / (tileOverlay.tileSize.width * 2));
    NSInteger y = round(mapRect.origin.y * zoomScale / (tileOverlay.tileSize.width * 2));
    NSInteger z = [self zoomScaleToZoomLevel:zoomScale];

    MKTileOverlayPath path = {
        .x = x,
        .y = y,
        .z = z,
        .contentScaleFactor = self.contentScaleFactor
    };

    return path;
}

-(MKTileOverlayPath) imagePath:(MKTileOverlayPath)path {
    MKTileOverlayPath imgPath = {
        .x = path.x,
        .y = path.y,
        .z = path.z,
        .contentScaleFactor = self.contentScaleFactor,
    };
    
    return imgPath;
}

- (void) drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    
        MKTileOverlayPath mapPath = [self pathForMapRect:mapRect zoomScale:zoomScale];
    
        MKTileOverlayPath imagePath = [self imagePath:mapPath];
        
        NSString *imageURL = [self stringForTilePath:imagePath];
        
        NSData* imageData = [NSData dataWithContentsOfFile:imageURL];

        UIImage* image = [UIImage imageWithData:imageData];

        CGRect theRect = [self rectForMapRect:mapRect];
        
        UIGraphicsBeginImageContext(image.size);

        CGContextRef ctx=(UIGraphicsGetCurrentContext());
        
        CGContextRotateCTM (ctx, M_PI);
        CGContextScaleCTM(ctx, -1.0, 1.0);
        CGContextTranslateCTM(ctx, 0.0, -image.size.height);

        [image drawAtPoint:CGPointMake(0, 0)];

        UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGImageRef ref = nil;
        
        CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
        ref = CGImageCreateWithImageInRect(img.CGImage, rect);

        CGContextAddRect(context, theRect);
        CGContextDrawImage(context, theRect, ref);
        
        CGImageRelease(ref);
}

@end

