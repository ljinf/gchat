package ws

import (
	"github.com/gorilla/websocket"
)

type Conn interface {
	ID() string
	Read() ([]byte, error)
	Write(payload []byte) error
}

type conn struct {
	ConnId string          `json:"conn_id"`
	Socket *websocket.Conn `json:"socket"`
}

func (c *conn) ID() string {
	return c.ConnId
}

func (c *conn) Read() ([]byte, error) {
	message, payload, err := c.Socket.ReadMessage()
	switch message {
	case websocket.PingMessage:
		_ = c.write(websocket.PongMessage, nil)
		return nil, nil
	case websocket.PongMessage:
		return nil, nil
	case websocket.CloseMessage:
		return nil, nil
	}

	return payload, err
}

func (c *conn) write(messageType int, data []byte) error {
	return c.Socket.WriteMessage(messageType, data)
}

func (c *conn) Write(payload []byte) error {
	return c.Socket.WriteMessage(websocket.BinaryMessage, payload)
}

func NewConn(id string, s *websocket.Conn) Conn {
	return &conn{
		ConnId: id,
		Socket: s,
	}
}
