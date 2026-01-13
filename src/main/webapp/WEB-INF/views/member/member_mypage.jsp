<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>

<html lang="ko" class="light-style layout-menu-fixed" dir="ltr" data-theme="theme-default" data-assets-path="/assets/" data-template="vertical-menu-template-free">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>나의 근태 - 마이페이지</title>
    
    <link rel="icon" type="image/x-icon" href="/assets/img/favicon/favicon.ico" />
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="/vendor/fonts/boxicons.css" />
    <link rel="stylesheet" href="/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="/vendor/css/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="/css/demo.css" />
    <link rel="stylesheet" href="/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
    <link rel="stylesheet" href="/css/member/member_mypage.css" />
    

    <script src="/vendor/js/helpers.js"></script>
    <script src="/js/config.js"></script>
    
</head>

<body>
<div class="layout-wrapper layout-content-navbar">
    <div class="layout-container">
        
        <c:import url="/WEB-INF/views/template/aside.jsp"></c:import>

        <div class="layout-page">
            
            <c:import url="/WEB-INF/views/template/header.jsp"></c:import>

            <div class="content-wrapper">
                
                <div class="container-xxl flex-grow-1 container-p-y" style="padding-top: 3rem !important;">
                    
                    <h4 class="fw-bold py-3 mb-4">
                        <span class="text-muted fw-light">마이페이지 /</span> 나의 근태
                    </h4>

                    <div class="card shadow-sm">
                        <div class="card-body p-4">
                            <div id='calendar'></div> 
                        </div>
                    </div>

                </div>
                
                <c:import url="/WEB-INF/views/template/footer.jsp"></c:import>
                <div class="content-backdrop fade"></div>
            </div>
            </div>
        </div>
    <div class="layout-overlay layout-menu-toggle"></div>
</div>

<script src="/vendor/libs/jquery/jquery.js"></script>
<script src="/vendor/libs/popper/popper.js"></script>
<script src="/vendor/js/bootstrap.js"></script>
<script src="/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
<script src="/vendor/js/menu.js"></script>
<script src="/js/main.js"></script>
<script src="/js/member/member_mypage.js"></script>

<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>


</body>
</html>