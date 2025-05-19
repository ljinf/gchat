DROP TABLE IF EXISTS `bs_register`;
CREATE TABLE `bs_register`
(
    `id`           bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `user_id`      bigint(20) NOT NULL COMMENT '用户唯一标识ID',
    `account_type` int(11) NOT NULL COMMENT '账号类型，1:手机号，2:wechat',
    `account`      varchar(64) NOT NULL COMMENT '注册账号:手机号/微信openid',
    `status`       INT(11) DEFAULT 1 COMMENT '禁用状态 1:正常, 2:注销 ,3:禁用',
    `created_at`   datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY            user_account_third_idx(`account_type`,`account`,`status`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COMMENT='用户注册信息表';

DROP TABLE IF EXISTS `bs_users`;
CREATE TABLE `bs_users`
(
    `id`         bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `user_id`    bigint(20) NOT NULL COMMENT '用户唯一标识ID',
    `username`   VARCHAR(64) NULL DEFAULT '' COMMENT '名称',
    `avatar`     VARCHAR(128) NULL DEFAULT '' COMMENT '头像',
    `slogan`     VARCHAR(128) NULL DEFAULT '' COMMENT '个性签名',
    `background` VARCHAR(128) NULL DEFAULT '' COMMENT '个人背景图',
    `gender`     int(11) NULL COMMENT '性别 1-男 2-女 3-未知',
    `vip_expire` int(11) NULL COMMENT 'vip期限，时间戳（秒）,-1永久',
    `status`     INT(11) DEFAULT 1 COMMENT '禁用状态 1:正常，2:禁用',
    `is_del`     INT(11) DEFAULT 1 COMMENT '删除状态 1:正常，2:注销',
    `created_at` INT(11) DEFAULT NULL COMMENT '创建时间',
    `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY user_idx(`user_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';

DROP TABLE IF EXISTS `bs_user_addition`;
CREATE TABLE `bs_user_addition`
(
    `id`                   bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `user_id`              bigint(20) NOT NULL COMMENT '用户唯一标识ID',
    `invite_code`          VARCHAR(16) NULL DEFAULT '' COMMENT '邀请码',
    `channel`              VARCHAR(32) NULL DEFAULT '' COMMENT '渠道',
    `register_app_version` VARCHAR(64) NULL DEFAULT '' COMMENT 'app版本号',
    `oaid`                 VARCHAR(128) NULL DEFAULT '' COMMENT 'oaid',
    `created_at`           datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY user_idx(`user_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COMMENT='用户附加信息';


-- 社交模块

-- 聊天

DROP TABLE IF EXISTS `bs_conversation_members`;
CREATE TABLE `bs_conversation_members`
(
    `id`                   bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `conversation_id`      bigint(20) NOT NULL COMMENT '会话ID',
    `conversation_version` int(11) NOT NULL COMMENT '会话版本，该成员的会话版本便于增量更新',
    `member_id`            bigint(20) NOT NULL COMMENT '成员ID',
    `role`                 tinyint(2) NOT NULL DEFAULT 1 COMMENT '成员角色 1-普通成员 2-管理员  100-群主',
    `mute`                 tinyint(2) NOT NULL DEFAULT 1 COMMENT '禁言状态 1-否 2-是',
    `mute_expire`          bigint(20) NULL DEFAULT 0 COMMENT '禁言截止时间戳',
    `created_at`           datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`           datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY                    conversation_idx(`conversation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会话（群）成员列表';

DROP TABLE IF EXISTS `conversation_list`;
CREATE TABLE `conversation_list`
(
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `conversation_id` varchar(64) NOT NULL COMMENT '会话ID',
    `type`            int(11) NOT NULL DEFAULT '0' COMMENT '会话类型枚举，0单聊 1群聊',
    `member`          int(11) NOT NULL DEFAULT '0' COMMENT '与会话相关的用户数量',
    `avatar`          varchar(256) DEFAULT '' COMMENT '群组头像',
    `announcement`    text COMMENT '群公告',
    `recent_msg_time` bigint(20) NOT NULL DEFAULT 0 COMMENT '此会话最新产生消息的时间',
    `created_at`      int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`),
    KEY               conversation_idx(`conversation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会话表';

DROP TABLE IF EXISTS `user_conversation_list`;
CREATE TABLE `user_conversation_list`
(
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `user_id`         bigint(20) unsigned NOT NULL COMMENT '用户ID',
    `conversation_id` varchar(64) NOT NULL COMMENT '会话ID',
    `last_read_seq`   bigint(20) unsigned DEFAULT 0 COMMENT '此会话用户已读的最后一条消息序列号',
    `notify_type`     int(11) DEFAULT 0 COMMENT '会话收到消息的提醒类型，0未屏蔽，正常提醒 1屏蔽 2强提醒',
    `is_top`          tinyint(2) DEFAULT 0 COMMENT '会话是否被置顶展示 0否 1是',
    `created_at`      datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`      datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `user_conversation_idx` (`user_id`,`conversation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户会话链';

DROP TABLE IF EXISTS `user_msg_list`;
CREATE TABLE `user_msg_list`
(
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `user_id`         bigint(20) unsigned NOT NULL COMMENT '用户ID',
    `msg_id`          bigint(20) unsigned NOT NULL COMMENT '消息ID',
    `conversation_id` varchar(64) NOT NULL COMMENT '会话ID',
    `seq`             bigint(20) unsigned DEFAULT 0 COMMENT '消息在会话中的序列号，用于保证消息的顺序',
    datetime                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY               `user_conversation_seq_msg_idx` (`user_id`,`conversation_id`,`seq`,`msg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户消息链';

DROP TABLE IF EXISTS `msg_list`;
CREATE TABLE `msg_list`
(
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `user_id`         bigint(20) unsigned NOT NULL COMMENT '发送者ID',
    `msg_id`          bigint(20) unsigned NOT NULL COMMENT '消息ID',
    `conversation_id` varchar(64) NOT NULL COMMENT '会话ID',
    `content`         text        NOT NULL COMMENT '消息文本',
    `content_type`    int(8) NOT NULL DEFAULT '1' COMMENT '内容类型  1文本  2图片 3音频文件  4音频文件  5实时语音  6实时视频',
    `status`          int(11) NOT NULL DEFAULT '0' COMMENT '消息状态枚举，0可见 1屏蔽 2撤回',
    `sent_at`         bigint(20) NOT NULL DEFAULT '0' COMMENT '发送时间',
    `created_at`      datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`      datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY               `msg_idx` (`msg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息表';

DROP TABLE IF EXISTS `conversation_msg_list`;
CREATE TABLE `conversation_msg_list`
(
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `conversation_id` varchar(64) NOT NULL COMMENT '会话ID',
    `msg_id`          bigint(20) unsigned NOT NULL COMMENT '消息ID',
    `seq`             bigint(20) unsigned DEFAULT 0 COMMENT '消息在会话中的序列号，用于保证消息的顺序',
    `created_at`      datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY               conversation_seq_msg_idx(`conversation_id`,`seq`,`msg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会话消息链';


DROP TABLE IF EXISTS `bs_user_msg_ack`;
CREATE TABLE `bs_user_msg_ack`
(
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `user_id`         bigint(20) unsigned NOT NULL COMMENT '用户ID',
    `conversation_id` bigint(20) unsigned NOT NULL COMMENT '会话ID',
    `ack_seq`         bigint(20) unsigned DEFAULT 0 COMMENT '已确认的消息序列号',
    PRIMARY KEY (`id`),
    UNIQUE KEY user_con_idx(`user_id`,`conversation_id`),
    KEY               user_con_ack_idx(`user_id`,`conversation_id`,`ack_seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户消息确认记录';


DROP TABLE IF EXISTS `bs_friend_apply_history`;
CREATE TABLE `bs_friend_apply_history`
(
    `id`         bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `from_id`    bigint(20) unsigned NOT NULL COMMENT '发起人ID',
    `to_id`      bigint(20) unsigned NOT NULL COMMENT '接收人ID',
    `remark`     varchar(256) NULL DEFAULT '' COMMENT '申请描述',
    `status`     tinyint(2) unsigned DEFAULT 1 COMMENT '状态，1-申请中 2-同意 3-拒绝 4-过期',
    `accept_at`  int(11) NULL COMMENT '通过时间',
    `created_at` int(11) NOT NULL DEFAULT '0' COMMENT '申请时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY from_to_idx(`from_id`,`to_id`),
    KEY          to_idx(`to_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='好友申请历史';


DROP TABLE IF EXISTS `bs_user_relationship_list`;
CREATE TABLE `bs_user_relationship_list`
(
    `id`                bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `user_id`           bigint(20) unsigned NOT NULL COMMENT '用户ID',
    `friend_id`         bigint(20) unsigned NOT NULL COMMENT '对方的ID',
    `friend_alias`      text NULL COMMENT '给好友别名或备注',
    `relationship_type` tinyint(2) unsigned DEFAULT 1 COMMENT '关系类型，1-好友 2-关注',
    `status`            tinyint(2) unsigned DEFAULT 1 COMMENT '状态，1-正常 2-拉黑 3-删除',
    `created_at`        int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`),
    KEY                 usr_idx(`user_id`,`friend_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户关系列表';


-- 社交圈子

CREATE TABLE `bs_community_moment_list`
(
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `user_id`         bigint(20) unsigned NOT NULL COMMENT '用户ID',
    `moment_id`       bigint(20) unsigned NOT NULL COMMENT '时刻ID',
    `content`         text COMMENT '描述内容',
    `attachment`      text COMMENT '图片/音频/视频的url集合',
    `attachment_type` tinyint(2) DEFAULT NULL COMMENT '类型 1-图片  2-音频  3-视频文件',
    `public`          tinyint(2) DEFAULT '1' COMMENT '可见范围 1-公共  2-私密',
    `status`          tinyint(2) unsigned DEFAULT '1' COMMENT '状态，1-审核中 2-正常 3-违规 4-删除',
    `created_at`      int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`),
    KEY               `moment_idx` (`moment_id`),
    KEY               `user_moment_idx` (`user_id`,`moment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='用户发布的时刻'


DROP TABLE IF EXISTS `bs_moment_count_list`;
CREATE TABLE `bs_moment_count_list`
(
    `id`                bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `moment_id`         bigint(20) unsigned NOT NULL COMMENT '时刻ID',
    `like_count`        int(11) NOT NULL DEFAULT '0' COMMENT '点赞数',
    `like_cancel_count` int(11) NOT NULL DEFAULT '0' COMMENT '点赞取消数',
    `comment_count`     int(11) NOT NULL DEFAULT '0' COMMENT '评论数',
    PRIMARY KEY (`id`),
    UNIQUE KEY `moment_id_idx` (`moment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='时刻历史点赞评论计数';

ALTER TABLE `bs_moment_count_list`
    ADD COLUMN `like_cancel_count` INT(11) NOT NULL DEFAULT '0' COMMENT '点赞取消数' AFTER `like_count`;


DROP TABLE IF EXISTS `bs_moment_like_list`;
CREATE TABLE `bs_moment_like_list`
(
    `id`         bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `moment_id`  bigint(20) unsigned NOT NULL COMMENT '时刻ID',
    `user_id`    bigint(20) unsigned NOT NULL COMMENT '用户ID',
    `status`     tinyint(2) unsigned DEFAULT 1 COMMENT '状态，1-正常 2-取消',
    `created_at` int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`),
    UNIQUE KEY `user_moment_idx` (`user_id`,`moment_id`),
    KEY          `user_create_status_idx` (`user_id`,`created_at`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='时刻的点赞记录';

DROP TABLE IF EXISTS `bs_moment_comment_list`;
CREATE TABLE `bs_moment_comment_list`
(
    `id`               bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `comment_id`       bigint(20) unsigned NOT NULL COMMENT '评论ID',
    `parent_id`        bigint(20) NULL COMMENT '顶级评论ID，没有则为0',
    `moment_id`        bigint(20) unsigned NOT NULL COMMENT '时刻ID',
    `user_id`          bigint(20) unsigned NOT NULL COMMENT '用户ID',
    `reply_id`         bigint(20) NULL COMMENT '回复 用户ID，没有则为0',
    `reply_comment_id` bigint(20) NULL COMMENT '回复评论ID，没有则为0',
    `content`          text COMMENT '描述内容',
    `status`           tinyint(2) unsigned DEFAULT 1 COMMENT '状态，1-审核中 2-正常 3-违规 4-删除',
    `created_at`       int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`),
    KEY                `user_idx` (`user_id`,`created_at`),
    KEY                `moment_commentparnet_id_idx` (`moment_id`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='时刻的评论记录';

DROP TABLE IF EXISTS `bs_moment_comment_count`;
CREATE TABLE `bs_moment_comment_count`
(
    `id`                bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `comment_id`        bigint(20) unsigned NOT NULL COMMENT '评论ID',
    `like_count`        int(11) NOT NULL DEFAULT '0' COMMENT '点赞数',
    `like_cancel_count` int(11) NOT NULL DEFAULT '0' COMMENT '点赞取消数',
    `comment_count`     int(11) NOT NULL DEFAULT '0' COMMENT '评论数',
    PRIMARY KEY (`id`),
    UNIQUE KEY `comment_idx` (`comment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论的点赞回复计数';

alter table `bs_moment_comment_count`
    ADD column `comment_count` int(11) NOT NULL DEFAULT '0' COMMENT '评论数' after `like_cancel_count`;

DROP TABLE IF EXISTS `bs_moment_comment_like_list`;
CREATE TABLE `bs_moment_comment_like_list`
(
    `id`         bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `comment_id` bigint(20) unsigned NOT NULL COMMENT '评论ID',
    `user_id`    bigint(20) unsigned NOT NULL COMMENT '用户ID',
    `status`     tinyint(2) unsigned DEFAULT 1 COMMENT '状态，1-正常 2-取消',
    `created_at` int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`),
    unique key `usercomment_idx` (`user_id`,`comment_id`),
    key          `user_create_idx` (`user_id`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论被点赞的记录';

DROP TABLE IF EXISTS `bs_community_topic_list`;
CREATE TABLE `bs_community_topic_list`
(
    `id`         bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `topic_id`   bigint(20) unsigned NOT NULL COMMENT '话题ID',
    `title`      varchar(256) NOT NULL DEFAULT '' COMMENT '标题',
    `status`     tinyint(2) unsigned DEFAULT 1 COMMENT '状态，1-正常 2-取消',
    `created_at` int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='社区话题';


