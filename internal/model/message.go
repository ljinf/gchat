package model

import "encoding/json"

// 好友关系

// 好友申请历史
type FriendApplyHistory struct {
	Id        int64  `json:"id"`
	FromId    string `json:"from_id"`    //发起人ID
	ToId      string `json:"to_id"`      //接收人ID
	Remark    string `json:"remark"`     //申请描述
	Status    int    `json:"status"`     //状态，1-申请中 2-同意 3-拒绝 4-过期
	AcceptAt  int64  `json:"accept_at"`  //通过时间
	CreatedAt int64  `json:"created_at"` //申请时间
}

func (c *FriendApplyHistory) TableName() string {
	return "bs_friend_apply_history"
}

// 用户关系列表
type UserRelationship struct {
	Id               int64  `json:"id"`
	UserId           string `json:"user_id"`           //用户ID
	FriendId         string `json:"friend_id"`         //对方的ID
	FriendAlias      string `json:"friend_alias"`      //给好友别名或备注
	RelationshipType int    `json:"relationship_type"` //关系类型，1-好友 2-关注
	Status           int    `json:"status"`            //状态，1-正常 2-拉黑 3-删除
	CreatedAt        int64  `json:"created_at"`
}

func (c *UserRelationship) TableName() string {
	return "bs_user_relationship_list"
}

// 会话
type ConversationList struct {
	Id             int64  `json:"id"`
	ConversationId string `json:"conversation_id"` //会话ID
	Type           int    `json:"type"`            //会话类型枚举，1单聊 2群聊
	Member         int    `json:"member"`          //与会话相关的用户数量
	Avatar         string `json:"avatar"`          //群组头像
	Announcement   string `json:"announcement"`    //群公告
	RecentMsgTime  int64  `json:"recent_msg_time"` //此会话最新产生消息的时间
	CreatedAt      int64  `json:"created_at"`      //创建日期
}

func (c *ConversationList) TableName() string {
	return "bs_conversation_list"
}

// 用户会话链
type UserConversationList struct {
	Id             int64  `json:"id"`
	UserId         string `json:"user_id"`         //用户ID
	ConversationId string `json:"conversation_id"` //会话ID
	LastReadSeq    int64  `json:"last_read_seq"`   //此会话用户已读的最后一条消息
	NotifyType     int    `json:"notify_type"`     //会话收到消息的提醒类型，1未屏蔽，正常提醒 2屏蔽 3强提醒
	IsTop          int    `json:"is_top"`          //会话是否被置顶展示 1否 2是
	IsDel          int    `json:"is_del"`          //会话是否被删除 0否 1是
	CreatedAt      int64  `json:"created_at"`
	UpdatedAt      int64  `json:"updated_at"`
}

func (c *UserConversationList) TableName() string {
	return "bs_user_conversation_list"
}

type UserConversationResp struct {
	ConversationId string `json:"conversation_id"` //会话ID
	Type           int    `json:"type"`            //会话类型枚举，1单聊 2群聊
	Member         int    `json:"member"`          //与会话相关的用户数量
	Version        int    `json:"version"`         //会话版本号

	UserId      string `json:"user_id"`       //用户ID
	UserVersion int    `json:"user_version"`  //用户会话版本号
	LastReadSeq int64  `json:"last_read_seq"` //此会话用户已读的最后一条消息
	NotifyType  int    `json:"notify_type"`   //会话收到消息的提醒类型，1未屏蔽，正常提醒 2屏蔽 3强提醒
	IsTop       int    `json:"is_top"`        //会话是否被置顶展示 1否 2是
	IsDel       int    `json:"is_del"`        //会话是否被删除 0否 1是
}

// 消息
type MsgList struct {
	Id             int64  `json:"id"`
	UserId         string `json:"user_id"`         //发送者ID
	MsgId          string `json:"msg_id"`          //消息ID
	ConversationId string `json:"conversation_id"` //会话ID
	Content        string `json:"content"`         //消息文本
	ContentType    int    `json:"content_type"`    //内容类型  1文本  2图片 3音频文件  4视频文件  5实时语音  6实时视频
	Seq            int    `json:"seq"`             //消息在会话中的序列号，用于保证消息的顺序
	Status         int    `json:"status"`          //消息状态枚举，1可见 2屏蔽 3撤回
	SentAt         int64  `json:"sent_at"`         //发送时间
}

func (m *MsgList) TableName() string {
	return "bs_msg_list"
}

// 用户消息链
type UserMsgList struct {
	Id             int64  `json:"id"`
	UserId         string `json:"user_id"`         //发送者ID
	MsgId          string `json:"msg_id"`          //消息ID
	ConversationId string `json:"conversation_id"` //会话ID
	Seq            int    `json:"seq"`             //消息在会话中的序列号，用于保证消息的顺序
}

func (m *UserMsgList) TableName() string {
	return "bs_user_msg_list"
}

// 会话消息链
type ConversationMsgList struct {
	Id             int64  `json:"id"`
	ConversationId string `json:"conversation_id"` //会话ID
	MsgId          string `json:"msg_id"`          //消息ID
	Seq            int    `json:"seq"`             //消息在会话中的序列号，用于保证消息的顺序
}

func (m *ConversationMsgList) TableName() string {
	return "bs_conversation_msg_list"
}

// 会话（群）成员
type ConversationMember struct {
	Id             int64  `json:"id"`
	ConversationId string `json:"conversation_id"` //会话ID
	MemberId       string `json:"member_id"`       //成员ID
	Role           int    `json:"role"`            //成员角色 1-普通成员 2-管理员  100-群主
	Mute           int    `json:"mute"`            //禁言状态 1-否 2-是
	MuteExpire     int64  `json:"mute_expire"`     //禁言截止时间戳
}

func (m *ConversationMember) TableName() string {
	return "bs_conversation_members"
}

// 用户发布的时刻
type CommunityMoment struct {
	Id             int64           `json:"id"`
	UserId         string          `json:"user_id"`         //发送者ID
	MomentId       string          `json:"moment_id"`       //时刻ID
	Content        string          `json:"content"`         //描述内容
	Attachment     json.RawMessage `json:"attachment"`      //图片/音频/视频的url集合
	AttachmentType int             `json:"attachment_type"` //类型 1-图片  2-音频  3-视频文件
	Public         int             `json:"public"`          //可见范围 1-公共  2-私密
	Status         int             `json:"status"`          //状态，1-审核中 2-正常 3-违规 4-删除
	CreatedAt      int64           `json:"created_at"`
}

func (c *CommunityMoment) TableName() string {
	return "bs_community_moment_list"
}

// 时刻历史点赞评论计数
type MomentCount struct {
	Id              int64  `json:"id"`
	MomentId        string `json:"moment_id"`         //时刻ID
	LikeCount       int    `json:"like_count"`        //点赞数
	LikeCancelCount int    `json:"like_cancel_count"` //点赞取消数
	CommentCount    int    `json:"comment_count"`     //评论数
}

func (c *MomentCount) TableName() string {
	return "bs_moment_count_list"
}

// 时刻的点赞记录
type MomentLike struct {
	Id        int64  `json:"id"`
	MomentId  string `json:"moment_id"` //时刻ID
	UserId    string `json:"user_id"`
	Status    int    `json:"status"` //状态，1-正常 2-取消
	CreatedAt int64  `json:"created_at"`
}

func (c *MomentLike) TableName() string {
	return "bs_moment_like_list"
}

// 时刻的评论记录
type MomentComment struct {
	Id             int64  `json:"id"`
	CommentId      string `json:"comment_id"`       //评论ID
	ParentId       string `json:"parent_id"`        //父评论ID  顶级评论
	MomentId       string `json:"moment_id"`        //时刻ID
	UserId         string `json:"user_id"`          //用户ID
	ReplyId        string `json:"reply_id"`         //回复 用户ID
	ReplyCommentId string `json:"reply_comment_id"` //回复评论ID
	Content        string `json:"content"`          //评论内容
	Status         int    `json:"status"`           //状态，1-审核中 2-正常 3-违规 4-删除
	CreatedAt      int64  `json:"created_at"`
}

func (c *MomentComment) TableName() string {
	return "bs_moment_comment_list"
}

type MomentCommentResp struct {
	Id        int64  `json:"id"`
	CommentId string `json:"comment_id"` //评论ID
	ParentId  string `json:"parent_id"`  //父评论ID
	MomentId  string `json:"moment_id"`  //时刻ID
	UserId    string `json:"user_id"`    //用户ID
	ReplyId   string `json:"reply_id"`   //回复 用户ID
	Content   string `json:"content"`    //评论内容
	Status    int    `json:"status"`     //状态，1-审核中 2-正常 3-违规 4-删除
	CreatedAt int64  `json:"created_at"`

	LikeCount       int `json:"like_count"`        //点赞数
	LikeCancelCount int `json:"like_cancel_count"` //点赞取消数
	CommentCount    int `json:"comment_count"`     //评论回复数
}

// 评论被点赞的记录
type MomentCommentLike struct {
	Id        int64  `json:"id"`
	CommentId string `json:"comment_id"` //评论ID
	UserId    string `json:"user_id"`
	Status    int    `json:"status"` //状态，1-正常 2-取消
	CreatedAt int64  `json:"created_at"`
}

func (c *MomentCommentLike) TableName() string {
	return "bs_moment_comment_like_list"
}

// 评论被点赞回复的计数
type MomentCommentCount struct {
	Id              int64  `json:"id"`
	CommentId       string `json:"comment_id"`        //评论ID
	LikeCount       int    `json:"like_count"`        //点赞数
	LikeCancelCount int    `json:"like_cancel_count"` //点赞取消数
	CommentCount    int    `json:"comment_count"`     //评论数
}

func (c *MomentCommentCount) TableName() string {
	return "bs_moment_comment_count"
}

type CommunityMomentResp struct {
	Id             int64           `json:"id"`
	UserId         string          `json:"user_id"`         //发送者ID
	MomentId       string          `json:"moment_id"`       //时刻ID
	Content        string          `json:"content"`         //描述内容
	Attachment     json.RawMessage `json:"attachment"`      //图片/音频/视频的url集合
	AttachmentType int             `json:"attachment_type"` //类型 1-图片  2-音频  3-视频文件
	Public         int             `json:"public"`          //可见范围 1-公共  2-私密
	Status         int             `json:"status"`          //状态，1-审核中 2-正常 3-违规 4-删除
	CreatedAt      int64           `json:"created_at"`

	LikeCount       int `json:"like_count"`        //点赞数
	LikeCancelCount int `json:"like_cancel_count"` //点赞取消数
	LikeStatus      int `json:"like_status"`       //点赞状态
	CommentCount    int `json:"comment_count"`     //评论数
}
