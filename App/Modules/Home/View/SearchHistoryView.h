//
//  SearchHistoryView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/9/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchHistoryViewDelegate <NSObject>

-(void)searchHistoryWithText:(NSString *)text;

@end
NS_ASSUME_NONNULL_BEGIN

@interface SearchHistoryView : UIView
@property (nonatomic, assign) id<SearchHistoryViewDelegate> delegate;
- (void)saveHistoryData:(NSString *)text;
-(void)reloadHistoryData;
@end

NS_ASSUME_NONNULL_END
