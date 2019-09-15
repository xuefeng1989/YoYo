//
//  YoPortraitCommentService.m
//  Yoyo
//
//  Created by yunxin bai on 2019/7/3.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitCommentService.h"

@implementation YoPortraitCommentService{
    NSInteger _pageIndex;
    NSInteger _pageSize;
    NSString *_albumId;
    NSString *_targetUserId;
    NSString *_comment;
    NSString *_parentId;
    YoPortraitCommentServiceType _type;
}

- (instancetype)initWithAlbumId:(NSString *)albumId targetUserId:(NSString *)targetUserId comment:(NSString *)comment parentId:(NSString *)parentId type:(YoPortraitCommentServiceType)type{
    self = [super init];
    if (self) {
        _targetUserId = targetUserId;
        _comment = comment;
        _albumId = albumId;
        _parentId = parentId;
        _type = type;
    }
    return self;
}

- (instancetype)initWithAlbumId:(NSString *)albumId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize type:(YoPortraitCommentServiceType)type{
    self = [super init];
    if (self) {
        _pageIndex = pageIndex;
        _pageSize = pageSize == 0 ? 10 : pageSize;
        _albumId = albumId;
        _type = type;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    switch (_type) {
        case YoPortraitCommentServiceTypeGetList:
            return YTKRequestMethodGET;
            break;
        default:
           return YTKRequestMethodPOST;
            break;
    }
}

- (NSString *)requestUrl {
    NSString *url;
    switch (_type) {
        case YoPortraitCommentServiceTypeGetList:
            url = @"v1/album/comment/list";
            break;
        case YoPortraitCommentServiceTypeCreate:
            url = [NSString stringWithFormat:@"v1/album/%@/comment",_albumId];
            break;
    }
    return url;
}

- (id)requestArgument {
    [super requestArgument];
    switch (_type) {
        case YoPortraitCommentServiceTypeGetList:
             [self.params setValue:_albumId forKey:@"albumId"];
            [self.params setValue:@(_pageIndex) forKey:@"current"];
            [self.params setValue:@(_pageSize) forKey:@"size"];
            break;
        case YoPortraitCommentServiceTypeCreate:
//            [self.params setValue:_albumId forKey:@"albumId"];
//            [self.params setValue:_targetUserId forKey:@"targetUserId"];
        {
            
            [self.params setValue:_comment forKey:@"comment"];
            if (_parentId && _parentId.length > 0) {
                [self.params setValue:_parentId forKey:@"parentId"];
            }
        }
         
            break;
    }
    return self.params;
}

@end
