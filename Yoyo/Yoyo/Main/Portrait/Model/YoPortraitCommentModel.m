//
//  YoPortraitCommentModel.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitCommentModel.h"
#import "Const.h"
#import "NSString+Extension.h"

@implementation YoPortraitCommentModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",
             };
}

- (void)setChildrenList:(NSArray<YoPortraitCommentModel *> *)childrenList {
//    _childrenList = childrenList;
    _childrenList = [YoPortraitCommentModel mj_objectArrayWithKeyValuesArray:childrenList];
}

- (CGFloat)cellHeight {
    if (_cellHeight == 0) {
        _cellHeight += RatioZoom(75);
        _cellHeight += [_comment sizeWithFont:16 maxW:SCREEN_WIDTH-RatioZoom(81)].height;
        _cellHeight += RatioZoom(15);
        
        
        if (_childrenList.count == 1) {
         _cellHeight += [_childrenList.firstObject.comment sizeWithFont:13 maxW:SCREEN_WIDTH-RatioZoom(111)].height;
            _cellHeight += RatioZoom(50);
        }else if (_childrenList.count > 1) {
          _cellHeight += [_childrenList.firstObject.comment sizeWithFont:13 maxW:SCREEN_WIDTH-RatioZoom(111)].height;
            _cellHeight += RatioZoom(80);
        }else {
            
        }
    }
    return _cellHeight;
}
@end
