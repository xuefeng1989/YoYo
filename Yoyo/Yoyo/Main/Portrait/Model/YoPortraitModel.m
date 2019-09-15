//
//  YoPortraitModel.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitModel.h"
#import "Const.h"
#import "NSString+Extension.h"


@implementation YoPortraitModel
- (NSString *)datingStatusString {
//    0不可约 1可约 2在国外 3看礼物 4高素质
    NSString *string = @"";
    switch (_datingStatus) {
        case 0:
            string = @"不可约";
            break;
        case 1:
            string = @"可约";
            break;
        case 2:
            string = @"在国外";
            break;
        case 3:
            string = @"看礼物";
            break;
        case 4:
            string = @"高素质";
            break;
    }
    return string;
}

- (CGFloat)cellHeight {
    if (_cellHeight == 0) {
        _cellHeight += RatioZoom(80);
        _cellHeight += RatioZoom(400);
        _cellHeight += RatioZoom(55);
        
        _cellHeight += [_pushContent sizeWithFont:16 maxW:SCREEN_WIDTH-RatioZoom(30)].height;
        
        _cellHeight += RatioZoom(10);
    }
    return _cellHeight;
}

- (CGSize)imgSize {
    
    NSArray *array = [_picture componentsSeparatedByString:@"_"]; //从字符A中分隔成2个元素的数组
    if (array.count == 3) {
        NSString *str = array[1];
        NSArray *newArray = [str componentsSeparatedByString:@"x"];
        if(newArray.count == 2) {
            CGFloat width = [newArray[0] floatValue];
            CGFloat height = [newArray[1] floatValue];
            return CGSizeMake(width, height);
        }
    }
    return CGSizeMake(100, 100);
}
- (NSString *)gap{
    double getDis = [JSTool distanceBetweenOrderBylongitude1:YoUserDefault.longitude latitude1:YoUserDefault.latitude
                                                  longitude2:self.longitude latitude2:self.latitude];
    if (getDis > 1000) {
        return  [NSString stringWithFormat:@"%.1fkm",getDis/1000];
    } else {
         return [NSString stringWithFormat:@"%.2fm",getDis];
    }
}
- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.albumId = [NSString stringWithFormat:@"%@",value];
    }else if ([key isEqualToString:@"lon"]){
        NSNumber *longitude = (NSNumber *)value;
        self.longitude = longitude.doubleValue;
    } else if ([key isEqualToString:@"lat"]){
        NSNumber *latitude = (NSNumber *)value;
        self.latitude = latitude.doubleValue;
    }else{
        [super setValue:value forKey:key];
    }
}
@end

@implementation YoImageModelIcon


@end
