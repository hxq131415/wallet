//
//  TEReqCodeMarcos.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/3.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  Request Code

import Foundation

// BASE URL
// 正式环境
#if DEBUG
public let MR_Release_BASE_URL = "https://mavrodi.pro/"
#else
public let MR_Release_BASE_URL = "https://mavrodi.pro/"
//public let MR_Release_BASE_URL = "http://13.228.151.13/"
#endif
// 测试环境
//public let MR_Test_BASE_URL = "http://api-test.mavrodi.pro/"
public let MR_Test_BASE_URL = "http://13.228.151.13/"
//app更新下载链接
public let MR_DownloadApp_BASE_URL = "itms-services://?action=download-manifest&url=https://mavrodi.pro/app/ios/manifest.plist"

// REQ CODE

// App配置
public let MR_REQ_CODE_INDEX_GET_CONFIGS = "Index/getConfigInfo"

// MARK: - 登录\注册
// 注册
public let MR_REQ_CODE_USER_REGISTER  = "reg/doRegister"
// 登录
public let MR_REQ_CODE_USER_LOGIN  = "login/doLogin"
// 发送验证码
public let MR_REQ_CODE_SEND_VERIFYCODE = "Reg/sendVerifyCode"
// 重置密码
public let MR_REQ_CODE_RETRIEVE_PASSWORD = "login/retrievePassword"
// 设置支付密码
public let MR_REQ_CODE_SET_PAYMENT_PASSWORD = "User/setPayPassword"

// MARK: - 个人中心
// 获取个人信息
public let MR_REQ_CODE_USER_USERDATA  = "user/getUserData"
// 获取（邀请奖励，管理奖励）信息 弃用
public let MR_REQ_CODE_GET_REWARD_INFO = "Money/getRewardInfo"
// 获取邀请奖励信息
public let MR_REQ_CODE_GET_INVITATION_REWARD_INFO = "user/invitationDetail"
// 获取管理奖励信息
public let MR_REQ_CODE_GET_MANAGEMENT_REWARD_INFO = "user/managementDetail"
//获取某日奖金收益总额和账户变动记录
public let MR_REQ_CODE_GET_BONUSRECORD_BYDAY_REWARD_INFO = "Pd/getBonusRecordByDay"

// 修改昵称，个人名言
public let MR_REQ_CODE_USER_UPDATE_USER_INFO = "User/updateUserInfo"
// 修改头像
public let MR_REQ_CODE_USER_MODIFY_AVATAR = "User/modifyAvatar"

// MARK: - 资金池
// 获取投资收益信息
public let MR_REQ_CODE_PLAN_GET_PROFIT_INFO = "money/getProfitInfo"
// 获取参与记录
public let MR_REQ_CODE_PLAN_GET_JOIN_LIhST = "Pd/getArrivalLog"
// 获取参与详情
public let MR_REQ_CODE_PLAN_GET_JOIN_LIhSTDETAIL = "Pd/getArrivalDetail"
// 获取收获记录
public let MR_REQ_CODE_PLAN_GET_HEARVEST_LIST = "Pd/getAppearanceLog"
// 获取收获详情
public let MR_REQ_CODE_PLAN_GET_HEARVEST_LISTDETAI = "Pd/getAppearanceDetail"
// 参与
public let MR_REQ_CODE_PLAN_TO_JOIN = "pd/arrival"
// 获取解冻需要消耗金额
public let MR_REQ_CODE_PLAN_GET_UNFREEZE_AMOUNT = "pd/getUnfreezeAmount"
//解冻参与排单
public let MR_REQ_CODE_PLAN_UNFREEZE_TO_JOIN = "pd/arrivalForFrozenBonus"
// 确认收获(出场)
public let MR_REQ_CODE_PLAN_TO_HEARVEST = "pd/appearance"
// 转款提交
public let MR_REQ_CODE_PLAN_CONFIRM_TRANSFER = "Pd/confirmTransfer"
// 确认收获(进场)
public let MR_REQ_CODE_PLAN_CONFIRM_HARVEST = "Pd/confirmHarvest"
// 确认收款
public let MR_REQ_CODE_PLAN_CONFIRM_RECEIPT = "Pd/confirmReceipt"
// 获取收获金额
public let MR_REQ_CODE_PLAN_GET_HARVEST_AMOUNT = "Pd/getHarvestAmount"
// 获取冻结收获金额
public let MR_REQ_CODE_PLAN_GET_FROZEN_BONUSES = "Pd/getFrozenBonus"
// 检查是否允许收获领导奖金信息
public let MR_REQ_CODE_PLAN_GET_LEADER_BONUSES_STATUS = "Pd/getLeaderBonusStatus"
// 获取每日入场限额和当日平台入场资金总额
public let MR_REQ_CODE_PLAN_GET_ARRIVAL_AMOUNT_TODAY = "Pd/getArrivalAmountToday"
// 获取排单池金额
public let MR_REQ_CODE_PLAN_GET_ROWPOOL_AMOUNT = "money/rowPool"
// 获取资金池金额
public let MR_REQ_CODE_PLAN_GET_CAPITALPOOL_AMOUNT = "money/capitalPool"
// 获取奖金池金额
public let MR_REQ_CODE_PLAN_GET_REWARDRECORD_AMOUNT = "money/getRewardRecord"
// 获取奖金池总额
public let MR_REQ_CODE_PLAN_GET_REWARDRECORDFOALL_AMOUNT = "money/getRewardInfoAll"

// MARK: - 重启
// 获取个人重启信息
public let MR_REQ_CODE_PLAN_GET_RESETINFO = "reset/exchangeInfo"
// 发起个人重启
public let MR_REQ_CODE_PLAN_POST_RESET = "reset/exchange"
// 清空重启记录
public let MR_REQ_CODE_PLAN_POST_CLEARRESET = "reset/clear"

//获取抢单状态
public let MR_REQ_CODE_PLAN_GET_GRAPSTATUS = "grap/status"
//抢单
public let MR_REQ_CODE_PLAN_GET_GRAPJOIN = "grap/join"


// MARK: - 钱包
// 获取钱包列表
public let MR_REQ_CODE_WALLET_GET_LIST = "wallet/getList"
// 创建钱包
public let MR_REQ_CODE_WALLET_CREATE = "wallet/create"
// 转账记录
public let MR_REQ_CODE_WALLET_TRANSFER_RECORDLIST = "wallet/transferRecord"

// 根据私钥导入钱包
public let MR_REQ_CODE_WALLET_IMPORT_BY_PRIVATEKEY = "wallet/importWalletByPrivateKey"
// 删除钱包
public let MR_REQ_CODE_WALLET_DELETE = "wallet/delWallet"
// 钱包转账
public let MR_REQ_CODE_WALLET_TRANSFER = "wallet/transferFrom"

// 修改钱包密码
public let MR_REQ_CODE_WALLET_MODIFY_PASSWORD = "wallet/modifyWalletPassword"
// 导出钱包私钥
public let MR_REQ_CODE_WALLET_EXPORT_PRIVATEKEY = "wallet/exportWalletPrivateKey"
// 导出钱包公钥
public let MR_REQ_CODE_WALLET_EXPORT_PUBLICKEY = "wallet/exportWalletPublicKey"

// 获取公告列表
public let MR_REQ_CODE_NOTICE_ANNOUNCEMENT_LIST  = "Notice/announcementList"
// 获取公告详情
public let MR_REQ_CODE_NOTICE_ANNOUNCEMENT_DETAIL  = "Notice/announcementDetail"

//解冻账号接口
public let MR_REQ_CODE_PLAN_UNFREEZE_Account = "unlock/pay"

//解冻所消耗的Mcoin
public let MR_REQ_CODE_PLAN_Need_Mcoin = "/unlock/needMcoin"


