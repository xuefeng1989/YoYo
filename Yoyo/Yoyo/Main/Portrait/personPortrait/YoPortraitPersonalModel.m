//
//  YoPortraitPersonalModel.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitPersonalModel.h"
#import "Const.h"
#import "NSString+Extension.h"




@implementation YoPortraitPersonalPictureModel
- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"tag"]) {
        self.tags = value;
    } else{
        [super setValue:value forKey:key];
    }
}


@end




@implementation YoPortraitPersonalModel

- (CGFloat)cellHeight {
    YoPortraitPersonalPictureModel *pic = self.pictures.firstObject;
    _cellHeight = 0;
    _cellHeight += RatioZoom(80);
    if (pic && pic.width.floatValue > 0) {
        _cellHeight += (pic.height.floatValue * (SCREEN_WIDTH - 30)/ pic.width.floatValue);
    }else{
        _cellHeight += RatioZoom(400);
    }
    _cellHeight += RatioZoom(55);
    CGFloat contentHeight = [_content sizeWithFont:16 maxW:SCREEN_WIDTH-RatioZoom(30)].height;
    if (contentHeight > RatioZoom(60) && !_isAlreadMore) {
        _cellHeight += RatioZoom(59);   // 缩略文本
        _cellHeight += RatioZoom(20);   // 更多
    }else {
        _cellHeight += contentHeight;
    }
    
    _cellHeight += RatioZoom(10);
    
    return _cellHeight;
}

- (BOOL)isMore {
    CGFloat contentHeight = [_content sizeWithFont:16 maxW:SCREEN_WIDTH-RatioZoom(30)].height;
    if (contentHeight > RatioZoom(60)) {
        return YES;
    }
    return NO;
}
- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.albumId = [NSString stringWithFormat:@"%@",value];
    }else if([key isEqualToString:@"pictures"]){
        NSArray *picArr = (NSArray *)value;
        NSMutableArray *tempPic = [NSMutableArray array];
        for (NSDictionary *dic in picArr) {
            YoPortraitPersonalPictureModel *pic = [[YoPortraitPersonalPictureModel alloc] init];
            [pic setValuesForKeysWithDictionary:dic];
            [tempPic addObject:pic];
        }
        self.pictures = tempPic;
    }else if ([key isEqualToString:@"createTime"]) {
        NSNumber *temp = (NSNumber *)value;
        NSTimeInterval interval    =[temp doubleValue] / 1000.0;
        NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        self.createTime = [formatter stringFromDate: date];
    } else{
        [super setValue:value forKey:key];
    }
}

@end
