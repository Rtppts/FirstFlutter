package services

import (
	"errors"
	"time"

	jwt "github.com/dgrijalva/jwt-go"
)

// JwtWrapper wraps the signing key and the issuer
type JwtWrapper struct {
	SecretKey       string
	Issuer          string
	ExpirationHours int64
}

// JwtClaim adds email as a claim to the token
type JwtClaim struct {
	Email string
	jwt.StandardClaims
}

//สร้าง JWT (JSON Web Token) คีย์ลับ (SecretKey), ผู้ให้บริการ (Issuer) และเวลาหมดอายุ (ExpirationHours)
func (j *JwtWrapper) GenerateToken(email string) (signedToken string, err error) {
	claims := &JwtClaim{
		Email: email,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: time.Now().Local().Add(time.Hour * time.Duration(j.ExpirationHours)).Unix(),
			Issuer:    j.Issuer,
		},
	}
	//สร้าง token ใหม่โดยใช้ claims ที่สร้างไว้ และระบุวิธีการเข้ารหัสเป็น HS256
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	signedToken, err = token.SignedString([]byte(j.SecretKey))
	if err != nil {
		return
	}
	//ใช้ SecretKey ที่กำหนดไว้ใน JwtWrapper มาเซ็นชื่อ token เพื่อให้สามารถตรวจสอบความถูกต้องได้ภายหลัง
	//ถ้าการเซ็นชื่อสำเร็จ จะได้ token ที่ถูกเข้ารหัสในตัวแปร signedToken

	return  //หากไม่มีข้อผิดพลาด จะคืนค่า signedToken (JWT ที่สร้างและเซ็นชื่อเรียบร้อยแล้ว) กลับไป
}

// Validate Token validates the jwt token
func (j *JwtWrapper) ValidateToken(signedToken string) (claims *JwtClaim, err error) {
	token, err := jwt.ParseWithClaims(
		signedToken,
		&JwtClaim{},
		func(token *jwt.Token) (interface{}, error) {
			return []byte(j.SecretKey), nil
		},
	)

	if err != nil {
		return
	}

	claims, ok := token.Claims.(*JwtClaim)
	if !ok {
		err = errors.New("Couldn't parse claims")
		return
	}

	if claims.ExpiresAt < time.Now().Local().Unix() {
		err = errors.New("JWT is expired")
		return
	}

	return

}
