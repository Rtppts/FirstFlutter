package controller

import (
	"firstflutter/config"
	"firstflutter/entity"
	"net/http"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)


func AddLogin(c *gin.Context) {
	var loginData struct {
		Email    string `json:"username"`
		Password string `json:"password"`
	}

	db := config.DB()

	if err := c.ShouldBindJSON(&loginData); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "ข้อมูลไม่ถูกต้อง"})
		return
	}

	var account entity.Account
	if err := db.Where("email = ?", loginData.Email).First(&account).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "ไม่มี Email นี้"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "เกิดข้อผิดพลาดในการเชื่อมต่อฐานข้อมูล"})
		return
	}

	// 🔹 ตรวจสอบรหัสผ่าน (ใช้ config.CheckPasswordHash)
	if !config.CheckPasswordHash([]byte(loginData.Password), []byte(account.Password)) {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "รหัสผ่านไม่ถูกต้อง"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "เข้าสู่ระบบสำเร็จ"})
}