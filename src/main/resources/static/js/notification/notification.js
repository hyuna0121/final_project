/**
 * Notification JS (FIXED)
 */

let notificationPage = 0;
const notificationSize = 5;
let notificationLoading = false;
let notificationHasMore = true;

let modalPage = 0;
let modalHasMore = true;
let modalLoading = false;
let modalFilter = "ALL";

document.addEventListener("DOMContentLoaded", () => {
  loadUnreadCount();
  loadNotifications();
});

/* ================= 드롭다운 알림 ================= */

const notificationList = document.getElementById("notificationList");

notificationList.addEventListener("scroll", () => {
  const nearBottom =
    notificationList.scrollTop + notificationList.clientHeight >=
    notificationList.scrollHeight - 20;

  if (nearBottom) loadNotifications();
});

function loadNotifications() {
  if (notificationLoading || !notificationHasMore) return;
  notificationLoading = true;

  fetch(`/api/notifications?page=${notificationPage}&size=${notificationSize}`)
    .then(res => res.json())
    .then(data => {
      if (data.length === 0) {
        notificationHasMore = false;
        return;
      }
      data.forEach(n =>
        notificationList.appendChild(createNotificationItem(n))
      );
      notificationPage++;
    })
    .finally(() => notificationLoading = false);
}

/* ================= 모달 ================= */

const modalBody = document.querySelector(".notification-modal-body");

document
  .getElementById("notificationModal")
  .addEventListener("shown.bs.modal", () => {
    resetModal();
    loadModalNotifications();
  });

modalBody.addEventListener("scroll", () => {
  const nearBottom =
    modalBody.scrollTop + modalBody.clientHeight >=
    modalBody.scrollHeight - 30;

  if (nearBottom) loadModalNotifications();
});

function resetModal() {
  modalPage = 0;
  modalHasMore = true;
  modalLoading = false;
  document.getElementById("modalNotificationList").innerHTML = "";
}

function loadModalNotifications() {
  if (modalLoading || !modalHasMore) return;
  modalLoading = true;

  fetch(`/api/notifications?page=${modalPage}&size=10&filter=${modalFilter}`)
    .then(res => res.json())
    .then(data => {
      const list = document.getElementById("modalNotificationList");

      if (data.length === 0 && modalPage === 0) {
        renderEmptyModal();
        modalHasMore = false;
        return;
      }

      if (data.length === 0) {
        modalHasMore = false;
        return;
      }

      data.forEach(n => list.appendChild(createNotificationItem(n)));
      modalPage++;
    })
    .finally(() => modalLoading = false);
}

/* ================= 공통 ================= */


function createNotificationItem(n) {
	
	const li = document.createElement("li");
	
	const typeClass = n.notificationType
	  ? n.notificationType.toLowerCase()
	  : "voc";
	
	li.className = `notify-item ${typeClass} ${n.notificationReadYn === "N" ? "unread" : ""}`;
	
	let iconClass = "bx-message-rounded-detail"; // VOC 기본

	if (typeClass === "order") {
	  iconClass = "bx-package";
	} else if (typeClass === "reject") {
	  iconClass = "bx-error-circle";
	}


  li.innerHTML = `
	  <div class="notify-icon">
	    <i class="bx ${iconClass}"></i>
	  </div>
    <div class="notify-body">
      <div class="notify-header">
        <span class="notify-title">${n.notificationTitle}</span>
        <span class="notify-time">${timeAgo(n.notificationCreatedAt)}</span>
      </div>
      <div class="notify-desc">${n.notificationContent}</div>
    </div>
  `;

  li.addEventListener("click", async () => {
    if (n.notificationReadYn === "N") {
      try {
        await markNotificationAsRead(n.notificationId);
        n.notificationReadYn = "Y";
        li.classList.remove("unread");
        loadUnreadCount();
      } catch (e) {
        console.error("읽음 처리 실패", e);
      }
    }

    location.href = n.notificationLink;
  });

  return li;
}


function renderEmptyModal() {
  document.getElementById("modalNotificationList").innerHTML = `
    <li class="empty-notification">
      <i class="bx bx-bell-off"></i>
      <span>알림이 없습니다</span>
    </li>
  `;
}

function loadUnreadCount() {
  fetch("/api/notifications/unread-count")
    .then(res => res.json())
    .then(updateNotificationBadge);
}

function updateNotificationBadge(count) {
  const badge = document.getElementById("notificationBadge");
  badge.style.display = count > 0 ? "inline-block" : "none";
  badge.textContent = count || "";
}

function timeAgo(dateString) {
  const diff = (new Date() - new Date(dateString)) / 1000;
  if (diff < 60) return "방금 전";
  if (diff < 3600) return `${Math.floor(diff / 60)}분 전`;
  if (diff < 86400) return `${Math.floor(diff / 3600)}시간 전`;
  return `${Math.floor(diff / 86400)}일 전`;
}

/* ================= 탭 ================= */

document.querySelectorAll(".notification-tabs button").forEach(btn => {
  btn.addEventListener("click", () => {
    modalFilter = btn.dataset.filter;
    document.querySelectorAll(".notification-tabs button")
      .forEach(b => b.classList.remove("active"));
    btn.classList.add("active");
    resetModal();
    loadModalNotifications();
  });
});

function markNotificationAsRead(notificationId) {
  return fetch(`/api/notifications/${notificationId}/read`, {
    method: "PATCH"
  });
}
