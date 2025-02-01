package config

import (
	"fmt"
	"firstflutter/entity"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

var db *gorm.DB

func DB() *gorm.DB {
	return db
}

func ConnectionDB() {
	database, err := gorm.Open(sqlite.Open("FirstFlutter.db?cache=shared"), &gorm.Config{})
	if err != nil {
		panic("failed to connect database")
	}
	fmt.Println("connected database")
	db = database
}

func SetupDatabase() {

	db.AutoMigrate(&entity.Account{},)

	var count int64
	db.Model(&entity.Account{}).Count(&count)

	if count == 0 {
		password1, _ := HashPassword("aut1234")
		db.Create(&entity.Account{FirstName: "Rattapon", LastName: "Phonthaisong", Email: "aut@gmail.com", Password: password1})
	}
	
}
