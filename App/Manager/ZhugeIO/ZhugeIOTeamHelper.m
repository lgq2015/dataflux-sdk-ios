//
// Created by Brandon on 2019-06-03.
// Copyright (c) 2019 hll. All rights reserved.
//

#import "ZhugeIOTeamHelper.h"


@implementation ZhugeIOTeamHelper {

}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.category = @"团队";
    }
    return self;
}

- (ZhugeIOTeamHelper *)eventBottomTab {
    [self event:@"点击底部Tab"];
    return self;
}

- (ZhugeIOTeamHelper *)eventCreateTeamStay {
    [self event:@"创建团队页面停留时长"];
    return self;
}

- (ZhugeIOTeamHelper *)eventClickInvite {
    [self event:@"点击邀请成员"];
    return self;
}


- (ZhugeIOTeamHelper *)eventConfigIssue {
    [self event:@"配置云服务"];
    return self;
}


- (ZhugeIOTeamHelper *)eventClickServiceLog {
    [self event:@"点击服务记录"];
    return self;
}

- (ZhugeIOTeamHelper *)eventClickTeamManager {
    [self event:@"团队管理"];
    return self;

}

- (ZhugeIOTeamHelper *)eventLookMember {
    [self event:@"查看团队成员"];
    return self;

}

- (ZhugeIOTeamHelper *)eventCallMember {
    [self event:@"拨打成员电话"];
    return self;

}

- (ZhugeIOTeamHelper *)eventJoinScan {
    [self event:@"选择扫码加入"];
    return self;

}

- (ZhugeIOTeamHelper *)eventInviteEmail {
    [self event:@"选择邮箱邀请"];
    return self;

}

- (ZhugeIOTeamHelper *)eventInvitePhone {
    [self event:@"选择手机号邀请"];
    return self;

}

- (ZhugeIOTeamHelper *)eventSaveQRCode {
    [self event:@"保存二维码到相册"];
    return self;

}

- (ZhugeIOTeamHelper *)eventSureEmailInvite {
    [self event:@"确认邮箱邀请"];
    return self;
}

- (ZhugeIOTeamHelper *)eventSurePhoneInvite {
    [self event:@"确认手机号邀请"];
    return self;

}


- (ZhugeIOTeamHelper *)eventLookServiceLog {
    [self event:@"查看服务日志"];
    return self;

}

- (ZhugeIOTeamHelper *)eventTransferManager {
    [self event:@"转移管理员"];
    return self;

}

- (ZhugeIOTeamHelper *)eventTransferManagerSuccess {
    [self event:@"转移管理员成功"];
    return self;

}

- (ZhugeIOTeamHelper *)eventCancelTeam {
    [self event:@"注销团队"];
    return self;

}

- (ZhugeIOTeamHelper *)eventSignOutTeam {
    [self event:@"退出团队"];
    return self;

}

- (ZhugeIOTeamHelper *)attrTabName {
    self.data[@"目标位置"] = @"团队";
    return self;

}

- (ZhugeIOTeamHelper *)attrStayTime {
    self.data[@"时长"] = @"秒";
    return self;

}

- (ZhugeIOTeamHelper *)attrFrom {
    self.data[@"入口"] = @"团队";
    return self;

}

- (ZhugeIOTeamHelper *)attrResultSuccess {
    [self result:@"成功"];
    return self;
}

- (ZhugeIOTeamHelper *)attrResultCancel {
    [self result:@"取消"];
    return self;
}


@end