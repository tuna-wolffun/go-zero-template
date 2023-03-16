package model

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type {{.Type}} struct {
	ID primitive.ObjectID `bson:"_id,omitempty" json:"id,omitempty"`

	CreatedAt time.Time `bson:"created,omitempty" json:"created,omitempty"`
	UpdatedAt time.Time `bson:"lastModified,omitempty" json:"lastModified,omitempty"`

	// TODO: Fill your own fields
}
