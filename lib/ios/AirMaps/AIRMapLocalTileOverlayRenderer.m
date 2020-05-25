#import "AIRMapLocalTileOverlayRenderer.h"
#import <MapKit/MapKit.h>
#import <CoreServices/CoreServices.h>

@implementation AIRMapLocalTileOverlayRenderer

//- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
//    MKTileOverlayPath path = [self tilePathForMapRect:mapRect andZoomScale:zoomScale];
//    NSString* tileFilePath = [self stringForTilePath:path];
//
//    if ([[NSFileManager defaultManager] fileExistsAtPath:tileFilePath]) {
//        return YES;
//    } else {
//        return NO;
//    };
//}

- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
       
    MKTileOverlayPath mapPath = [self pathForMapRect:mapRect zoomScale:zoomScale];
    MKTileOverlayPath imagePath = [self imagePath:mapPath];
    
    NSString *imageURL = [self stringForTilePath:imagePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageURL]) {
        return YES;
    };

    return NO;
}
//
//- (void) drawMapRect: (MKMapRect) mapRect zoomScale: (MKZoomScale) zoomScale inContext: (CGContextRef) ctx
//{
//    MKTileOverlayPath path = [self tilePathForMapRect:mapRect andZoomScale:zoomScale];
//    NSString* tileFilePath = [self stringForTilePath:path];
//
//    if ([[NSFileManager defaultManager] fileExistsAtPath:tileFilePath]) {
//
//        NSData* imageData = [NSData dataWithContentsOfFile:tileFilePath];
//
//        UIImage* image = [UIImage imageWithData:imageData];
//
//        UIGraphicsBeginImageContext(image.size);
//
//        CGContextRef context=(UIGraphicsGetCurrentContext());
//
//        CGContextRotateCTM (context, M_PI);
//        CGContextScaleCTM(context, -1.0, 1.0);
//        CGContextTranslateCTM(context, 0.0, -image.size.height);
//
//        [image drawAtPoint:CGPointMake(0, 0)];
//
//        UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//
//        CGImageRef ref = img.CGImage;
//
//        CGRect theRect = [self rectForMapRect:mapRect];
//
//        CGContextAddRect(ctx, theRect);
//        CGContextDrawImage(ctx, theRect, ref);
//    }
//}
//
//-(MKTileOverlayPath)tilePathForMapRect:(MKMapRect)mapRect andZoomScale:(MKZoomScale)zoom {
//    int zoom_level = [self zoomLevelForZoomScale:zoom];
//    //print("mercPt: " + String(mercatorPoint))
//
//    MKCoordinateRegion map_region = MKCoordinateRegionForMapRect(mapRect);
//
//    int tileX = (int)(floor((map_region.center.longitude + 180.0) / 360.0 * pow(2.0, zoom_level)));
//    int tileY = (int)(floor((1.0 - log(tan(map_region.center.latitude * M_PI/180.0) + 1.0 / cos(map_region.center.latitude * M_PI/180.0)) / M_PI) / 2.0 * pow(2.0, zoom_level)));
//
//    MKTileOverlayPath path;
//
//    path.x = tileX;
//    path.y = tileY;
//    path.z = zoom_level;
//    path.contentScaleFactor = 1;
//
//    return path;
//}
//
-(NSString*)stringForTilePath:(MKTileOverlayPath)path {
    NSMutableString *tileFilePath = [self.customPath mutableCopy];

    [tileFilePath replaceOccurrencesOfString: @"{x}" withString:[NSString stringWithFormat:@"%li", (long)path.x] options:0 range:NSMakeRange(0, tileFilePath.length)];
    [tileFilePath replaceOccurrencesOfString:@"{y}" withString:[NSString stringWithFormat:@"%li", (long)path.y] options:0 range:NSMakeRange(0, tileFilePath.length)];
    [tileFilePath replaceOccurrencesOfString:@"{z}" withString:[NSString stringWithFormat:@"%li", (long)path.z] options:0 range:NSMakeRange(0, tileFilePath.length)];

    return tileFilePath;
}
//
//-(int)zoomLevelForZoomScale:(MKZoomScale)zoomScale {
//    double real_scale = zoomScale;
//    int z = (log2(real_scale)+18.0);
//    return z;
//}
//
//- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
//    UIGraphicsBeginImageContext(size);
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return destImage;
//}

- (NSInteger) zoomScaleToZoomLevel:(MKZoomScale)zoomScale {
    return log2(zoomScale) + 18;
}

- (MKTileOverlayPath)pathForMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
    MKTileOverlay *tileOverlay = (MKTileOverlay *)self.overlay;
    CGFloat factor = tileOverlay.tileSize.width / 512;

    NSInteger x = round(mapRect.origin.x * zoomScale / (tileOverlay.tileSize.width / factor));
    NSInteger y = round(mapRect.origin.y * zoomScale / (tileOverlay.tileSize.width / factor));
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
        .x = floor(path.x / 2),
        .y = floor(path.y / 2),
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
        
        if (mapPath.x % 2 == 0 && mapPath.y % 2 == 1) {
            CGRect rect = CGRectMake(0, 0, img.size.width / 2, img.size.height / 2);
            ref = CGImageCreateWithImageInRect(img.CGImage, rect);
        } else
        if (mapPath.x % 2 == 0 && mapPath.y % 2 == 0) {
            CGRect rect = CGRectMake(0, img.size.height / 2 + 1, img.size.width / 2, img.size.height / 2);
            ref = CGImageCreateWithImageInRect(img.CGImage, rect);
        } else
        if (mapPath.x % 2 == 1 && mapPath.y % 2 == 1) {
            CGRect rect = CGRectMake(img.size.width / 2 + 1, 0, img.size.width / 2, img.size.height / 2);
            ref = CGImageCreateWithImageInRect(img.CGImage, rect);
        } else
        if (mapPath.x % 2 == 1 && mapPath.y % 2 == 0) {
            CGRect rect = CGRectMake(img.size.width / 2 + 1, img.size.height / 2 + 1, img.size.width / 2, img.size.height / 2);
            ref = CGImageCreateWithImageInRect(img.CGImage, rect);
        }

        CGContextAddRect(context, theRect);
        CGContextDrawImage(context, theRect, ref);
        
        CGImageRelease(ref);
}

@end

