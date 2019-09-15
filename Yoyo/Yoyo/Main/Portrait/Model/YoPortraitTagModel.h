//
//  YoPortraitTagModel.h
//  Yoyo
//
//  Created by yunxin bai on 2019/7/14.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YoAddTagTableViewCellType) {
    YoAddTagTableViewCellTypeAdd = 0,
    YoAddTagTableViewCellTypeLocation,
};

@interface YoPortraitTagModel : NSObject
@property (nonatomic, assign) YoAddTagTableViewCellType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@end

NS_ASSUME_NONNULL_END
