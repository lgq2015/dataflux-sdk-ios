//
//  IssueSourceConfige.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/26.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueSourceConfige.h"
@interface IssueSourceConfige()
@end
@implementation IssueSourceConfige
-(instancetype)initWithType:(SourceType)type{
    if (self = [super init]) {
        [self setSourceWithType:type];
    }
    return self;
}
- (void)setSourceWithType:(SourceType)type{
    switch (type) {
        case SourceTypeAli:
            self.subTip = @"    您当前为免费版本，支持针对 ECS、块存储、OSS、RDS、SLB、VPC、云监控这几类资源进行相关的诊断";
            self.topTip = @"通过授予王教授只读权限，让王教授连接您的云账号，您就可以及时地得到关于阿里云的诊断情报，发现可能存在的问题并获取专家建议。";
            self.vcTitle = @"连接阿里云";
            self.vcProvider =@"aliyun";
            self.yunTitle = @"阿里云 RAM ";
            [self createTFArrayWithAliyun];
            break;
        case SourceTypeAWS:
            self.subTip = @"    您当前为免费版本，支持针对 EC2、VPC、EBS、ELB、RDS、S3 这几类资源进行相关的诊断。";
            self.topTip = @"通过授予王教授只读权限，让王教授连接您的云账号，您就可以及时地得到关于 AWS 云的诊断情报，发现可能存在的问题并获取专家建议。";
            self.vcTitle = @"连接AWS";
            self.vcProvider =@"aws";
            self.yunTitle = @" AWS IAM ";
            [self createTFArrayWithAWS];
            break;
        case SourceTypeTencent:
            self.subTip = @"    您当前为免费版本，支持针对 CVM、CBS、TencentDB（MySQL / SQLServer）、CLB、VPC 这几类资源进行相关的诊断。";
            self.topTip = @"通过授予王教授只读权限，让王教授连接您的云账号，您就可以及时地得到关于腾讯云的诊断情报，发现可能存在的问题并获取专家建议。";
            self.vcTitle = @"连接腾讯云";
            self.vcProvider =@"qcloud";
            self.yunTitle = @"腾讯云 CAM ";
            [self createTFArrayWithTencent];
            break;
        case SourceTypeUcloud:
            self.subTip =  @"    您当前为免费版本，支持针对 UHost、UDisk、UNet、UDB、UFile、CLB、UVPC 这几类资源进行相关的诊断。";
            self.topTip = @"通过授予王教授只读权限，让王教授连接您的云账号，您就可以及时地得到关于 UCloud 的诊断情报，发现可能存在的问题并获取专家建议。";
            self.vcTitle =@"连接 UCloud";
            self.vcProvider = @"ucloud";
            self.yunTitle  =@"UCloud UAM ";
            [self createTFArrayWithUcloud];
            break;
        case SourceTypeSingleDiagnose:
            self.vcTitle = @"主机诊断";
            self.vcProvider =@"carrier.corsair";
            [self createTFArrayWithSingleDiagnose];
            break;
        case SourceTypeClusterDiagnose:
            self.vcTitle = @"先知监控";
            self.vcProvider =@"carrier.corsairmaster";
            [self createTFArrayWithClusterDiagnose];
            break;
        case SourceTypeDomainNameDiagnose:
            self.topTip = @"配置您要诊断的一级域名，及时获取关于域名相关的诊断情报。包括了域名到期时间、SSL证书配置等。";
            self.vcTitle = @"域名诊断";
            self.vcProvider =@"domain";
            [self createDomainNameTf];
            break;
    }
    self.deletAlert = @"删除情报源将会同时删除关于该情报源的所有情报记录以及相关的服务记录，请您谨慎操作";
    self.helpUrl = PW_ISSUE_HELP(self.vcProvider);
}
- (void)createTFArrayWithAliyun{
    IssueTf *tf =[IssueTf new];
    tf.tfTitle = @"情报源名称";
    tf.placeHolder = @"请输入情报源名称";
    tf.text = @"";
    tf.enable = YES;
    IssueTf *tf2 =[IssueTf new];
    tf2.tfTitle = @"Access Key ID";
    tf2.placeHolder = @"请输入 RAM 的  Access Key ID";
    tf2.text = @"";
    tf2.enable = YES;
    IssueTf *tf3 = [IssueTf new];
    tf3.tfTitle = @"Access Key Secret";
    tf3.placeHolder = @"请输入 RAM 的  Access Key Secret";
    tf3.text = @"";
    tf3.enable = YES;
    tf3.secureTextEntry = YES;
    self.issueTfArray = [NSMutableArray arrayWithArray:@[tf,tf2,tf3]];
}
- (void)createDomainNameTf{
     IssueTf *tf =[IssueTf new];
     tf.tfTitle = @"域名诊断";
     tf.placeHolder = @"请输入需要诊断的一级域名";
     tf.text = @"";
     tf.enable = YES;
    self.issueTfArray = [NSMutableArray arrayWithArray:@[tf]];
}
- (void)createTFArrayWithAWS{
    IssueTf *tf =[IssueTf new];
    tf.tfTitle = @"情报源名称";
    tf.placeHolder = @"请输入情报源名称";
    tf.text = @"";
    tf.enable = YES;
    IssueTf *tf2 =[IssueTf new];
    tf2.tfTitle = @"Access Key ID";
    tf2.placeHolder = @"请输入 IAM 的  Access Key ID";
    tf2.text = @"";
    tf2.enable = YES;
    IssueTf *tf3 = [IssueTf new];
    tf3.tfTitle = @"Access Key Secret";
    tf3.placeHolder = @"请输入 IAM 的  Access Key Secret";
    tf3.text = @"";
    tf3.enable = YES;
    tf3.secureTextEntry = YES;
    self.issueTfArray = [NSMutableArray arrayWithArray:@[tf,tf2,tf3]];
}
- (void)createTFArrayWithTencent{
    IssueTf *tf =[IssueTf new];
    tf.tfTitle = @"情报源名称";
    tf.placeHolder = @"请输入情报源名称";
    tf.text = @"";
    tf.enable = YES;
    IssueTf *tf2 =[IssueTf new];
    tf2.tfTitle = @"SecretId";
    tf2.placeHolder = @"请输入 CAM 的  SecretId";
    tf2.text = @"";
    tf2.enable = YES;
    IssueTf *tf3 = [IssueTf new];
    tf3.tfTitle = @"SecretKey";
    tf3.placeHolder = @"请输入 CAM 的  SecretKey";
    tf3.text = @"";
    tf3.enable = YES;
    tf3.secureTextEntry = YES;
    self.issueTfArray = [NSMutableArray arrayWithArray:@[tf,tf2,tf3]];
}
- (void)createTFArrayWithUcloud{
    IssueTf *tf =[IssueTf new];
    tf.tfTitle = @"情报源名称";
    tf.placeHolder = @"请输入情报源名称";
    tf.text = @"";
    tf.enable = YES;
    IssueTf *tf2 =[IssueTf new];
    tf2.tfTitle = @"Public Key";
    tf2.placeHolder = @"请输入 UAM 的  Public Key";
    tf2.text = @"";
    tf2.enable = YES;
    IssueTf *tf3 = [IssueTf new];
    tf3.tfTitle = @"Private Key";
    tf3.placeHolder = @"请输入 UAM 的  Private Key";
    tf3.text = @"";
    tf3.enable = YES;
    tf3.secureTextEntry = YES;
    self.issueTfArray = [NSMutableArray arrayWithArray:@[tf,tf2,tf3]];
}
- (void)createTFArrayWithClusterDiagnose{
    IssueTf *tf =[IssueTf new];
    tf.tfTitle = @"情报源名称";
    tf.placeHolder = @"请输入情报源名称";
    tf.text = @"";
    tf.enable = YES;
    IssueTf *tf2 =[IssueTf new];
    tf2.tfTitle = @"Cluster ID";
    tf2.placeHolder = @"";
    tf2.text = @"";
    tf2.enable = NO;
    IssueTf *tf3 = [IssueTf new];
    tf3.tfTitle = @"Cluster Hostname";
    tf3.placeHolder = @"";
    tf3.text = @"";
    tf3.enable = NO;
    IssueTf *tf4 = [IssueTf new];
    tf4.tfTitle = @"Cluste IP";
    tf4.placeHolder = @"";
    tf4.text = @"";
    tf4.enable = NO;
    self.issueTfArray = [NSMutableArray arrayWithArray:@[tf,tf2,tf3,tf4]];
}
- (void)createTFArrayWithSingleDiagnose{
    IssueTf *tf =[IssueTf new];
    tf.tfTitle = @"情报源名称";
    tf.placeHolder = @"请输入情报源名称";
    tf.text = @"";
    tf.enable = YES;
    IssueTf *tf2 =[IssueTf new];
    tf2.tfTitle = @"ID";
    tf2.placeHolder = @"";
    tf2.text = @"";
    tf2.enable = NO;
    IssueTf *tf3 = [IssueTf new];
    tf3.tfTitle = @"Hostname";
    tf3.placeHolder = @"";
    tf3.text = @"";
    tf3.enable = NO;
    IssueTf *tf4 = [IssueTf new];
    tf4.tfTitle = @"Host IP";
    tf4.placeHolder = @"";
    tf4.text = @"";
    tf4.enable = NO;
    self.issueTfArray = [NSMutableArray arrayWithArray:@[tf,tf2,tf3,tf4]];
}
@end
