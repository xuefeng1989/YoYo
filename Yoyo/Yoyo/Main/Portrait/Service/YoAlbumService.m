//
//  YoAlbumService.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/5.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoAlbumService.h"

@implementation YoAlbumService{
    NSString *_albumId;
    NSString *_authorId;
    NSString *_pushContent;
    NSArray *_images;
    NSInteger _type;
}

- (instancetype)initWithAlbumId:(NSString *)albumId authorId:(NSString *)authorId sendType:(YoAlbumType)type {
    self = [super init];
    if (self) {
        _albumId = albumId;
        _authorId = authorId;
        _type = type;
    }
    return self;
}

- (instancetype)initWithPushContent:(NSString *)pushContent images:(NSArray *)images type:(YoAlbumType)type {
    self = [super init];
    if (self) {
        _pushContent = pushContent;
        _images = images;
        _type = type;
    }
    return self;
}
- (YTKRequestMethod)requestMethod {
    switch (_type) {
        case YoAlbumTypePraise:
         return YTKRequestMethodPOST;
            break;
        case YoAlbumTypePraiseCancel:
            return YTKRequestMethodDELETE;
            break;
    }
     return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    NSString *url;
    switch (_type) {
        case YoAlbumTypePraise:
        case YoAlbumTypePraiseCancel:
           return  url = [NSString stringWithFormat:@"v1/album/%@/like",_albumId];
            break;
        case YoAlbumTypeCollect:
        case YoAlbumTypeRelation:
            url = @"/api/1.0.0/album/postAlbumOption";
            break;
        case YoAlbumTypeCommentPraise:
            url = @"/api/1.0.0/album/saveAndPublish";
            break;
        case YoAlbumTypeCollectCancel:
        case YoAlbumTypeRelationCancel:
        case YoAlbumTypeCommentPraiseCancel:
            url = @"/api/1.0.0/album/cancleAlbumOption";
            break;
    }
    return url;
}

- (id)requestArgument {
    [super requestArgument];
    [self.params setValue:_albumId forKey:@"albumId"];
    return self.params;
}


@end
