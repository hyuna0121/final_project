/**
 * 
 */

let notificationPage = 0;
const notificationSize = 5;
let notificationLoading = false;
let notificationHasMore = true;

document.addEventListener("DOMContentLoaded", () => {
  notificationPage = 0;
  notificationHasMore = true;
  loadUnreadCount();
  loadNotifications();
});

const notificationList = document.getElementById("notificationList");

notificationList.addEventListener("scroll", () => {
  const nearBottom =
    notificationList.scrollTop +
    notificationList.clientHeight >=
    notificationList.scrollHeight - 20;

  if (nearBottom) {
    loadNotifications();
  }
});

function loadNotifications() {
	
	if(notificationLoading || !notificationHasMore) return;
	
	notificationLoading = true;
	
  fetch(`/api/notifications?page=${notificationPage}&size=${notificationSize}`)
    .then(res => {
		if(!res.ok) throw new Error("알림 조회 실패");
		return res.json()
	})
    .then(data => {
		
		if(data.length === 0){
			notificationHasMore = false;
			return;
		}
		
      renderNotifications(data);
	  notificationPage++;
    })
    .catch(err => console.error(err))
	.finally(() => {
		notificationLoading = false;
	});
}

function createNotificationItem(n) {
  const li = document.createElement("li");
  li.className = `notify-item ${n.notificationType.toLowerCase()} ${n.notificationReadYn === 'N' ? 'unread' : ''}`;

  li.innerHTML = `
    <div class="notify-signal"></div>
    <div class="notify-icon">
      <i class="bx bx-message-rounded-detail"></i>
    </div>

    <div class="notify-body">
      <div class="notify-header">
        <span class="notify-title">${n.notificationTitle}</span>
        <span class="notify-time">${timeAgo(n.notificationCreatedAt)}</span>
      </div>
      <div class="notify-desc">
        ${n.notificationContent}
      </div>
    </div>
  `;

  li.onclick = async () => {
    if (n.notificationReadYn === 'N') {
      await fetch(`/api/notifications/${n.notificationId}/read`, {
        method: "PATCH"
      });

      n.notificationReadYn = 'Y';

      li.classList.remove("unread");
      li.querySelector(".notify-signal")?.remove();

      updateNotificationBadgeAfterClick();
    }

    location.href = n.notificationLink;
  };


  return li;
}

function renderNotifications(notifications) {
  const list = document.getElementById("notificationList");

  notifications.forEach(n => {
    list.appendChild(createNotificationItem(n));
  });
}


function updateNotificationBadge(count) {
  const badge = document.getElementById("notificationBadge");
  if (!badge) return;

  const safeCount = Number.isInteger(count) && count > 0 ? count : 0;

  if (safeCount > 0) {
    badge.textContent = safeCount;
    badge.style.display = "inline-block";
  } else {
    badge.textContent = "";
    badge.style.display = "none";
  }
}



function timeAgo(dateString) {
  if (!dateString) return "";

  const now = new Date();
  const past = new Date(dateString);
  const diffMs = now - past;

  const seconds = Math.floor(diffMs / 1000);
  const minutes = Math.floor(seconds / 60);
  const hours   = Math.floor(minutes / 60);
  const days    = Math.floor(hours / 24);

  if (seconds < 60) return "방금 전";
  if (minutes < 60) return `${minutes}분 전`;
  if (hours < 24)   return `${hours}시간 전`;
  if (days < 7)     return `${days}일 전`;

  return past.toLocaleDateString();
}

function updateNotificationBadgeAfterClick() {
  const badge = document.getElementById("notificationBadge");
  if (!badge) return;

  const current = Number(badge.textContent);

  if (isNaN(current) || current <= 1) {
    badge.style.display = "none";
    badge.textContent = "";
  } else {
    badge.textContent = current - 1;
  }
}

function loadUnreadCount() {
  fetch("/api/notifications/unread-count")
    .then(res => res.json())
    .then(count => {
      updateNotificationBadge(count);
    })
    .catch(err => console.error("안읽은 알림 개수 조회 실패", err));
}
