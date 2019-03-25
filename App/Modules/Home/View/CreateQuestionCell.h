//
//  CreateSourceCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CreateQuestionModel;
@interface CreateQuestionCell : UITableViewCell
@property (nonatomic, strong) CreateQuestionModel *model;
@property (nonatomic, assign) NSIndexPath *index;
@property (nonatomic, copy) void(^reUpload)(NSIndexPath* index);
@property (nonatomic, copy) void(^removeFile)(NSIndexPath* index);

@property (nonatomic, strong) NSDictionary *data;
-(void)setTitleWithProgress:(float)progress;
-(void)completeUpload;
-(void)uploadError;
@end

NS_ASSUME_NONNULL_END
