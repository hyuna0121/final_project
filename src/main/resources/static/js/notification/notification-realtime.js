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
	console.log("🔥 onReceiveNotification payload:", notification);
	console.log("🔥 keys:", Object.keys(notification));
	console.log("🔥 notificationContent:", notification.notificationContent);

    showToast(notification.notificationContent);
    increaseNotificationBadge();
    prependNotification(notification);
}


function showToast(message) {
    const container = document.getElementById('toast-container');
    const toast = document.createElement('div');

    toast.className = 'toast';
    toast.innerText = message;

    container.appendChild(toast);

    setTimeout(() => toast.classList.add('show'), 10);

    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 300);
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

    const li = document.createElement("li");
    li.innerHTML = `
        <a class="dropdown-item p-2 rounded mb-2"
           style="background:#f8f9ff;">
            <div class="fw-bold">${n.notificationTitle}</div>
            <small class="text-muted">${n.notificationContent}</small>
        </a>
    `;

    li.onclick = () => {
        fetch(`/api/notifications/${n.notificationId}/read`, { method: "PATCH" });
        location.href = n.notificationLink;
    };

    list.prepend(li);
}
