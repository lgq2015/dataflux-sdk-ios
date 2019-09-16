//
//  SearchBarView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/9/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchBarViewDelegate <NSObject>

-(void)cancleBtnClick;
-(void)searchWithText:(NSString *)text;
@optional
-(void)synchronousSearchText:(NSString *)text;
-(void)textFiledClear;
@end
NS_ASSUME_NONNULL_BEGIN

@interface SearchBarView : UIView
@property (nonatomic, assign) id<SearchBarViewDelegate> delegate;
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, assign) BOOL isSynchronous;//是否同步
@property (nonatomic, assign) BOOL isClear;//是否为空
@end

NS_ASSUME_NONNULL_END
