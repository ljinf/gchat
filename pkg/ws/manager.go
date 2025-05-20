package ws

import (
	"errors"
	"sync"
)

type ConnManager struct {
	conns map[string]Conn
	lock  sync.RWMutex
}

func NewConnManager() *ConnManager {
	return &ConnManager{
		conns: make(map[string]Conn),
	}
}

func (m *ConnManager) AddConn(conn Conn) error {
	m.lock.Lock()
	defer m.lock.Unlock()
	m.conns[conn.ID()] = conn
	return nil
}

func (m *ConnManager) GetConn(connId string) (Conn, error) {
	m.lock.RLock()
	defer m.lock.RUnlock()
	child, ok := m.conns[connId]
	if !ok {
		return nil, errors.New("not found")
	}
	return child, nil
}

func (m *ConnManager) RemoveConn(connId string) error {
	m.lock.Lock()
	defer m.lock.Unlock()
	delete(m.conns, connId)
	return nil
}
