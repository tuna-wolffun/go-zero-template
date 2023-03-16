package model

{{if .Cache}}import (
    "context"
    "github.com/zeromicro/go-zero/core/stores/cache"
    "github.com/zeromicro/go-zero/core/stores/monc"
    "go.mongodb.org/mongo-driver/mongo"
){{else}}import (
    "context"
    "github.com/zeromicro/go-zero/core/stores/mon"
    "go.mongodb.org/mongo-driver/mongo"
){{end}}

const CollectionName = "{{.Type}}"

var _ {{.Type}}Model = (*custom{{.Type}}Model)(nil)

type (
    // {{.Type}}Model is an interface to be customized, add more methods here,
    // and implement the added methods in custom{{.Type}}Model.
    {{.Type}}Model interface {
        {{.lowerType}}Model
        TransactionWithCtx(ctx context.Context, f func(sc mongo.SessionContext) (interface{}, error)) (interface{}, error)
    }

    custom{{.Type}}Model struct {
        *default{{.Type}}Model
    }
)

// New{{.Type}}Model returns a model for the mongo.
func New{{.Type}}Model(url, db string{{if .Cache}}, c cache.CacheConf{{end}}) {{.Type}}Model {
    conn := {{if .Cache}}monc{{else}}mon{{end}}.MustNewModel(url, db, CollectionName{{if .Cache}}, c{{end}})
    return &custom{{.Type}}Model{
        default{{.Type}}Model: newDefault{{.Type}}Model(conn),
    }
}

func (model custom{{.Type}}Model) TransactionWithCtx(ctx context.Context,
    f func(sc mongo.SessionContext) (interface{}, error)) (interface{}, error) {
	session, err := model.conn.StartSession()
	if err != nil {
		return nil, err
	}

	defer session.EndSession(ctx)

	return session.WithTransaction(ctx, f)
}
