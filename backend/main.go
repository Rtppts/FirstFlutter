package main

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"firstflutter/config"
	"firstflutter/middlewares"
	"firstflutter/controller"
)

const PORT = "8000"

func main() {

	// open connection database
	config.ConnectionDB()

	// Generate databases
	config.SetupDatabase()

	r := gin.Default()

	r.Use(CORSMiddleware())

	// Auth Route
	/*อยู่ด้านนอกกลุ่มที่ใช้มิดเดิลแวร์ Authorizes()
	เพราะการสมัครสมาชิก (signup) และเข้าสู่ระบบ (signin) ไม่จำเป็นต้องมีการตรวจสอบ JWT Authorization ก่อน*/
	r.POST("/addlogin", controller.AddLogin)

	router := r.Group("/")
	{
		//ทุก request ที่อยู่ภายใต้กลุ่ม router จะถูกบังคับให้ใช้ middlewares.Authorizes() เสมอ
		router.Use(middlewares.Authorizes()) //ใช้ middlewares.Authorizes
		// r.Static("Image/imageproduct", "./Image/imageproduct/")
		// authorized.POST("/deleteproductbyid/:id", controller.DeleteProductByID)
		// router.GET("/user/:id", controller.Addlogin)

	}


	r.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "API RUNNING... PORT: %s", PORT)
	})

	r.Run("localhost:" + PORT)

}

func CORSMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}
