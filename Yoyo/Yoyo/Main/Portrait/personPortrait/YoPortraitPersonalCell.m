//
//  YoPortraitPersonalCell.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/4.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoPortraitPersonalCell.h"
#import <QMUIKit.h>
#import <Masonry.h>
#import "Const.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YoDataItem.h"
#import "YoPortraitPersonalModel.h"
#import "YoAlbumService.h"


@interface HeaderView : UIView
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) QMUILabel *nameLabel;
@property (nonatomic, strong) QMUILabel *detailsLabel;
@property (nonatomic, strong) QMUILabel *hotLabel;
@end

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(RatioZoom(16));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(45.0f);
            make.width.mas_equalTo(45.0f);
        }];
        
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarImageView.mas_right).offset(RatioZoom(16));
            make.top.mas_equalTo(self.avatarImageView);
        }];
        
        [self addSubview:self.detailsLabel];
        [self.detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.bottom.mas_equalTo(self.avatarImageView);
        }];
        
        [self addSubview:self.hotLabel];
        [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-RatioZoom(13));
            make.centerY.mas_equalTo(self.nameLabel);
        }];
    }
    return self;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.frame = CGRectMake(0, 0, 45, 45);
        _avatarImageView.layer.cornerRadius = 45 * 0.5;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (QMUILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [QMUILabel new];
        _nameLabel.font = UIFontMake(16);
        _nameLabel.textColor = DEFAULT_CONTENT_COLOR;
        _nameLabel.text = @"木兮 3.5km";
    }
    return _nameLabel;
}

- (QMUILabel *)detailsLabel {
    if (!_detailsLabel) {
        _detailsLabel = [QMUILabel new];
        _detailsLabel.font = UIFontMake(13);
        _detailsLabel.textColor = DEFAULT_SUBTITLE_COLOR;
        _detailsLabel.text = @"4月5号集";
    }
    return _detailsLabel;
}

- (QMUILabel *)hotLabel {
    if (!_hotLabel) {
        _hotLabel = [QMUILabel new];
        _hotLabel.font = UIFontMake(13);
        _hotLabel.textColor = DEFAULT_SUBTITLE_COLOR;
        _hotLabel.text = @"当前热度1.2万";
    }
    return _hotLabel;
}

@end

@interface BottomView : UIView

@property (nonatomic, strong) QMUIButton *foucsButton;
@property (nonatomic, strong) QMUIButton *topButton;
@property (nonatomic, strong) QMUIButton *likeButton;
@property (nonatomic, strong) QMUIButton *commentButton;

@end

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.foucsButton];
        [self.foucsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.top.mas_equalTo(RatioZoom(10));
            make.width.mas_equalTo(RatioZoom(50));
            make.height.mas_equalTo(RatioZoom(25));
        }];
        
        [self addSubview:self.commentButton];
        [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-RatioZoom(8));
            make.centerY.mas_equalTo(self.foucsButton);
        }];
        
        [self addSubview:self.likeButton];
        [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.commentButton.mas_left).offset(-RatioZoom(8));
            make.centerY.mas_equalTo(self.foucsButton);
        }];
        
        [self addSubview:self.topButton];
        [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.likeButton.mas_left).offset(-RatioZoom(8));
            make.centerY.mas_equalTo(self.foucsButton);
        }];
    }
    return self;
}

- (QMUIButton *)foucsButton {
    if (!_foucsButton) {
        _foucsButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        _foucsButton.backgroundColor = UIColorGlobal;
        [_foucsButton setTitle:@"关注" forState:UIControlStateNormal];
        _foucsButton.layer.cornerRadius = 3;
        _foucsButton.titleLabel.font = UIFontMake(13);
        
    }
    return _foucsButton;
}

- (QMUIButton *)topButton {
    if (!_topButton) {
        _topButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_topButton setImage:[UIImage imageNamed:@"portrait_top"] forState:UIControlStateNormal];
        [_topButton setTitle:@"  31" forState:UIControlStateNormal];
        _topButton.titleLabel.font = UIFontMake(13);
        [_topButton setTitleColor:DEFAULT_SUBTITLE_COLOR forState:UIControlStateNormal];
            }
    return _topButton;
}

- (QMUIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setImage:[UIImage imageNamed:@"portrait_collect"] forState:UIControlStateNormal];
        [_likeButton setTitle:@"  28" forState:UIControlStateNormal];
        _likeButton.titleLabel.font = UIFontMake(13);
        [_likeButton setTitleColor:DEFAULT_SUBTITLE_COLOR forState:UIControlStateNormal];

    }
    return _likeButton;
}

- (QMUIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setImage:[UIImage imageNamed:@"portrait_message"] forState:UIControlStateNormal];

        [_commentButton setTitle:@"  21" forState:UIControlStateNormal];
        _commentButton.titleLabel.font = UIFontMake(13);
        [_commentButton setTitleColor:DEFAULT_SUBTITLE_COLOR forState:UIControlStateNormal];
    }
    return _commentButton;
}
@end


@interface YoPortraitPersonalCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, strong) BottomView *bottomView;
//@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) QMUILabel *numsLabel;
@property (nonatomic, strong) QMUILabel *contentLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIView *sepView;
@property (nonatomic, strong) UIScrollView *picScrollowImageView;
@property (nonatomic, strong) UIView *picContentView;
@end

@implementation YoPortraitPersonalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView);
            make.width.mas_equalTo(self.contentView);
            make.height.mas_equalTo(RatioZoom(80));
        }];
        [self.contentView addSubview:self.picContentView];
        [self.picContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(RatioZoom(15));
            make.right.mas_equalTo(-RatioZoom(15));
            make.height.mas_equalTo(RatioZoom(400));
            make.top.mas_equalTo(self.headerView.mas_bottom);
        }];
        [self.picContentView addSubview:self.picScrollowImageView];
        [self.picContentView addSubview:self.numsLabel];
        [self.numsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-RatioZoom(10));
            make.top.mas_equalTo(RatioZoom(10));
            make.width.mas_equalTo(RatioZoom(50));
            make.height.mas_equalTo(RatioZoom(25));
        }];
        [self.contentView addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.picScrollowImageView);
            make.right.mas_equalTo(self.picScrollowImageView);
            make.top.mas_equalTo(self.picScrollowImageView.mas_bottom);
            make.height.mas_equalTo(RatioZoom(55));
        }];
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bottomView);
            make.right.mas_equalTo(self.bottomView);
            make.top.mas_equalTo(self.bottomView.mas_bottom);
        }];
        
        [self.contentView addSubview:self.sepView];
        [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(RatioZoom(10));
        }];
        
        [self.contentView addSubview:self.moreButton];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentLabel);
            make.top.mas_equalTo(self.contentLabel.mas_bottom);
        }];
    }
    return self;
}


- (void)setUserInfo:(YoDataItem *)userInfo {
    _userInfo = userInfo;
    [self.headerView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:nil];
    self.headerView.nameLabel.text = userInfo.nickName;
}

- (void)setModel:(YoPortraitPersonalModel *)model {
    _model = model;
    self.headerView.detailsLabel.text = model.createTime;
    self.headerView.nameLabel.text = model.userName;
    [self.headerView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    self.headerView.hotLabel.text = [NSString stringWithFormat:@"当前热度 %zd",model.heatNum];
    self.contentLabel.text = model.content;
    self.numsLabel.text = [NSString stringWithFormat:@"1/%zd",model.pictures.count];
    if (model.isFocus) {
        [self.bottomView.foucsButton setTitle:@"取消" forState:UIControlStateNormal];
    }else {
        [self.bottomView.foucsButton setTitle:@"关注" forState:UIControlStateNormal];
    }
    [self.bottomView.topButton setTitle:[NSString stringWithFormat:@"  %zd",model.heatNum] forState:UIControlStateNormal];
    [self.bottomView.likeButton setTitle:[NSString stringWithFormat:@"  %d",model.countAlbumLike.intValue] forState:UIControlStateNormal];
    [self.bottomView.commentButton setTitle:[NSString stringWithFormat:@"  %d",model.countAlbumComment.intValue] forState:UIControlStateNormal];
    if (model.isMore && !model.isAlreadMore) {  // 需要展示，且没有展示
        // 出现更多按钮
        self.moreButton.hidden = NO;
        self.contentLabel.numberOfLines = 3;
    }else if (!model.isMore || model.isAlreadMore) {  // 不需要展示
        // 隐藏更多按钮
        self.moreButton.hidden = YES;
        self.contentLabel.numberOfLines = 0;
    }
    if (model.like) {
        [self.bottomView.likeButton setImage:[UIImage imageNamed:@"portrait_collect_select"] forState:UIControlStateNormal];
    }else{
        [self.bottomView.likeButton setImage:[UIImage imageNamed:@"portrait_collect"] forState:UIControlStateNormal];
    }
    
    
//   self.picScrollowImageView.frame = CGRectMake( 0, 80, SCREEN_WIDTH, picHeight);
    if (model.pictures && model.pictures.count > 0) {
        self.numsLabel.text = [NSString stringWithFormat:@"1/%zd",model.pictures.count];
    }
   [self  setPicImageViewForScrollow];
   
}

- (void)setPicImageViewForScrollow
{
    for (UIView *subView in self.picScrollowImageView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    CGFloat picHeight = 400;
    YoPortraitPersonalPictureModel  *photoTtemp = self.model.pictures.firstObject;
    if ( photoTtemp.width &&  photoTtemp.width > 0) {
         picHeight = (photoTtemp.height.floatValue * (SCREEN_WIDTH - 30)/ photoTtemp.width.floatValue);
    }
    self.picScrollowImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 30, picHeight);
    
    self.picScrollowImageView.contentSize = CGSizeMake(self.model.pictures.count * SCREEN_WIDTH - 30, 0);
    for (NSInteger i = 0; i < self.model.pictures.count; i ++) {
        YoPortraitPersonalPictureModel  *photo = self.model.pictures[i];
         UIImageView *image = [self creatImageView];
         [image sd_setImageWithURL:[NSURL URLWithString:photo.picture] placeholderImage:nil];
         CGFloat x = i > 0 ? (i *SCREEN_WIDTH - 15):0;
         image.frame = CGRectMake(x, 0, (SCREEN_WIDTH - 30), picHeight);
        [self.picScrollowImageView addSubview:image];
    }
//    [self.picScrollowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(picHeight);
//    }];
    self.numsLabel.frame = CGRectMake(SCREEN_WIDTH - 100, 30, 50, 25);
    [self.picScrollowImageView bringSubviewToFront:self.numsLabel];
}
- (void)focusButtonDidClicked {
    
    if (self.model.isFocus) {
        YoAlbumService *albumApi = [[YoAlbumService alloc] initWithAlbumId:self.model.albumId authorId:self.model.authorId sendType:YoAlbumTypeRelationCancel];
        [albumApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [QMUITips showSucceed:@"取消关注"];

        } failure:^(JSError *error) {
            [QMUITips showError:error.errorDescription];

        }];
        
    }else {
        YoAlbumService *albumApi = [[YoAlbumService alloc] initWithAlbumId:self.model.albumId authorId:self.model.authorId sendType:YoAlbumTypeRelation];
        [albumApi js_startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [QMUITips showSucceed:@"关注成功"];
            
        } failure:^(JSError *error) {
            [QMUITips showError:error.errorDescription];
            
        }];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / (SCREEN_WIDTH - 30) + 1;
    self.numsLabel.text = [NSString stringWithFormat:@"%ld/%zd",(long)index,self.model.pictures.count];
}
- (void)topButtonDidClicked {
    if (self.likeBlock) {
        self.likeBlock(_model);
    }
}

- (void)collectionDidClicked {
    if (self.collectBlock) {
        self.collectBlock(_model);
    }
}

- (void)commentDidClicked {
    if (self.commentBlock) {
        self.commentBlock(_model);
    }
}

- (void)moreButtonDidClicked {
    if (self.moreBlock) {
        _model.isAlreadMore = YES;
        self.moreBlock(_model);
    }
}

- (HeaderView *)headerView {
    if (!_headerView) {
        _headerView = [HeaderView new];
    }
    return _headerView;
}

- (BottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [BottomView new];
        [_bottomView.foucsButton addTarget:self action:@selector(focusButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.topButton addTarget:self action:@selector(topButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.likeButton addTarget:self action:@selector(collectionDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.commentButton addTarget:self action:@selector(commentDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
- (UIScrollView *)picScrollowImageView{
    if (!_picScrollowImageView) {
        _picScrollowImageView = [[UIScrollView alloc]init];
        _picScrollowImageView.pagingEnabled = YES;
        //   背景颜色的出现，本质是：滑动过界了，超过了scrollowView的contentsize所以才会出现背景色
        _picScrollowImageView.bounces = NO;
        _picScrollowImageView.backgroundColor = [UIColor whiteColor];
        _picScrollowImageView.showsVerticalScrollIndicator = NO;
        _picScrollowImageView.showsHorizontalScrollIndicator = NO;
        _picScrollowImageView.delegate = self;
    }
    return _picScrollowImageView;
}
- (UIImageView *)creatImageView {
    UIImageView *picImageView = [UIImageView new];
    picImageView.contentMode = UIViewContentModeScaleAspectFit;
    picImageView.clipsToBounds = YES;
    return picImageView;
}
- (UIView *)picContentView {
    if (!_picContentView) {
        _picContentView = [UIView new];
    }
    return _picContentView;
}
- (QMUILabel *)numsLabel {
    if (!_numsLabel) {
        _numsLabel = [QMUILabel new];
        _numsLabel.textAlignment = NSTextAlignmentCenter;
        _numsLabel.backgroundColor = [UIColor blackColor];
        _numsLabel.textColor = [UIColor whiteColor];
        _numsLabel.layer.cornerRadius = RatioZoom(25)*0.5;
        _numsLabel.clipsToBounds = YES;
        _numsLabel.font = UIFontMake(13);
    }
    return _numsLabel;
}

- (QMUILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [QMUILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = UIFontMake(16);
        _contentLabel.textColor = DEFAULT_CONTENT_COLOR;
        _contentLabel.text = @"约会专家告诉你如何同城约会,第一次约会需要注意:第一次约会聊什么?第一次约会穿什么?第一次约会选择什么地方?";
    }
    return _contentLabel;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        _moreButton.hidden = YES;
        [_moreButton addTarget:self action:@selector(moreButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UIView *)sepView {
    if (!_sepView) {
        _sepView = [UIView new];
        _sepView.backgroundColor = [UIColor qmui_colorWithHexString:@"#F2F2F2"];
    }
    return _sepView;
}


@end

