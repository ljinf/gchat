package model

// 会话链
type ConversationList struct {
	Id             int64  `json:"id"`
	ConversationId string `json:"conversation_id"` //会话ID
	Type           int    `json:"type"`            //会话类型枚举，0单聊 1群聊
	Member         int    `json:"member"`          //与会话相关的用户数量
	Avatar         string `json:"avatar"`          //群组头像
	Announcement   string `json:"announcement"`    //群公告
	RecentMsgTime  int64  `json:"recent_msg_time"` //此会话最新产生消息的时间
	CreatedAt      int64  `json:"created_at"`
}

func (c *ConversationList) TableName() string {
	return "conversation_list"
}

// 用户会话链
type UserConversationList struct {
	Id             int64  `json:"id"`
	UserId         string `json:"user_id"`         //用户ID
	ConversationId string `json:"conversation_id"` //会话ID
	UnreadNum      int    `json:"unread_num"`      //未读数
	NotifyType     int    `json:"notify_type"`     //会话收到消息的提醒类型，0未屏蔽，正常提醒 1屏蔽 2强提醒
	IsTop          int    `json:"is_top"`          //会话是否被置顶展示 0否 1是
}

func (c *UserConversationList) TableName() string {
	return "user_conversation_list"
}

// 消息链
type MsgList struct {
	Id             int64  `json:"id"`
	UserId         string `json:"user_id"`         //发送者ID
	MsgId          string `json:"msg_id"`          //消息ID
	ConversationId string `json:"conversation_id"` //会话ID
	Content        string `json:"content"`         //消息文本
	ContentType    int    `json:"content_type"`    //内容类型  1文本  2图片 3音频文件  4音频文件  5实时语音  6实时视频
	Status         int    `json:"status"`          //消息状态枚举，0可见 1屏蔽 2撤回
	SentAt         int64  `json:"sent_at"`         //发送时间
}

func (m *MsgList) TableName() string {
	return "msg_list"
}

// 用户消息链
type UserMsgList struct {
	Id             int64  `json:"id"`
	UserId         string `json:"user_id"`         //用户ID
	MsgId          string `json:"msg_id"`          //消息ID
	ConversationId string `json:"conversation_id"` //会话ID
	Seq            int64  `json:"seq"`             //消息序列号
}

func (m *UserMsgList) TableName() string {
	return "user_msg_list"
}

// 会话消息链
type ConversationMsgList struct {
	Id             int64  `json:"id"`
	ConversationId string `json:"conversation_id"` //会话ID
	MsgId          string `json:"msg_id"`          //消息ID
	Seq            int64  `json:"seq"`             //消息在会话中的序列号，用于保证消息的顺序
}

func (c *ConversationMsgList) TableName() string {
	return "conversation_msg_list"
}
