let stompClient = null;

document.addEventListener("DOMContentLoaded", function () {
    const memberId = document.getElementById("loggedInMemberId")?.value;

    if (!memberId) {
        return;
    }

    connectNotificationSocket(memberId);
});

function connectNotificationSocket(memberId) {

    const socket = new SockJS('/ws');
    stompClient = Stomp.over(socket);

    stompClient.connect({}, function () {

		stompClient.subscribe(
		    '/user/sub/notification',
		    function (message) {

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
  const item = createNotificationItem(n);
  list.prepend(item);
}



