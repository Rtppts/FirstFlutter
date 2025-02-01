package middlewares

import (
	"net/http"
	"strings"

	"firstflutter/services"

	"github.com/gin-gonic/gin"
)

var HashKey = []byte("very-secret")
var BlockKey = []byte("a-lot-secret1234")

// Authorization เป็นฟังก์ชั่นตรวจเช็ค Cookie
// ฟังก์ชัน Authorizes เป็น middleware ในการตรวจสอบว่า request ที่เข้ามามี JWT Token ที่ถูกต้องหรือไม่
func Authorizes() gin.HandlerFunc {
	return func(c *gin.Context) {
		clientToken := c.Request.Header.Get("Authorization")
		//ดึงค่า Authorization (token) ที่ http ที่ get มาจาก localStorage
		//const Authorization = localStorage.getItem("token");

		if clientToken == "" { //ถ้าไม่มีก็ แจ้ง error และ ไม่ทำงานต่อ
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "No Authorization header provided"})
			return
		}

		//แยก token ออกจากคำว่า "Bearer":
		//Token ที่ได้รับมักจะอยู่ในรูปแบบ Bearer <token> ดังนั้นจึงแยกเฉพาะค่า <token> ออกมา
		extractedToken := strings.Split(clientToken, "Bearer ")

		//ถ้ารูปแบบของ token ไม่ถูกต้อง (ไม่ใช่ "Bearer <token>") จะส่ง error
		//ว่า "Incorrect Format of Authorization Token" และหยุดการทำงานของ request
		if len(extractedToken) == 2 {
			clientToken = strings.TrimSpace(extractedToken[1])
		} else {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Incorrect Format of Authorization Token"})
			return
		}

		//สร้าง JWT wrapper สำหรับตรวจสอบ token
		jwtWrapper := services.JwtWrapper{
			SecretKey: "SvNQpBN8y3qlVrsGAYYWoJJk56LtzFHx", //SecretKey ในส่วนของ Authorizes middleware จะต้องตรงกับ
			Issuer:    "AuthService",                      //SecretKey ที่ใช้ตอนสร้าง token ในฟังก์ชัน SignIn เสมอ
		}

		//ฟังก์ชัน ValidateToken จะตรวจสอบว่า token นั้นถูกต้องหรือไม่
		//ถ้าไม่ถูกต้องหรือหมดอายุ จะส่งสถานะ 401 Unauthorized พร้อม error message
		_, err := jwtWrapper.ValidateToken(clientToken) //ตรวจสอบก้อน jwtWrapper กับ clientToken ว่าตรงกันไหม
		if err != nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
			return

		}
		c.Next()
		//หาก token ถูกต้อง จะเรียก c.Next() เพื่อให้ request ทำงานต่อไปยัง handler พาร์ท  ที่ถูกเรียก
	}

}
