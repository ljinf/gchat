package repository

import (
	"context"
	"github.com/ljinf/gchat/internal/model"
	"strings"
)

type ConversationRepository interface {
	//会话链
	CreateConversationList(ctx context.Context, req *model.ConversationList) error
	UpdateConversationList(ctx context.Context, req *model.ConversationList) error
	SelectConversationInfo(ctx context.Context, convId string) (*model.ConversationList, error)

	//用户会话链
	CreateUserConversationList(ctx context.Context, req *model.UserConversationList) error
	UpdateUserConversationList(ctx context.Context, req *model.UserConversationList) error
	SelectUserConversationInfo(ctx context.Context, userId, convId string) ([]model.UserConversationList, error)
}

type conversationRepository struct {
	*Repository
}

func (c *conversationRepository) CreateConversationList(ctx context.Context, req *model.ConversationList) error {
	return c.DB(ctx).Create(req).Error
}

func (c *conversationRepository) UpdateConversationList(ctx context.Context, req *model.ConversationList) error {
	return c.DB(ctx).Where("conversation_id=?", req.ConversationId).Updates(req).Error
}

func (c *conversationRepository) SelectConversationInfo(ctx context.Context, convId string) (*model.ConversationList, error) {
	var info model.ConversationList
	if err := c.DB(ctx).Where("conversation_id=?", convId).First(&info).Error; err != nil {
		return nil, err
	}
	return &info, nil
}

func (c *conversationRepository) CreateUserConversationList(ctx context.Context, req *model.UserConversationList) error {
	return c.DB(ctx).Create(req).Error
}

func (c *conversationRepository) UpdateUserConversationList(ctx context.Context, req *model.UserConversationList) error {
	return c.DB(ctx).Where("user_id=? and conversation_id=?", req.UserId, req.ConversationId).Error
}

func (c *conversationRepository) SelectUserConversationInfo(ctx context.Context, userId, convId string) ([]model.UserConversationList, error) {

	var (
		conds  = []string{"user_id=?"}
		values = []interface{}{userId}
		list   []model.UserConversationList
	)

	if len(convId) > 0 {
		conds = append(conds, "conversation_id=?")
		values = append(values, convId)
	}

	err := c.DB(ctx).Where(strings.Join(conds, " and "), values...).Find(&list).Error
	return list, err
}

func NewConversationRepository(r *Repository) ConversationRepository {
	return &conversationRepository{
		Repository: r,
	}
}
