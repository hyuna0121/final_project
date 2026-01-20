<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link rel="stylesheet" href="/css/notification/notification.css" />

<style>
/* 1. 헤더 전체 스타일: 다우오피스 특유의 플랫하고 깨끗한 디자인 */
#layout-navbar {
    background-color: #ffffff !important;
    border-bottom: 1px solid #e1e4e8 !important;
    box-shadow: none !important; /* 그림자 제거로 모던함 강조 */
    height: 64px;
    padding: 0 1.5rem;
}

/* 2. 날짜 및 시간 영역 */
.header-datetime {
    font-family: 'Segoe UI', 'Pretendard', sans-serif;
    color: #4b4b4b;
    border-right: 1px solid #f0f0f0;
    padding-right: 15px;
    margin-right: 15px;
}
#date { font-size: 0.9rem; font-weight: 500; color: #777; }
#headerClock { font-size: 1rem; font-weight: 700; color: #333; }

/* 3. 출퇴근 버튼: 다우오피스 특유의 둥근 사각형 + 파스텔톤 */
.header-actions .btn {
    border-radius: 4px !important;
    height: 34px;
    padding: 0 15px !important;
    transition: all 0.2s ease;
    border: 1px solid transparent !important;
}

#inCommute {
    background-color: #ebf9f1 !important; /* 연한 연두 */
    color: #28c76f !important;
}
#inCommute:hover { background-color: #d8f5e5 !important; }

#outCommute {
    background-color: #f8f9fa !important; /* 연한 회색 */
    color: #697a8d !important;
    border-color: #e6e8eb !important;
}
#outCommute:hover { background-color: #f1f2f4 !important; }

/* 4. 알림 및 프로필 */
.nav-link i.bx-bell { color: #697a8d; }
.profile_img img { 
    border: 1px solid #eee; 
    padding: 2px;
    background: #fff;
}
.navbar-nav .fw-semibold {
    font-size: 0.9rem;
    color: #444;
}

/* 드롭다운 메뉴 스타일 최적화 */
.dropdown-menu {
    border: 1px solid #dbe0e6;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    border-radius: 6px;
}
</style>

<nav
  class="layout-navbar navbar navbar-expand-xl navbar-detached align-items-center bg-navbar-theme"
  id="layout-navbar"
>
  <div class="navbar-nav-right d-flex align-items-center" id="navbar-collapse">

   <div class="navbar-nav align-items-center header-datetime">
      <span class="date" id="date" ></span>
      <div style="width: 4px;height: 2px;"></div>
      <li class="nav-item lh-1">
          <span id="headerClock" class="header-clock">Loading...</span>
      </li>
    </div>

      <sec:authentication property="principal.member" var="Info"/>
      <sec:authorize access="!hasAnyRole('STORE')">
        <div class="header-actions d-flex gap-2">
              <button id="inCommute" class="btn btn-sm d-flex align-items-center gap-1 fw-bold">
                  <i class='bx bx-log-in-circle fs-5'></i>
                  <span style="font-size: 0.85rem;">출근</span>
              </button>

              <button id="outCommute" class="btn btn-sm d-flex align-items-center gap-1 fw-bold">
                  <i class='bx bx-log-out-circle fs-5'></i>
                  <span style="font-size: 0.85rem;">퇴근</span>
              </button>
           </div>
      </sec:authorize>

    <ul class="navbar-nav flex-row align-items-center ms-auto">
		<li class="nav-item dropdown me-2">
		  <a class="nav-link dropdown-toggle hide-arrow position-relative"
		     href="#"
		     data-bs-toggle="dropdown">
		    <i class="bx bx-bell bx-sm"></i>
		    <span class="badge bg-danger rounded-pill position-absolute"
		          id="notificationBadge"
		          style="top: 0; right: 0; font-size: 0.65rem; display:none;">
		    </span>
		  </a>
		
		  <ul class="dropdown-menu dropdown-menu-end p-2"
		      style="width: 380px;"
		      id="notificationDropdown">
		    <li class="dropdown-header fw-bold mb-2">알림</li>
		    <ul id="notificationList" class="notification-list"></ul>
		    <li><hr class="dropdown-divider"></li>
		    <li>
		      <button class="dropdown-item text-center fw-bold text-primary"
		              data-bs-toggle="modal"
		              data-bs-target="#notificationModal">
		        전체 알림 보기
		      </button>
		    </li>
		  </ul>
		</li>

      <div class="profile_img">
	      	<input type="hidden" id="loggedInMemberId" value="${Info.memberId}">
            <c:choose>
                <c:when test="${empty Info.memProfileSavedName}">
                    <img src="/fileDownload/profile?fileSavedName=default_img.jpg"
                        alt="user-avatar" 
                        class="d-block object-fit-cover rounded-circle"
                        id="headerProfileImage" 
                        style="width: 32px; height: 32px;">
                </c:when>
                <c:otherwise>
                    <img src="/fileDownload/profile?fileSavedName=${Info.memProfileSavedName}"
                        alt="user-avatar" 
                        class="d-block object-fit-cover rounded-circle"
                        id="headerProfileImage" 
                        style="width: 32px; height: 32px;">
                </c:otherwise>
            </c:choose>
      </div>
      
      <li class="nav-item dropdown ms-2">
        <a class="nav-link dropdown-toggle hide-arrow" href="#" data-bs-toggle="dropdown">
          <span class="fw-semibold">
          	${Info.memName}님 
          </span>
          <i class='bx bx-chevron-down ms-1 text-muted' style="font-size: 1rem;"></i>
        </a>
        <ul class="dropdown-menu dropdown-menu-end">
          <li><a class="dropdown-item" href="/member/AM_member_detail">내정보</a></li>
          <li><a class="dropdown-item" href="/member/logout">로그아웃</a></li>
        </ul>
      </li>

    </ul>
  </div>
</nav>

<div id="toast-container"></div>
<script src="/vendor/libs/jquery/jquery.js"></script>
<script type="text/javascript" src="/js/member/header.js"></script>

<div class="modal fade" id="notificationModal">
  <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
    <div class="modal-content notification-modal">
      <div class="modal-header notification-modal-header">
        <h5 class="modal-title"><i class="bx bx-bell me-2"></i> 알림 센터</h5>
        <button class="btn-close" data-bs-dismiss="modal"></button>
      </div>
		<div class="modal-body notification-modal-body">
		  <div class="notification-tabs">
		    <button data-filter="ALL" class="active">전체</button>
		    <button data-filter="UNREAD">안읽음</button>
		    <button data-filter="READ">읽음</button>
		  </div>
		  <div class="notification-list-wrapper">
		    <ul id="modalNotificationList" class="notification-list modal-list"></ul>
		  </div>
		</div>
      <div class="modal-footer notification-modal-footer">
        <button class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="changePasswordModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalCenterTitle">비밀번호 변경</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="modalMemberId">
                <div class="row">
                    <div class="col mb-3">
                        <label for="nowPassword" class="form-label">현재 비밀번호</label>
                        <input type="password" id="nowPassword" class="form-control" placeholder="현재 비밀번호를 입력하세요">
                    </div>
                </div>
                <div class="row">
                    <div class="col mb-3">
                        <label for="newPassword" class="form-label">새 비밀번호</label>
                        <input type="password" id="newPassword" class="form-control" placeholder="새로운 비밀번호">
                    </div>
                </div>
                <div class="row">
                    <div class="col mb-0">
                        <label for="confirmPassword" class="form-label">새 비밀번호 확인</label>
                        <input type="password" id="confirmPassword" class="form-control" placeholder="새로운 비밀번호 확인">
                        <div id="pwErrorMsg" class="form-text text-danger mt-1" style="display:none;"></div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="submitPasswordChange()">변경 저장</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script type="text/javascript" src="/js/notification/notification.js"></script>
<script type="text/javascript" src="/js/notification/notification-realtime.js"></script>