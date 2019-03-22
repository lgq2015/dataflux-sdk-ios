//
//  PWChatMessage.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWChatMessage.h"

@implementation PWChatMessage
//文本消息
-(void)setTextString:(NSString *)textString{
    _textString = textString;
//    self.attTextString = [[SSChartEmotionImages ShareSSChartEmotionImages]emotionImgsWithString:textString];
}

//可变文本消息
-(void)setAttTextString:(NSMutableAttributedString *)attTextString{
    
    NSMutableParagraphStyle *paragraphString = [[NSMutableParagraphStyle alloc] init];
    [paragraphString setLineSpacing:PWChatTextLineSpacing];
    
    [attTextString addAttribute:NSParagraphStyleAttributeName value:paragraphString range:NSMakeRange(0, attTextString.length)];
    [attTextString addAttribute:NSFontAttributeName value:MediumFONT(PWChatTextFont) range:NSMakeRange(0, attTextString.length)];
    [attTextString addAttribute:NSForegroundColorAttributeName value:PWChatTextColor range:NSMakeRange(0, attTextString.length)];
    _attTextString = attTextString;
    
}

@end
