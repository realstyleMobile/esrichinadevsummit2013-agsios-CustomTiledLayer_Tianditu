//
//  TiandituTileOperation.m
//  CustomTiledLayerSample
//
//  Created by EsriChina_Mobile_MaY on 13-3-27.
//
//

#import "TianDiTuWMTSTileOperation.h"
#define kURLGetTile @"%@?service=wmts&request=gettile&version=1.0.0&layer=%@&format=tiles&tilematrixset=%@&tilecol=%d&tilerow=%d&tilematrix=%d"

@implementation TianDiTuWMTSTileOperation
@synthesize tileKey=_tileKey;
@synthesize target=_target;
@synthesize action=_action;
@synthesize imageData = _imageData;
@synthesize layerInfo = _layerInfo;

- (id)initWithTileKey:(AGSTileKey *)tileKey TiledLayerInfo:(TianDiTuWMTSLayerInfo *)layerInfo target:(id)target action:(SEL)action{
	
	if (self = [super init]) {
		self.target = target;
		self.action = action;
		self.tileKey = tileKey;
		self.layerInfo = layerInfo;
	}
    return self;
}

-(void)main {
	//Fetch the tile for the requested Level, Row, Column
	@try {
        if (self.tileKey.level > self.layerInfo.maxZoomLevel ||self.tileKey.level < self.layerInfo.minZoomLevel) {
            return;
        }
        NSString *baseUrl= [NSString stringWithFormat:kURLGetTile,self.layerInfo.url,self.layerInfo.layerName,self.layerInfo.tileMatrixSet,self.tileKey.column,self.tileKey.row,(self.tileKey.level + 2)];
        //NSLog(baseUrl);
		NSURL* aURL = [NSURL URLWithString:baseUrl];
		self.imageData = [[NSData alloc] initWithContentsOfURL:aURL];
	}
	@catch (NSException *exception) {
		NSLog(@"main: Caught Exception %@: %@", [exception name], [exception reason]);
	}
	@finally {
		//Invoke the layer's action method
		[_target performSelector:_action withObject:self];
	}
    
}
@end
