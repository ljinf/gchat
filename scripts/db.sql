-- 社交模块

-- 聊天

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
    `unread_num`      int(11) unsigned DEFAULT 0 COMMENT '未读数',
    `notify_type`     tinyint(2) DEFAULT 0 COMMENT '会话收到消息的提醒类型，0未屏蔽，正常提醒 1屏蔽 2强提醒',
    `is_top`          tinyint(2) DEFAULT 0 COMMENT '会话是否被置顶展示 0否 1是',
    `created_at`      datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`      datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `user_conversation_idx` (`user_id`,`conversation_id`),
    KEY               `conversation_user_idx` (`conversation_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户会话链';


DROP TABLE IF EXISTS `msg_list`;
CREATE TABLE `msg_list`
(
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `user_id`         bigint(20) unsigned NOT NULL COMMENT '发送者ID',
    `msg_id`          bigint(20) unsigned NOT NULL COMMENT '消息ID',
    `conversation_id` varchar(64) NOT NULL COMMENT '会话ID',
    `content`         text        NOT NULL COMMENT '消息文本',
    `content_type`    tinyint(2) NOT NULL DEFAULT '1' COMMENT '内容类型  1文本  2图片 3音频文件  4音频文件  5实时语音  6实时视频',
    `seq`             bigint(20) unsigned DEFAULT 0 COMMENT '消息在会话中的序列号，用于保证消息的顺序',
    `status`          tinyint(2) NOT NULL DEFAULT '0' COMMENT '消息状态枚举，0可见 1屏蔽 2撤回',
    `sent_at`         bigint(20) NOT NULL DEFAULT '0' COMMENT '发送时间',
    `created_at`      datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`      datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY               `msg_idx` (`msg_id`),
    KEY               `conversation_seq_idx` (`conversation_id`,`seq`),
    KEY               `user_sent_idx` (`user_id`,`sent_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息表';

DROP TABLE IF EXISTS `user_msg_list`;
CREATE TABLE `user_msg_list`
(
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `user_id`         bigint(20) unsigned NOT NULL COMMENT '用户ID',
    `msg_id`          bigint(20) unsigned NOT NULL COMMENT '消息ID',
    `conversation_id` varchar(64) NOT NULL COMMENT '会话ID',
    `seq`             bigint(20) unsigned DEFAULT 0 COMMENT '消息序列号',
    `created_at`      datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY               `user_conversation_seq_msg_idx` (`user_id`,`conversation_id`,`seq`,`msg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户消息链(写扩散)';

DROP TABLE IF EXISTS `conversation_msg_list`;
CREATE TABLE `conversation_msg_list`
(
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
    `conversation_id` varchar(64) NOT NULL COMMENT '会话ID',
    `msg_id`          bigint(20) unsigned NOT NULL COMMENT '消息ID',
    `seq`             bigint(20) unsigned DEFAULT 0 COMMENT '消息在会话中的序列号，用于保证消息的顺序',
    `created_at`      datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY               conversation_seq_idx(`conversation_id`,`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会话消息链(读扩散)';

