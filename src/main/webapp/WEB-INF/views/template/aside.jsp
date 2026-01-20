<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">


<!-- Menu -->
<aside id="layout-menu" class="layout-menu menu-vertical menu bg-menu-theme">
<div class="app-brand demo" style="height: 80px;">
  <a href="javascript:void(0);" class="app-brand-link">
    <span class="app-brand-logo demo">
      <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#696cff" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <path d="M18 8h1a4 4 0 0 1 0 8h-1"></path>
        <path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path>
        <line x1="6" y1="1" x2="6" y2="4"></line>
        <line x1="10" y1="1" x2="10" y2="4"></line>
        <line x1="14" y1="1" x2="14" y2="4"></line>
      </svg>
    </span>
    <span class="app-brand-text demo menu-text fw-bolder ms-2" style="text-transform: uppercase; letter-spacing: 1px; font-size: 1.4rem; color: #566a7f;">
      CAFE <span style="color: #696cff;">CORE</span>
    </span>
  </a>
  <a href="javascript:void(0);" class="layout-menu-toggle menu-link text-large ms-auto d-block d-xl-none">
    <i class="bx bx-chevron-left bx-sm align-middle"></i>
  </a>
</div>
<!-- =====  -->

  <div class="menu-inner-shadow"></div>

  <ul class="menu-inner py-1">
    <!-- Dashboard -->
    <li class="menu-item">
      <a href="/member/member_mypage" class="menu-link">
        <i class="menu-icon tf-icons bx bx-home-circle"></i>
        <div data-i18n="Analytics">HOME</div>
      </a>
    </li>


    <!-- Layouts -->
    <li class="menu-header small text-uppercase">
      <span class="menu-header-text">업무</span>
    </li>
    <!-- 물품 등록 -->
    <li class="menu-item">
      <a href="javascript:void(0);" class="menu-link menu-toggle">
        <i class="menu-icon tf-icons bx bx-coffee"></i>
        <div data-i18n="Account Settings">원재료</div>
      </a>
      <ul class="menu-sub">
        <li class="menu-item">
          <a href="/item/list" class="menu-link">
            <div data-i18n="Notifications">원재료검색</div>
          </a>
        </li>
        <li class="menu-item">
          <a href="/item/priceDetail" class="menu-link">
            <div data-i18n="Notifications">단가조회</div>
          </a>
        </li>
        <li class="menu-item">
          <a href="/vendor/list" class="menu-link">
            <div data-i18n="Notifications">거래처</div>
          </a>
        </li>
      </ul>
    </li>
    <!-- 본사 발주 -->
    <li class="menu-item">
      <a href="javascript:void(0);" class="menu-link menu-toggle">
        <i class="menu-icon tf-icons bx bx-task"></i>
        <div data-i18n="Misc">발주</div>
      </a>
      <ul class="menu-sub">
        <li class="menu-item">
          <a href="/order/request" class="menu-link">
            <div data-i18n="Error">발주요청</div>
          </a>
        </li>
        <li class="menu-item">
          <a href="/order/approval" class="menu-link">
            <div data-i18n="Under Maintenance">발주승인</div>
          </a>
        </li>
        <li class="menu-item">
          <a href="/order/receive" class="menu-link">
            <div data-i18n="Under Maintenance">입고</div>
          </a>
        </li>
        <li class="menu-item">
          <a href="/order/release" class="menu-link">
            <div data-i18n="Under Maintenance">출고</div>
          </a>
        </li>
        <!-- 제고 -->
        <li class="menu-item">
          <a href="/stock/stock" class="menu-link">
            <div data-i18n="Under Maintenance">재고</div>
          </a>
        </li>
      </ul>
    </li>
    <li class="menu-item">
      <a href="javascript:void(0)" class="menu-link menu-toggle">
        <i class='menu-icon tf-icons bx bx-receipt'></i>
        <div>채권</div>
      </a>
      <ul class="menu-sub">
       <li class="menu-item">
         <a href="/receivable/receivable" class="menu-link">
           <div>미수금 목록</div>
         </a>
       </li>
       <li class="menu-item">
         <a href="/receivable/vendor" class="menu-link">
           <div>미지급금 목록</div>
         </a>
       </li>
      </ul>
    </li>
    <!-- 가맹점 -->
    <li class="menu-item">
      <a href="javascript:void(0);" class="menu-link menu-toggle">
        <i class="menu-icon tf-icons bx bx-store"></i>
        <div data-i18n="Misc">가맹점</div>
      </a>
      <ul class="menu-sub">
        <li class="menu-item">
          <a href="/store/list" class="menu-link">
            <div data-i18n="Error">목록</div>
          </a>
        </li>
        <li class="menu-item">
          <a href="/store/contract/list" class="menu-link">
            <div data-i18n="Error">계약</div>
          </a>
        </li>
        <li class="menu-item">
          <a href="/store/voc/list" class="menu-link">
            <div data-i18n="Under Maintenance">VOC</div>
          </a>
        </li>
        <li class="menu-item">
          <a href="/store/qsc/list" class="menu-link">
            <div data-i18n="Under Maintenance">QSC</div>
          </a>
        </li>
      </ul>
    </li>

    <!-- 인사관리 -->
    <li class="menu-header small text-uppercase">
	    <div data-i18n="Misc">사원</div>
    </li>
    <li class="menu-item">
      <a href="javascript:void(0)" class="menu-link menu-toggle">
        <i class="menu-icon tf-icons bx bx-buildings"></i>
        <div data-i18n="User interface">사원</div>
      </a>
      <ul class="menu-sub">
        <li class="menu-item">
          <a href="/member/AM_group_chart" class="menu-link">
             <div data-i18n="Text Divider">부서 목록</div>
          </a>
        </li>
        <li class="menu-item">
          <a href="/member/admin_holiday_list" class="menu-link">
            <div data-i18n="Accordion">휴무일 목록</div>
          </a>
        </li>
       </ul>
    </li>
    
    <!-- 관리자관리 -->
  	<sec:authorize access="hasAnyRole('MASTER')">
	    <li class="menu-header small text-uppercase">
		    <div data-i18n="Misc">사원</div>
	    </li>
	    <li class="menu-item">
	      <a href="javascript:void(0)" class="menu-link menu-toggle">
	        <i class="menu-icon tf-icons bx bx-user"></i>
	        <div data-i18n="User interface">관리자</div>
	      </a>
		  <ul class="menu-sub">
		       <li class="menu-item">
		         <a href="/member/admin_member_list" class="menu-link">
		           <div data-i18n="Perfect Scrollbar">사원 목록</div>
		         </a>
		       </li>
	       
		       <li class="menu-item">
		         <a href="/member/admin_login_history" class="menu-link">
		           <div data-i18n="Text Divider">로그인 이력 목록</div>
		         </a>
		       </li>
	      </ul>
	     </li>
     </sec:authorize>

  </ul>
</aside>

<script>
  document.addEventListener("DOMContentLoaded", function() {
      const currentPath = window.location.pathname;

      const menuLinks = document.querySelectorAll('.layout-menu .menu-link');

      menuLinks.forEach(link => {
          const linkPath = link.getAttribute('href');

          if (linkPath && linkPath !== 'javascript:void(0);' && linkPath !== '') {
              // 기본 경로 추출 (예: /store/qsc/list -> /store/qsc)
              const baseLinkPath = linkPath.split('?')[0]; // 쿼리스트링 제거
              const baseCurrentPath = currentPath.split('?')[0]; // 쿼리스트링 제거

              // 경로 세그먼트 비교 (depth 2까지)
              const linkSegments = baseLinkPath.split('/').filter(s => s);
              const currentSegments = baseCurrentPath.split('/').filter(s => s);

              // 최소 2단계 경로 일치 확인 (예: store/qsc)
              let isMatch = false;
              if (linkSegments.length >= 2 && currentSegments.length >= 2) {
                  if (linkSegments[0] === currentSegments[0] &&
                      linkSegments[1] === currentSegments[1]) {
                      isMatch = true;
                  }
              } else if (baseLinkPath === baseCurrentPath) {
                  isMatch = true;
              }

              if (isMatch) {
                  const parentLi = link.parentElement;
                  parentLi.classList.add('active');

                  const parentUl = parentLi.parentElement;
                  if (parentUl.classList.contains('menu-sub')) {
                      const grandParentLi = parentUl.parentElement;
                      grandParentLi.classList.add('active');
                      grandParentLi.classList.add('open');
                  }
              }
          }
      });
  });
</script>
<!-- / Menu -->