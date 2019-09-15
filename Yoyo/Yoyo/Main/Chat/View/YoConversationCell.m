//
//  YoConversationCell.m
//  Yoyo
//
//  Created by ning on 2019/5/27.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoConversationCell.h"

//#import "JSConversation.h"
//#import "JSMessage.h"

#import "Const.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "NSDate+Extension.h"
//#import "EaseConvertToCommonEmoticonsHelper.h"



@interface YoConversationCell()
@property(nonatomic, strong) UIImageView *portraitView;
@property(nonatomic, strong) QMUILabel *nameLabel;
@property(nonatomic, strong) QMUILabel *timeLabel;
@property(nonatomic, strong) QMUILabel *messageLabel;
@property(nonatomic, strong) UIImageView *dividerView;
@end

@implementation YoConversationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *CellIdentifier = nil;
    if (CellIdentifier == nil) {
        CellIdentifier = [NSString stringWithFormat:@"%@CellIdentifier", NSStringFromClass(self)];
    }
    id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        self.portraitView = [[UIImageView alloc] init];
        self.portraitView.frame = CGRectMake(0, 0, 60, 60);
        self.portraitView.layer.cornerRadius = 60 / 2;
        self.portraitView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.portraitView];
        
        
        self.nameLabel = [[QMUILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textColor = UIColorBlack;
        [self.contentView addSubview:self.nameLabel];
        
        
        self.nameLabel = [[QMUILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textColor = UIColorBlack;
        [self.contentView addSubview:self.nameLabel];
        
        
        self.timeLabel = [[QMUILabel alloc] init];
        self.timeLabel.font = [UIFont systemFontOfSize:13];
        self.timeLabel.textColor = UIColorGray5;
        [self.contentView addSubview:self.timeLabel];
        
        
        self.messageLabel = [[QMUILabel alloc] init];
        self.messageLabel.font = [UIFont systemFontOfSize:14];
        self.messageLabel.textColor = UIColorBlack;
        [self.contentView addSubview:self.messageLabel];

        
        self.dividerView = [[UIImageView alloc] init];
        self.dividerView.backgroundColor = UIColorSeparator;
        [self.contentView addSubview:self.dividerView];
        
    }
    
    return self;
    
}


//
//- (void)setModel:(id<IConversationModel>)model {
//    _model = model;
//
//    if (StringIsEmpty(model.avatarURLPath)) {
//        if (model.avatarImage) {
//            self.portraitView.image = model.avatarImage;
//        }
//    }else{
//        NSString *str = [NSString stringWithFormat:@"%@",model.avatarURLPath];
//        NSURL *url = [NSURL URLWithString:str];
//        [self.portraitView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"qiji_noHeaderPic"]];
//    }
//
//    _timeLabel.text = [NSDate dateFromLongLong:model.conversation.lastMessage.sendTime].dateDescription;
//
//    _nameLabel.text = model.title;
//
////    _badgeView.badgeValue = [NSString stringWithFormat:@"%d",[model.conversation unreadMessagesCount]];
//
//    switch (model.conversation.type) {
//        case JSConversationTypeChat:
//        case JSConversationTypeTempChat:
//        {
//            JSMessage *lastMess = model.conversation.lastMessage;
//            JSMessageBody *messageBody = lastMess.messageBody;
//            switch (messageBody.type) {
//                case JSMessageBodyTypeText:{
//                    JSTextMessageBody *tet = (JSTextMessageBody *)messageBody;
//                    NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:tet.text];
//                    _messageLabel.text = didReceiveText;
//                }
//                    break;
//                case JSMessageBodyTypeImage:
//                    _messageLabel.text = @"[图片]";
//                    break;
//                case JSMessageBodyTypeVideo:
//                    _messageLabel.text = @"[视频]";
//                    break;
//                case JSMessageBodyTypeLocation:
//                    _messageLabel.text = @"[位置]";
//                    break;
//                case JSMessageBodyTypeCard:
//                    _messageLabel.text = @"[名片]";
//                    break;
//                default:
//                    break;
//            }
//
//        }
//            break;
//        case JSConversationTypeGroupChat:
//
//            break;
//        case JSConversationTypeFriendApply:
//        {
//
//            JSMessage *lastMess = model.conversation.lastMessage;
//            JSMessageBody *messageBody = lastMess.messageBody;
//            JSTextMessageBody *tet = (JSTextMessageBody *)messageBody;
//            NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:tet.text];
//            _messageLabel.text = didReceiveText;
//
//        }
//            break;
//        case JSConversationTypeCircleApply:
//
//            break;
//
//        default:
//            break;
//    }
//
//
//}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.portraitView).offset(4);
        make.left.equalTo(self.portraitView.mas_right).offset(10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.portraitView).offset(4);
        make.right.equalTo(self.contentView).offset(-8);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.portraitView).offset(-4);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView);
    }];
    
    
    [self.dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(PixelOne);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(PixelOne);
        make.right.left.equalTo(self.contentView);
    }];
    
    
}
@end
