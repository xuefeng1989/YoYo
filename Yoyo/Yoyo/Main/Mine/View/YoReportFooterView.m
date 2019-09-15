//
//  YoReportFooterView.m
//  Yoyo
//
//  Created by yunxin bai on 2019/7/2.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoReportFooterView.h"
#import <QMUIKit/QMUIKit.h>

static const CGFloat kPhotoViewMargin = 15.0;

@interface YoReportFooterView()



@end

@implementation YoReportFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.photoView = [HXPhotoView photoManager:self.manager];
        self.photoView.frame = CGRectMake(kPhotoViewMargin, kPhotoViewMargin, frame.size.width - kPhotoViewMargin * 2, 0);
        self.photoView.outerCamera = YES;
        self.photoView.lineCount = 3;
        self.photoView.previewStyle = HXPhotoViewPreViewShowStyleDark;
        self.photoView.previewShowDeleteButton = YES;  //btn_photo_delete
        self.photoView.deleteImageName = @"btn_photo_delete";
        self.photoView.showAddCell = YES;
        [self.photoView.collectionView reloadData];
        self.photoView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.photoView];
    }
    return self;
}



- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = NO;
        _manager.configuration.lookLivePhoto = YES;
        _manager.configuration.photoMaxNum = 9;
        
        _manager.configuration.creationDateSort = YES;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.showOriginalBytes = YES;
        _manager.configuration.reverseDate = YES;
        _manager.configuration.showDateSectionHeader = NO;
        _manager.configuration.hideOriginalBtn = YES;
        
    }
    return _manager;
}

@end
