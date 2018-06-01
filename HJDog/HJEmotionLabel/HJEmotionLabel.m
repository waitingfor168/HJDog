//
//  HJEmotionLabel.m
//  HJDog
//
//  Created by whj on 2017/11/29.
//  Copyright © 2017年 whj. All rights reserved.
//

#import "HJEmotionLabel.h"

@implementation HJContextResult
@end

@interface HJEmotionLabel ()

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) CGSize imageSize;

@end

@implementation HJEmotionLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self p_initAttribute];
    }
    return self;
}

- (void)p_initAttribute
{
    self.textFont = [UIFont systemFontOfSize:15.0];
    self.imageSize = CGSizeMake(_textFont.lineHeight, _textFont.lineHeight);
}

#pragma mark - 配置属性
- (void)configAttribute:(NSString *)text
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray<HJContextResult *> *emotionResults = [[self class] regexEmotion:text];
    NSMutableAttributedString *stringM = [[NSMutableAttributedString alloc]init];
    
    //遍历结果集
    [emotionResults enumerateObjectsUsingBlock:^(HJContextResult * _Nonnull result, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //表情
        if (result.isEmotion) {
            
            //图片富文本
            NSTextAttachment *attachmeent         = [[NSTextAttachment alloc]init];
            UIImage *emotionImage                 = [UIImage imageNamed:result.string];
            
             //有对应表情
            if (emotionImage) {
                
                attachmeent.image                 = emotionImage;
                attachmeent.bounds  = CGRectMake(0, -3, _imageSize.width, _imageSize.height);
                NSAttributedString *imageString   = [NSAttributedString attributedStringWithAttachment:attachmeent];
                [stringM appendAttributedString:imageString];
            }else{
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:result.string];
                [weakSelf normalTextAttribute:string];
                [stringM appendAttributedString:string];
            }
        } else { //非表情
            
            //设置文本属性
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:result.string];
            //普通文本属性
            [weakSelf normalTextAttribute:string];
            
            [stringM appendAttributedString:string];
        }
    }];
}


#pragma mark - 匹配表情
+ (NSMutableArray<HJContextResult *> *)regexEmotion:(NSString *)text {
    
    NSMutableArray<HJContextResult *> *emotionResults = [NSMutableArray array];
    
    // 正则匹配表情
    NSError *error = nil;
    NSString *emotionRegex = @"\\[[^\\[\\]]*\\]";
    NSRegularExpression *emotionExpression = [NSRegularExpression regularExpressionWithPattern:emotionRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    [emotionExpression enumerateMatchesInString:text options:NSMatchingReportCompletion range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        if (result.range.length) {
            
            HJContextResult *result = [[HJContextResult alloc]init];
            result.isEmotion            = YES;
            result.range                = result.range;
            [emotionResults addObject:result];
        }
    }];
    
    return emotionResults;
}

- (void)normalTextAttribute:(NSMutableAttributedString *)attributeStr
{
    [attributeStr addAttribute:NSFontAttributeName value:_textFont range:NSMakeRange(0, attributeStr.length)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, attributeStr.length)];
    NSMutableParagraphStyle *paragra = [[NSMutableParagraphStyle alloc]init];
    [paragra setLineBreakMode:NSLineBreakByWordWrapping];
//    [paragra setLineSpacing:_lineSpacing];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragra range:NSMakeRange(0, attributeStr.length)];
//    [attributeStr addAttribute:NSKernAttributeName value:@(_wordSpacing) range:NSMakeRange(0, attributeStr.length)];
}

@end
