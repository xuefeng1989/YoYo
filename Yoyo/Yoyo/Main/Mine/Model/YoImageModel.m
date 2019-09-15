//
//  YoImageModel.m
//  Yoyo
//
//  Created by guzhichao on 2019/8/10.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoImageModel.h"

@implementation YoImageModel

- (instancetype)initWithType:(YoMineUploadCollectionViewCellType)type photo:(UIImage *)photo imageUrl:(NSString *)imageUrl {
    if (self = [super init]) {
        _imageType = type;
        _image = photo;
        _photo = imageUrl;
    }
    return self;
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"type"]) {
        NSNumber *type = (NSNumber *)value;
        switch (type.integerValue) {
            case 0:
              self.imageType = YoMineUploadCollectionViewCellTypeNormal;
              break;
            case 1:
                 self.imageType = YoMineUploadCollectionViewCellTypeFire;
                break;
            case 2:
                self.imageType = YoMineUploadCollectionViewCellTypePay;
                break;
            case 3:
                self.imageType = YoMineUploadCollectionViewCellTypeFireReaded;
                break;
            case 4:
                self.imageType = YoMineUploadCollectionViewCellTypePayed;
                break;
            default:
                self.imageType = YoMineUploadCollectionViewCellTypeNormal;
                break;
        }
    } else if ([key isEqualToString:@"id"]){
        self.imageId = [NSString stringWithFormat:@"%@",value];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
