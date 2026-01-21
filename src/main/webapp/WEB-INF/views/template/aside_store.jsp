<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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
      <a href="/store/detail" class="menu-link">
        <i class="menu-icon tf-icons bx bx-store"></i>
        <div data-i18n="Analytics">HOME</div>
      </a>
    </li>

    <!-- Layouts -->
    <li class="menu-header small text-uppercase">
      <span class="menu-header-text">발주</span>
    </li>
    <li class="menu-item">
      <a href="/order/request" class="menu-link">
        <i class="menu-icon tf-icons bx bx-paper-plane"></i>
        <div data-i18n="Analytics">요청</div>
      </a>
    </li>
    <li class="menu-item">
      <a href="/order/approval" class="menu-link">
        <i class="menu-icon tf-icons bx bx-select-multiple"></i>
        <div data-i18n="Under Maintenance">발주 상태</div>
      </a>
    </li>
    <li class="menu-header small text-uppercase">
      <span class="menu-header-text">재고</span>
    </li>
    <li class="menu-item">
      <a href="/order/receive" class="menu-link">
        <i class="menu-icon tf-icons bx bx-log-in-circle"></i>
        <div data-i18n="Under Maintenance">입고</div>
      </a>
    </li>
    <li class="menu-item">
      <a href="/order/release" class="menu-link">
        <i class="menu-icon tf-icons bx bx-log-out-circle"></i>
        <div data-i18n="Under Maintenance">출고</div>
      </a>
    </li>
    <li class="menu-item">
      <a href="/stock/stock" class="menu-link">
      <i class="menu-icon tf-icons bx bxs-package"></i>
        <div data-i18n="Under Maintenance">재고</div>
      </a>
    </li>

    <li class="menu-header small text-uppercase">
      <span class="menu-header-text">가맹점</span>
    </li>
    <li class="menu-item">
      <a href="/store/voc/list" class="menu-link">
        <i class="menu-icon tf-icons bx bx-support"></i>
        <div data-i18n="Analytics">VOC</div>
      </a>
    </li>
    <li class="menu-item">
      <a href="/store/qsc/list" class="menu-link">
        <i class="menu-icon tf-icons bx bx-task"></i>
        <div data-i18n="Analytics">QSC</div>
      </a>
    </li>
    <li class="menu-item">
      <a href="/store/contract/list" class="menu-link">
        <i class="menu-icon tf-icons bx bx-file"></i>
        <div data-i18n="Analytics">계약 기록</div>
      </a>
    </li>
  </ul>
</aside>

<script>
  document.addEventListener("DOMContentLoaded", function() {
      // 1. 현재 페이지의 경로 가져오기 (쿼리 스트링 제외)
      const currentPath = window.location.pathname.split('?')[0];

      // 2. 모든 메뉴 아이템 가져오기
      const menuLinks = document.querySelectorAll('.layout-menu .menu-link');

      menuLinks.forEach(link => {
          const linkPath = link.getAttribute('href');
          // href가 없는 경우 건너뜀
          if (!linkPath || linkPath === 'javascript:void(0);') return;

          const parentLi = link.parentElement;

          // 3. 기존에 혹시 있을 active 제거 (초기화)
          parentLi.classList.remove('active');

          // 4. 활성화 로직 판별
          let isActive = false;

          if (linkPath === '/') {
              // HOME인 경우: 정확히 '/' 일 때만 활성화
              if (currentPath === '/') {
                  isActive = true;
              }
          } else {
              // 그 외 메뉴:
              // 예: 메뉴링크가 /store/voc/list 이고, 현재주소가 /store/voc/write 이면
              // /store/voc 부분이 일치하므로 활성화 처리

              // 비교를 위해 '/list' 같은 끝부분을 제거하고 디렉토리까지만 비교할 수도 있고,
              // 단순히 startsWith를 사용할 수도 있습니다.
              // 여기서는 사용자의 URL 구조(/store/voc/...)에 맞춰 경로 포함 여부를 확인합니다.

              // 링크 경로에서 '/list'를 제거하여 상위 경로 추출 (예: /store/voc/list -> /store/voc)
              const comparePath = linkPath.replace('/list', '');

              if (currentPath.startsWith(comparePath)) {
                  isActive = true;
              }
          }

          // 5. 조건이 맞으면 active 클래스 추가
          if (isActive) {
              parentLi.classList.add('active');

              // 만약 서브 메뉴(dropdown) 구조라면 상위 메뉴도 열어줌
              const parentUl = parentLi.parentElement;
              if (parentUl.classList.contains('menu-sub')) {
                  const grandParentLi = parentUl.parentElement;
                  grandParentLi.classList.add('active');
                  grandParentLi.classList.add('open');
              }
          }
      });
  });
</script>
<!-- / Menu -->