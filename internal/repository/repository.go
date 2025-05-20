package repository

import (
	"context"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
	"time"
)

const (
	ctxTxKey               = "DBTxKey"
	DefaultMaxOpen         = 100
	DefaultMaxIdle         = 10
	DefaultConnMaxLifetime = 300000000000 // 300s 内可复用
)

type Repository struct {
	db *gorm.DB
}

func NewRepository(db *gorm.DB) *Repository {
	return &Repository{
		db: db,
	}
}

type Transaction interface {
	Transaction(ctx context.Context, fn func(ctx context.Context) error) error
}

func NewTransaction(r *Repository) Transaction {
	return r
}

// MasterDB return tx
// If you need to create a Transaction, you must call DB(ctx) and Transaction(ctx,fn)
func (r *Repository) DB(ctx context.Context) *gorm.DB {
	v := ctx.Value(ctxTxKey)
	if v != nil {
		if tx, ok := v.(*gorm.DB); ok {
			return tx
		}
	}
	return r.db.WithContext(ctx)
}

func (r *Repository) Transaction(ctx context.Context, fn func(ctx context.Context) error) error {
	return r.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		ctx = context.WithValue(ctx, ctxTxKey, tx)
		return fn(ctx)
	})
}

type DBOption func(conf *dbConfig)

type dbConfig struct {
	log             logger.Interface
	maxOpen         int
	maxIdle         int
	connMaxLifetime int
}

func NewDB(dsn string, option ...DBOption) *gorm.DB {

	conf := &dbConfig{
		log:             nil,
		maxOpen:         DefaultMaxOpen,
		maxIdle:         DefaultMaxIdle,
		connMaxLifetime: DefaultConnMaxLifetime,
	}
	for _, v := range option {
		v(conf)
	}

	var gConf *gorm.Config
	if conf.log != nil {
		gConf = &gorm.Config{Logger: conf.log}
	}
	db, err := gorm.Open(getDialector("mysql", dsn), gConf)
	if err != nil {
		panic(err)
	}

	sqlDb, _ := db.DB()
	sqlDb.SetMaxOpenConns(conf.maxOpen)
	sqlDb.SetMaxIdleConns(conf.maxIdle)
	sqlDb.SetConnMaxLifetime(time.Duration(conf.connMaxLifetime))
	if err = sqlDb.Ping(); err != nil {
		panic(err)
	}

	return db
}

func WithOrmLogger(log logger.Interface) DBOption {
	return func(conf *dbConfig) {
		conf.log = log
	}
}

func WithMaxOpen(maxOpen int) DBOption {
	return func(conf *dbConfig) {
		conf.maxOpen = maxOpen
	}
}

func WithMaxIdle(maxIdle int) DBOption {
	return func(conf *dbConfig) {
		conf.maxIdle = maxIdle
	}
}

func WithConnMaxLifetime(connMaxLifetime int) DBOption {
	return func(conf *dbConfig) {
		conf.connMaxLifetime = connMaxLifetime
	}
}

func getDialector(t, dsn string) gorm.Dialector {
	//switch t { 项目数据库需要加载多数据源时去掉注释
	//case "postgres":
	//	return postgres.Open(dsn)
	//default:
	//	return mysql.Open(dsn)
	//}
	return mysql.Open(dsn)
}
