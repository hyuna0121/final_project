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
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css">

    <script src="/vendor/js/helpers.js"></script>
    <script src="/js/config.js"></script>
    
<style>
    :root {
        --fc-border-color: #eceef1;        /* 연한 회색 테두리 */
        --fc-button-text-color: #697a8d;   /* 버튼 글씨색 */
        --fc-button-bg-color: rgba(67, 89, 113, 0.05); /* 버튼 배경 (연한 회색) */
        --fc-button-border-color: transparent; /* 버튼 테두리 없애기 */
        --fc-button-hover-bg-color: rgba(67, 89, 113, 0.15); /* 호버 시 배경 */
        --fc-button-hover-border-color: transparent;
        --fc-button-active-bg-color: #696cff; /* 활성화(오늘/월) 버튼 배경 */
        --fc-button-active-border-color: #696cff;
        --fc-today-bg-color: rgba(105, 108, 255, 0.04); /* 오늘 날짜 배경 */
        --fc-neutral-bg-color: #f5f5f9;    /* 요일 헤더 배경 */
    }

    .fc {
        font-family: 'Public Sans', sans-serif;
        color: #566a7f;
    }

    .fc .fc-button {
        box-shadow: none;
        font-weight: 600;
        padding: 0.4rem 0.8rem;
        border-radius: 0.375rem; /* 둥근 모서리 */
        text-transform: capitalize; /* 첫 글자 대문자 */
    }
    
    .fc .fc-button-primary:not(:disabled).fc-button-active,
    .fc .fc-button-primary:not(:disabled):active {
        color: #ffffff;
    }

    .fc .fc-toolbar-title {
        font-size: 1.25rem;
        font-weight: 700;
        margin-bottom: 0;
    }

    .fc .fc-col-header-cell {
        padding: 10px 0;
        border: none; 
        background-color: var(--fc-neutral-bg-color);
    }
    
    .fc .fc-col-header-cell-cushion {
        color: #a1acb8;
        font-weight: 600;
        text-decoration: none;
    }

    .fc .fc-daygrid-day-number {
        padding: 8px 12px;
        text-decoration: none;
        color: inherit;
    }
    
    .fc .fc-day-sun .fc-daygrid-day-number { color: #ff3e1d; }
    .fc .fc-day-sat .fc-daygrid-day-number { color: #007bff; }

    .fc-event {
        cursor: pointer;
        border: none;
        padding: 3px 6px;
        margin-bottom: 3px;
        border-radius: 4px;
        font-size: 0.8rem;
        font-weight: 500;
    }
    
    .fc-scroller::-webkit-scrollbar {
        width: 0px;
        background: transparent;
    }
    .fc .fc-daygrid-day-frame {
        min-height: 105px;
    }
</style>
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

<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');

        var calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            locale: 'ko',
            height: 'auto', // 높이 자동
            contentHeight: 'auto', // 내용물 높이 자동
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,listMonth'
            },
            dayMaxEvents: true, // 이벤트 많으면 +more 표시
            events: [
                { title: '출근 (08:50)', start: '2025-12-02', color: '#8592a3', textColor: '#fff' },
                { title: '연차 휴가', start: '2025-12-12', color: '#696cff', textColor: '#fff' },
                { title: '지각 (09:15)', start: '2025-12-20', color: '#ffab00', textColor: '#fff' },
                // 성탄절: 배경색 + 글씨 꼼수 (두 개 겹치기)
                { title: ' ', start: '2025-12-25', display: 'background', color: '#ff3e1d' }, 
                { title: '성탄절', start: '2025-12-25', color: 'transparent', textColor: '#ff3e1d' }
            ]
        });

        calendar.render();
    });
</script>

</body>
</html>