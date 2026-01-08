<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<nav
  class="layout-navbar  navbar navbar-expand-xl navbar-detached align-items-center bg-navbar-theme"
  id="layout-navbar"
>

  <div class="navbar-nav-right d-flex align-items-center" id="navbar-collapse">

   <!-- ⏰ 날짜 / 시간 -->
    <div class="navbar-nav align-items-center header-datetime">
      <span class="date" id="date" ></span>
      <div style="width: 4px;height: 2px;"></div>
      <li class="nav-item lh-1 me-3">
          <span id="headerClock" class="header-clock">Loading...</span>
      </li>
    </div>

    <!-- 🟣 출근 / 퇴근 -->
	<div class="header-actions d-flex gap-2">
          <button id="inCommute" class="btn btn-sm d-flex align-items-center gap-1 px-2 fw-bold" 
                  style="background-color: #e8fadf; color: #28c76f; border: none; border-radius: 6px;">
              <i class='bx bx-log-in-circle fs-5'></i> 
              <span style="font-size: 0.85rem;">출근</span>
          </button>
        	
          <button id="outCommute" class="btn btn-sm d-flex align-items-center gap-1 px-2 fw-bold" 
                  style="background-color: #f2f2f2; color: #697a8d; border: none; border-radius: 6px;">
              <i class='bx bx-log-out-circle fs-5'></i> 
              <span style="font-size: 0.85rem;">퇴근</span>
          </button>
       </div>

    
    <!-- 오른쪽 영역 -->
    <ul class="navbar-nav flex-row align-items-center">
      <!-- 🔔 알림 -->
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle hide-arrow" href="#" data-bs-toggle="dropdown">
          <i class="bx bx-bell bx-sm"></i>
          <c:if test="${notificationCount > 0}">
            <span class="badge bg-danger rounded-pill badge-notifications">
              ${notificationCount}
            </span>
          </c:if>
        </a>
        <ul class="dropdown-menu dropdown-menu-end">
          <li class="dropdown-item">미지급 결재 요청</li>
          <li class="dropdown-item">발주 승인 대기</li>
        </ul>
      </li>

      <!-- 👤 사용자 -->
      
          <sec:authentication property="principal.member" var="Info"/>
      <div class="profile_img">
	      	<input type="hidden" id="loggedInMemberId" value="${Info.memberId}">
            <c:choose>
                <c:when test="${empty Info.memProfileSavedName}">
                    <img src="/fileDownload/profile?fileSavedName=default_img.jpg"
                        alt="user-avatar" 
                        class="d-block object-fit-cover rounded-circle"
                        id="headerProfileImage" 
                        style="width: 32px; height: 32px; border: 1px solid #eee;">
                </c:when>
                <c:otherwise>
                    <img src="/fileDownload/profile?fileSavedName=${Info.memProfileSavedName}"
                        alt="user-avatar" 
                        class="d-block object-fit-cover rounded-circle"
                        id="headerProfileImage" 
                        style="width: 32px; height: 32px; border: 1px solid #eee;">
                </c:otherwise>
                
                
                
            </c:choose>
          </div>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle hide-arrow" href="#" data-bs-toggle="dropdown">
          <span class="fw-semibold">
          	${Info.memName}님 
          </span>
        </a>
        <ul class="dropdown-menu dropdown-menu-end">
          <li>
            <a class="dropdown-item" href="/member/logout">로그아웃</a>
          </li>
        </ul>
      </li>

    </ul>
  </div>
</nav>
<script src="/vendor/libs/jquery/jquery.js"></script>
<script type="text/javascript" src="/js/member/header.js"></script>

