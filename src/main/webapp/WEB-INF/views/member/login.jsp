<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<!-- beautify ignore:start -->
<html
  lang="ko"
  class="light-style customizer-hide"
  dir="ltr"
  data-theme="theme-default"
  data-assets-path="/assets/"
  data-template="vertical-menu-template-free"
>
  <head>
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0"
    />

    <title>Login Basic - Pages | Sneat - Bootstrap 5 HTML Admin Template - Pro</title>

    <meta name="description" content="" />

    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="/assets/img/favicon/favicon.ico" />

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Public+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
      rel="stylesheet"
    />

    <!-- Icons. Uncomment required icon fonts -->
    <link rel="stylesheet" href="/assets/vendor/fonts/boxicons.css" />

    <!-- Core CSS -->
    <!-- <link rel="stylesheet" href="../assets/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="../assets/vendor/css/theme-default.css" class="template-customizer-theme-css" /> -->
    <link rel="stylesheet" href="/assets/css/demo.css" />

    <!-- Vendors CSS -->
    <link rel="stylesheet" href="/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />

    <!-- Page CSS -->
    <!-- Page -->
    <link rel="stylesheet" href="/assets/vendor/css/pages/page-auth.css" />
    <!-- Helpers -->
    <script src="/assets/vendor/js/helpers.js"></script>

    <!--! Template customizer & Theme config files MUST be included after core stylesheets and helpers.js in the <head> section -->
    <!--? Config:  Mandatory theme config file contain global vars & default theme options, Set your preferred theme option in this file.  -->
    <script src="/assets/js/config.js"></script>
    
    <style type="text/css">
   	* {
	  margin: 0;
	  padding: 0;
	  box-sizing: border-box;
	}
	
	body{
	  background-color: #2d499d;
	  margin: 0;
	}
	
	.auth-wrapper {
	  width: 40%;
	  min-height: 100vh;
	  display: flex;
	  align-items: center;
	  background: #fff;
	}
	
	.auth-card {
	  width: 100%;
	  height: 100%;
	  padding: 32px;
	}
	
	.logo_image_text{
	  margin-left: 80px;
	  display: flex;
	  align-items: center;
	}
	
	span{
	  font-size: 30px;
	}
	
	.logo {
	  display: flex;
	  align-items: center;
	  gap: 10px;
	  margin-bottom: 24px;
	  text-decoration: none;
	  color: #000;
	}
	
	.logo img {
	  width: 60px;
	  height: 60px;
	}
	form {
	  width: 80%;
	  display: flex;
	  flex-direction: column;
	  gap: 12px;
	  margin: 0 auto;
	}
	
	input {
	  padding: 10px;
	  border-radius: 8px;
	  border: 1px solid #ddd;
	  transition: border-color 0.2s ease-in-out;
	}
	input:focus {
      border: 1px solid #696cff;
      outline: none; 
    }
	button {
	  margin-top: 10px;
	  padding: 12px;
	  border: none;
	  border-radius: 8px;
	  background: #696cff;
	  color: #fff;
	  cursor: pointer;
	}
	
	.login-error {
	  color: #ff6b6b;
	  font-size: 0.9rem;
	}
		    	
    
    </style>
  </head>

  <body>
    <!-- Content -->

      <div class="auth-wrapper">
        <div class="auth-card">

          <div class="logo_image_text logo">
              <img src="/img/돌고래.jpg" alt="Logo" />
              <span>ERP</span>
          </div>
		
		
          <form action="/login" class="auth-login-form" method="post">
			<c:if test="${not empty param.error }">
				<div class="alert alert-danger alert-dismissible login-error" role="alert">
			        아이디 또는 비밀번호를 다시 확인해 주세요.
			    </div>
			</c:if>
            <input type="text" name="memberId" id="memberId" placeholder="아이디를 입력하세요" />

            <input type="password" name="memPassword" id="memPassword" placeholder="비밀번호를 입력하세요" />

            <label class="remember">
              <input type="checkbox" id="savedId"/>
              아이디 저장
            </label>

            <button type="submit">로그인</button>
          </form>

        </div>
      </div>

    <!-- / Content -->



    <!-- Core JS -->
    <!-- build:js assets/vendor/js/core.js -->
    <script src="/assets/vendor/libs/jquery/jquery.js"></script>
    <script src="/js/member/login.js"></script>
    <script src="/assets/vendor/libs/popper/popper.js"></script>
    <script src="/assets/vendor/js/bootstrap.js"></script>
    <script src="/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>

    <script src="/assets/vendor/js/menu.js"></script>
    <!-- endbuild -->

    <!-- Vendors JS -->

    <!-- Main JS --Q
    <script src="/assets/js/main.js"></script>

    <!-- Page JS -->

  </body>
</html>
