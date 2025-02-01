package entity

import (
	"gorm.io/gorm"
)

type Account struct {
	gorm.Model
	FirstName string
	LastName  string    
	Email     string    
	Password  string    
}
