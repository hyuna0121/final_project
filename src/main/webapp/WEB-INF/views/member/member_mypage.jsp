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

            <div class="content-wrapper d-flex flex-column">
                <div class="container-xxl flex-grow-1 container-p-y" style="padding-top: 3rem !important;">

                    <div class="card shadow-sm">
                        
                        <div class="card-header border-bottom d-flex justify-content-between align-items-center py-3">
                            
                            <div class="d-flex align-items-center">
                                <button type="button" class="btn btn-outline-secondary btn-sm me-3" id="btnToday">Today</button>
                                
                                <div class="d-flex align-items-center gap-2">
                                    <button type="button" class="btn btn-icon btn-sm btn-text-secondary rounded-pill" id="btnPrev">
                                        <i class='bx bx-chevron-left fs-4'></i>
                                    </button>
                                    
                                    <h4 class="mb-0 fw-bold text-dark mx-2" id="calendarTitle" style="min-width: 140px; text-align: center;">
                                        Loading...
                                    </h4>
                                    
                                    <button type="button" class="btn btn-icon btn-sm btn-text-secondary rounded-pill" id="btnNext">
                                        <i class='bx bx-chevron-right fs-4'></i>
                                    </button>
                                </div>
                            </div>

                            <div class="btn-group" role="group" aria-label="View Toggle">
                                <button type="button" class="btn btn-outline-primary" id="btnShowList">
                                    <i class='bx bx-list-ul me-1'></i>리스트
                                </button>
                                
                                <button type="button" class="btn btn-primary active" id="btnShowCalendar">
                                    <i class='bx bx-calendar me-1'></i>달력
                                </button>
                            </div>
                        </div>

                        <div class="card-body p-4">
                            
                            <div id="calendarWrapper">
                                <div id='calendar'></div> 
                            </div>

                            <div id="listWrapper" style="display: none;">
							    <div class="table-responsive text-nowrap">
							        <table class="table table-hover table-bordered align-middle">
							            <thead class="table-light">
							                <tr>
							                    <th class="text-center" style="width: 15%;">날짜</th>
							                    <th class="text-center" style="width: 12%;">구분</th>
							                    <th class="text-center" style="width: 22%;">시간 / 차감</th>
							                    <th class="ps-4">상세 내역</th>
							                </tr>
							            </thead>
							            <tbody id="attendanceListBody">
							                </tbody>
							        </table>
							    </div>
							</div>

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
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>
<script src="/js/member/member_mypage.js"></script>

</body>
</html>