let stompClient = null;

document.addEventListener("DOMContentLoaded", function () {
    const memberId = document.getElementById("loggedInMemberId")?.value;
    console.log("👤 로그인 사용자 ID:", memberId);

    if (!memberId) {
        console.error("❌ memberId 없음 → WebSocket 연결 중단");
        return;
    }

    connectNotificationSocket(memberId);
});

function connectNotificationSocket(memberId) {
    console.log("🔌 WebSocket 연결 시도");

    const socket = new SockJS('/ws');
    stompClient = Stomp.over(socket);

    stompClient.connect({}, function () {
        console.log("✅ WebSocket 연결 성공");

		stompClient.subscribe(
		    '/user/sub/notification',
		    function (message) {
		        console.log("🔥 [JS] STOMP 메시지 수신 RAW =", message);
		        console.log("🔥 [JS] message.body =", message.body);

		        const notification = JSON.parse(message.body);
		        onReceiveNotification(notification);
		    }
		);
    });
}

function onReceiveNotification(notification) {

    showToast(notification);
    increaseNotificationBadge();
    prependNotification(notification);
}



function showToast(notification) {
    const container = document.getElementById("toast-container");

    const toast = document.createElement("div");
    toast.className = `toast show ${notification.notificationType?.toLowerCase() || 'voc'}`;

    toast.innerHTML = `
        <div class="toast-title">
            ${notification.notificationTitle}
        </div>
        <div class="toast-content">
            ${notification.notificationContent}
        </div>
    `;

    toast.onclick = () => {
        location.href = notification.notificationLink;
    };

    container.appendChild(toast);

    setTimeout(() => {
        toast.classList.remove("show");
        setTimeout(() => toast.remove(), 200);
    }, 3000);
}


function increaseNotificationBadge() {
    const badge = document.getElementById("notificationBadge");

    let count = parseInt(badge.textContent || "0");
    badge.textContent = count + 1;
    badge.style.display = "inline-block";
}



function prependNotification(n) {
    const list = document.getElementById("notificationList");

    const type = n.notificationType?.toLowerCase() || "voc";

    const iconMap = {
        voc: "bx-comment-detail",
        chat: "bx-chat",
        notice: "bx-info-circle"
    };

    const li = document.createElement("li");
    li.innerHTML = `
        <a class="dropdown-item notification-row ${type}">
            <div class="notification-icon">
                <i class="bx ${iconMap[type]}"></i>
            </div>
            <div class="notification-text">
                <div class="notification-title">${n.notificationTitle}</div>
                <div class="notification-desc">${n.notificationContent}</div>
            </div>
        </a>
    `;

    li.onclick = () => {
        fetch(`/api/notifications/${n.notificationId}/read`, { method: "PATCH" });
        location.href = n.notificationLink;
    };

    list.prepend(li);
}


