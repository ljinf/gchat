package repository

import (
	"context"
	"github.com/ljinf/gchat/internal/model"
)

type MessageRepository interface {
	//消息链
	CreateMsgList(ctx context.Context, req *model.MsgList) error
	UpdateMsgList(ctx context.Context, req *model.MsgList) error
	SelectMsgList(ctx context.Context, msgId string) (*model.MsgList, error)
	SelectMsgListByUserId(ctx context.Context, userId string, sentAt int64, limit int) ([]model.MsgList, error)
	SelectMsgListByConvId(ctx context.Context, convId string, seq, limit int) ([]model.MsgList, error)

	//用户消息链
	CreateUserMsgList(ctx context.Context, req *model.UserMsgList) error
}

type messageRepository struct {
	*Repository
}

func (m *messageRepository) CreateMsgList(ctx context.Context, req *model.MsgList) error {
	return m.DB(ctx).Create(req).Error
}

func (m *messageRepository) UpdateMsgList(ctx context.Context, req *model.MsgList) error {
	return m.DB(ctx).Table(req.TableName()).Where("msg_id=?", req.MsgId).Update("status", req.Status).Error
}

func (m *messageRepository) SelectMsgList(ctx context.Context, msgId string) (*model.MsgList, error) {
	var msg model.MsgList
	if err := m.DB(ctx).Where("msg_id=?", msgId).First(&msg).Error; err != nil {
		return nil, err
	}
	return &msg, nil
}

func (m *messageRepository) SelectMsgListByUserId(ctx context.Context, userId string, sentAt int64, limit int) ([]model.MsgList, error) {
	var list []model.MsgList

	querySql := "SELECT m.`id`,m.`user_id`,m.`msg_id`,m.`conversation_id`,m.`content`,m.`content_type`,m.`seq`,m.`status`,m.`sent_at` " +
		"FROM `msg_list` m WHERE m.`user_id`=? AND m.`sent_at`>? ORDER BY m.`sent_at` ASC LIMIT ?"
	err := m.DB(ctx).Raw(querySql, userId, sentAt, limit).Find(&list).Error
	return list, err
}

func (m *messageRepository) SelectMsgListByConvId(ctx context.Context, convId string, seq, limit int) ([]model.MsgList, error) {
	var list []model.MsgList

	querySql := "SELECT m.`id`,m.`user_id`,m.`msg_id`,m.`conversation_id`,m.`content`,m.`content_type`,m.`seq`,m.`status`,m.`sent_at` " +
		"FROM `msg_list` m WHERE m.`conversation_id`=? AND m.`seq`>? ORDER BY m.`seq` ASC LIMIT ?"
	err := m.DB(ctx).Raw(querySql, convId, seq, limit).Find(&list).Error
	return list, err
}

func (m *messageRepository) CreateUserMsgList(ctx context.Context, req *model.UserMsgList) error {
	//TODO implement me
	panic("implement me")
}

func NewMessageRepository(r *Repository) MessageRepository {
	return &messageRepository{
		Repository: r,
	}
}
