<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>

<html lang="ko" class="light-style layout-menu-fixed" dir="ltr" data-theme="theme-default" data-assets-path="/assets/" data-template="vertical-menu-template-free">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>나의 근태</title>
    
    <link rel="icon" type="image/x-icon" href="/assets/img/favicon/favicon.ico" />
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="/vendor/fonts/boxicons.css" />
    <link rel="stylesheet" href="/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="/vendor/css/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="/css/demo.css" />
    <link rel="stylesheet" href="/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
    
    <script src="/vendor/js/helpers.js"></script>
    <script src="/js/config.js"></script>

    <style>
        /* 헤더(Navbar) 스타일 보정 */
        .layout-navbar {
            height: 4rem; /* 헤더 높이 살짝 조정 */
            z-index: 1000; /* 항상 위에 */
        }
        .header-clock {
            font-size: 0.85rem;
            color: #697a8d;
            font-family: 'Courier New', monospace;
            font-weight: 600;
            margin-right: 15px;
        }
        
        /* 본문 스타일 */
        body { font-size: 0.9rem; }
        .card-body { padding: 1rem 1.25rem !important; }
        
        /* 필터 바 스타일 */
        .filter-bar {
            background: #fff;
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 6px 0 rgba(67, 89, 113, 0.12);
        }
        
        /* 캘린더 스타일 */
        .table-calendar th { text-align: center; background-color: #f5f5f9; padding: 0.6rem !important; }
        .table-calendar td { height: 100px !important; vertical-align: top; width: 14.28%; padding: 0.5rem !important; }
        .date-num { font-weight: bold; display: block; margin-bottom: 4px; font-size: 0.85rem;}
        .schedule-badge { display: block; margin-bottom: 2px; font-size: 0.75rem; padding: 2px 6px; border-radius: 4px; text-align: left; }
        .text-sun { color: #ff3e1d; }
        .text-sat { color: #007bff; }
    </style>
</head>

<body>
<div class="layout-wrapper layout-content-navbar">
    <div class="layout-container">
        
        <c:import url="/WEB-INF/views/template/aside.jsp"></c:import>

        <div class="layout-page">
            
            <nav class="layout-navbar container-xxl navbar navbar-expand-xl navbar-detached align-items-center bg-navbar-theme" id="layout-navbar">
                
                <div class="layout-menu-toggle navbar-nav align-items-xl-center me-3 me-xl-0 d-xl-none">
                    <a class="nav-item nav-link px-0 me-xl-4" href="javascript:void(0)">
                        <i class="bx bx-menu bx-sm"></i>
                    </a>
                </div>

                <div class="navbar-nav-right d-flex align-items-center" id="navbar-collapse">
                    
                    <div class="navbar-nav align-items-center">
                         <div class="nav-item d-flex align-items-center">
                            <span class="fw-bold fs-5"></span>
                         </div>
                    </div>

                    <ul class="navbar-nav flex-row align-items-center ms-auto">
                        
                        <li class="nav-item lh-1 me-3">
                            <span id="headerClock" class="header-clock">Loading...</span>
                        </li>

                        <li class="nav-item lh-1 me-3">
                            <div class="btn-group btn-group-sm">
                                <button type="button" class="btn btn-primary"><i class="bx bx-log-in-circle me-1"></i>출근</button>
                                <button type="button" class="btn btn-outline-secondary"><i class="bx bx-log-out-circle me-1"></i>퇴근</button>
                            </div>
                        </li>

                        <li class="nav-item me-3" style="border-left: 1px solid #d9dee3; height: 20px;"></li>

                        <li class="nav-item navbar-dropdown dropdown-user dropdown">
                            <a class="nav-link dropdown-toggle hide-arrow" href="javascript:void(0);" data-bs-toggle="dropdown">
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0 me-2">
                                        <div class="avatar avatar-online">
                                            <img src="/assets/img/avatars/1.png" alt class="w-px-40 h-auto rounded-circle" />
                                        </div>
                                    </div>
                                    <div class="flex-grow-1">
                                        <span class="fw-semibold d-block">김철수 님</span>
                                        <small class="text-muted">개발팀 / 대리</small>
                                    </div>
                                </div>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="#"><i class="bx bx-user me-2"></i>내 정보</a></li>
                                <li><div class="dropdown-divider"></div></li>
                                <li><a class="dropdown-item" href="#"><i class="bx bx-power-off me-2"></i>로그아웃</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </nav>
            <div class="content-wrapper">
                <div class="container-fluid flex-grow-1 container-p-y">
                    
                    <h4 class="fw-bold py-1 mb-3">
                        <span class="text-muted fw-light">마이페이지 /</span> 나의 근태
                    </h4>

                    <div class="filter-bar d-flex flex-wrap align-items-center justify-content-between gap-3">
                        <form class="d-flex align-items-center gap-2">
                            <div class="input-group input-group-sm" style="width: 160px;">
                                <span class="input-group-text"><i class='bx bx-calendar'></i></span>
                                <input class="form-control" type="month" value="2025-12" />
                            </div>
                            
                            <select class="form-select form-select-sm" style="width: 120px;">
                                <option value="">전체 상태</option>
                                <option value="normal">정상</option>
                                <option value="late">지각</option>
                            </select>

                            <button type="button" class="btn btn-primary btn-sm px-3">조회</button>
                        </form>

                        <div class="btn-group btn-group-sm">
                            <button type="button" class="btn btn-outline-primary active">캘린더</button>
                            <button type="button" class="btn btn-outline-secondary">리스트</button>
                        </div>
                    </div>

                    <div class="card shadow-sm">
                        <div class="card-body p-0">
                            <div class="table-responsive text-nowrap">
                                <table class="table table-bordered table-calendar mb-0">
                                    <thead>
                                        <tr class="text-center bg-light">
                                            <th class="text-sun">일</th>
                                            <th>월</th>
                                            <th>화</th>
                                            <th>수</th>
                                            <th>목</th>
                                            <th>금</th>
                                            <th class="text-sat">토</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><span class="date-num text-sun">1</span></td>
                                            <td><span class="date-num">2</span><span class="badge bg-label-secondary schedule-badge">08:50 - 18:00</span></td>
                                            <td><span class="date-num">3</span><span class="badge bg-label-secondary schedule-badge">08:55 - 18:05</span></td>
                                            <td><span class="date-num">4</span><span class="badge bg-label-secondary schedule-badge">08:50 - 18:00</span></td>
                                            <td><span class="date-num">5</span><span class="badge bg-label-secondary schedule-badge">08:50 - 18:00</span></td>
                                            <td><span class="date-num">6</span><span class="badge bg-label-secondary schedule-badge">08:45 - 18:00</span></td>
                                            <td><span class="date-num text-sat">7</span></td>
                                        </tr>
                                        <tr>
                                            <td><span class="date-num text-sun">8</span></td>
                                            <td><span class="date-num">9</span><span class="badge bg-label-secondary schedule-badge">08:50 - 18:00</span></td>
                                            <td><span class="date-num">10</span><span class="badge bg-label-secondary schedule-badge">08:55 - 18:00</span></td>
                                            <td><span class="date-num">11</span><span class="badge bg-label-secondary schedule-badge">08:50 - 18:00</span></td>
                                            <td><span class="date-num">12</span><span class="badge bg-primary schedule-badge">연차 휴가</span></td>
                                            <td><span class="date-num">13</span><span class="badge bg-label-secondary schedule-badge">08:55 - 18:00</span></td>
                                            <td><span class="date-num text-sat">14</span></td>
                                        </tr>
                                        <tr>
                                            <td><span class="date-num text-sun">15</span></td>
                                            <td><span class="date-num">16</span><span class="badge bg-label-secondary schedule-badge">08:50 - 18:00</span></td>
                                            <td><span class="date-num">17</span><span class="badge bg-label-secondary schedule-badge">08:50 - 18:00</span></td>
                                            <td><span class="date-num">18</span><span class="badge bg-label-secondary schedule-badge">08:50 - 18:00</span></td>
                                            <td><span class="date-num">19</span><span class="badge bg-label-secondary schedule-badge">08:50 - 18:00</span></td>
                                            <td class="bg-label-warning bg-opacity-10">
                                                <span class="date-num">20</span>
                                                <span class="badge bg-warning schedule-badge">지각 (09:15)</span>
                                            </td>
                                            <td><span class="date-num text-sat">21</span></td>
                                        </tr>
                                        <tr>
                                            <td><span class="date-num text-sun">22</span></td>
                                            <td>
                                                <span class="date-num">23</span>
                                                <span class="badge bg-label-secondary schedule-badge">08:50 - 18:00</span>
                                            </td>
                                            <td  style="background-color: #f0f2ff; border: 2px solid #696cff;"><span class="date-num">24</span>
                                                <span class="badge bg-success schedule-badge">출근: 08:55</span>
                                            <td><span class="date-num text-danger">25</span><span class="badge bg-label-danger schedule-badge">성탄절</span></td>
                                            <td><span class="date-num">26</span></td>
                                            <td><span class="date-num">27</span></td>
                                            <td><span class="date-num text-sat">28</span></td>
                                        </tr>
                                    </tbody>
                                </table>
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

<script>
    function updateClock() {
        const now = new Date();
        const timeString = now.toLocaleTimeString('ko-KR', { hour12: false });
        // 헤더에 있는 시계 ID (headerClock)
        const clock = document.getElementById('headerClock');
        if(clock) clock.innerText = timeString;
    }
    setInterval(updateClock, 1000);
    updateClock();
</script>

</body>
</html>