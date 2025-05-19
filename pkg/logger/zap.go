package logger

import (
	"github.com/ljinf/gchat/pkg/enum"
	"github.com/spf13/viper"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"gopkg.in/natefinch/lumberjack.v2"
	"os"
)

var _logger *zap.Logger

func InitLogger(conf *viper.Viper) {
	encoderConfig := zap.NewProductionEncoderConfig()
	encoderConfig.EncodeTime = zapcore.ISO8601TimeEncoder
	encoder := zapcore.NewJSONEncoder(encoderConfig)
	logWriter := getFileLogWriter(conf)

	var cores []zapcore.Core
	switch conf.GetString("app.env") {
	case enum.ModeTest, enum.ModeProd:
		// 测试环境和生产环境的日志输出到文件中
		cores = append(cores, zapcore.NewCore(encoder, logWriter, zap.InfoLevel))
		break
	case enum.ModeDev:
		// 开发环境同时向控制台和文件输出日志， Debug级别的日志也会被输出
		cores = append(cores,
			zapcore.NewCore(encoder, zapcore.AddSync(os.Stdout), zap.DebugLevel),
			zapcore.NewCore(encoder, logWriter, zap.DebugLevel))
	}
	core := zapcore.NewTee(cores...)
	_logger = zap.New(core)
}

func getFileLogWriter(conf *viper.Viper) zapcore.WriteSyncer {
	// 使用 lumberjack 实现 logger rotate
	log := &lumberjack.Logger{
		Filename:   conf.GetString("log.log_file_name"),
		MaxSize:    conf.GetInt("log.max_size"),    //文件大小
		MaxAge:     conf.GetInt("log.max_age"),     //旧文件最大保留天数
		MaxBackups: conf.GetInt("log.max_backups"), //日志文件最多保存多少个备份
		Compress:   conf.GetBool("log.compress"),
		LocalTime:  true,
	}

	return zapcore.AddSync(log)
}
