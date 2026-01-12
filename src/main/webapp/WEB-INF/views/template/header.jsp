<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<link rel="stylesheet" href="/css/notification/notification.css" />

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
		  <a class="nav-link dropdown-toggle hide-arrow position-relative"
		     href="#"
		     data-bs-toggle="dropdown">
		
		    <i class="bx bx-bell bx-sm"></i>
		
		    <!-- 🔔 안읽은 알림 개수 -->
		    <span class="badge bg-danger rounded-pill position-absolute"
		          id="notificationBadge"
		          style="top: 0; right: 0; font-size: 0.65rem; display:none;">
		    </span>
		  </a>
		
		  <!-- 🔔 알림 드롭다운 -->
		  <ul class="dropdown-menu dropdown-menu-end p-2"
		      style="width: 380px;"
		      id="notificationDropdown">
		
		    <!-- 헤더 -->
		    <li class="dropdown-header fw-bold mb-2">
		      알림
		    </li>
		
		    <li id="notificationList"></li>
		
		    <li><hr class="dropdown-divider"></li>
		
		    <!-- 전체 알림 보기 -->
		    <li>
		      <button class="dropdown-item text-center fw-bold text-primary"
		              data-bs-toggle="modal"
		              data-bs-target="#notificationModal">
		        전체 알림 보기
		      </button>
		    </li>
		
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
<div id="toast-container"></div>
<script src="/vendor/libs/jquery/jquery.js"></script>
<script type="text/javascript" src="/js/member/header.js"></script>
<!-- 🔔 전체 알림 모달 -->
<div class="modal fade" id="notificationModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg">
    <div class="modal-content">

      <!-- 모달 헤더 -->
      <div class="modal-header">
        <h5 class="modal-title d-flex align-items-center">
          <i class="bx bx-bell me-2"></i> 알림 센터
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <!-- 모달 바디 -->
      <div class="modal-body">

        <!-- 필터 -->
        <div class="btn-group mb-3" role="group">
          <button type="button" class="btn btn-outline-primary active">
            전체
          </button>
          <button type="button" class="btn btn-outline-primary">
            안읽음
          </button>
          <button type="button" class="btn btn-outline-primary">
            읽음
          </button>
        </div>

        <!-- 알림 리스트 -->
        <div class="list-group">

          <!-- 안읽음 -->
          <a href="#"
             class="list-group-item list-group-item-action fw-bold border-start border-4 border-primary"
             style="background-color:#f8f9ff;">
            <div class="d-flex justify-content-between">
              <div>
                결재 요청이 도착했습니다
                <div class="small text-muted">
                  결재 문서 A-1023 · 5분 전
                </div>
              </div>
              <span class="badge bg-primary">NEW</span>
            </div>
          </a>

          <!-- 읽음 -->
          <a href="#"
             class="list-group-item list-group-item-action">
            <div>
              발주가 승인되었습니다
              <div class="small text-muted">
                발주 번호 B-5581 · 어제
              </div>
            </div>
          </a>

          <a href="#"
             class="list-group-item list-group-item-action">
            <div>
              교육 수료 기한이 임박했습니다
              <div class="small text-muted">
                필수 교육 · 2026-01-01
              </div>
            </div>
          </a>

        </div>
      </div>

      <!-- 모달 푸터 -->
      <div class="modal-footer">
        <button type="button"
                class="btn btn-secondary"
                data-bs-dismiss="modal">
          닫기
        </button>
      </div>

    </div>
  </div>
</div>

<!-- WebSocket -->
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>


<script type="text/javascript" src="/js/notification/notification.js"></script>
<script type="text/javascript" src="/js/notification/notification-realtime.js"></script>
