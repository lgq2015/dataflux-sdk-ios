//
//  CreateQuestionModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"
typedef NS_ENUM(NSInteger, UploadType){
    UploadTypeNotStarted,
    UploadTypeSuccess,
    UploadTypeError,
};
NS_ASSUME_NONNULL_BEGIN

@interface CreateQuestionModel : JSONModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *fileID;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSString *fileIcon;
@property (nonatomic, assign) UploadType type;
@end

NS_ASSUME_NONNULL_END
