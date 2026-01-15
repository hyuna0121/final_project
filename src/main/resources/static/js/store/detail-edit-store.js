function formatTime(timeStr) {
    if (!timeStr) return '';

    const [hour, minute] = timeStr.split(':');
    let h = parseInt(hour, 10);
    const ampm = h >= 12 ? '오후' : '오전';
    h = h % 12;
    h = h ? h : 12;
    const m = minute.length < 2 ? '0' + minute : minute;
    return `${ampm} ${h < 10 ? '0' + h : h}:${m}`;
}

document.addEventListener('DOMContentLoaded', function() {
    const btnEditInfo = document.getElementById('btnEditInfo');
    const btnText = document.getElementById('btnText');
    const btnIcon = document.getElementById('btnIcon');

    // Time
    const viewTime = document.getElementById('viewTime');
    const editTime = document.getElementById('editTime');
    const inputStartTime = document.getElementById('inputStartTime');
    const inputCloseTime = document.getElementById('inputCloseTime');
    const timeTextSpan = viewTime.querySelector('span');

    btnEditInfo.addEventListener('click', function() {
        const isViewMode = editTime.classList.contains('d-none');
        if (isViewMode) {
            viewTime.classList.add('d-none');
            editTime.classList.remove('d-none');

            btnEditInfo.classList.replace('btn-outline-warning', 'btn-primary');
            btnText.textContent = '저장 완료';
            btnIcon.classList.replace('bx-edit-alt', 'bx-check');
        } else {
            const newStartTime = inputStartTime.value;
            const newCloseTime = inputCloseTime.value;
            const storeId = document.getElementById('storeId').value;

            const requestData = {
                storeId: storeId,
                storeStatus: null,
                storeStartTime: newStartTime,
                storeCloseTime: newCloseTime
            };

            fetch('/store/updateTime', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(requestData),
            })
            .then(response => {
                if (response.ok) return response.json();
                throw new Error('수정 중 오류가 발생했습니다.');
            })
            .then(data => {
                if (data.status === 'error') {
                    alert(result.message);
                    return;
                } else if (data.status === 'fail') {
                    alert("해당 가맹점 정보를 수정할 권한이 없습니다.");
                    return;
                }

                const formattedStart = formatTime(newStartTime);
                const formattedClose = formatTime(newCloseTime);
                timeTextSpan.textContent = `${formattedStart} ~ ${formattedClose}`;

                editTime.classList.add('d-none');
                viewTime.classList.remove('d-none');

                btnEditInfo.classList.replace('btn-primary', 'btn-outline-warning');
                btnText.textContent = '영업시간 변경';
                btnIcon.classList.replace('bx-check', 'bx-edit-alt');

                alert('가맹점 정보가 수정되었습니다.');
            })
            .catch(error => {
                alert('가맹점 정보수정에 실패했습니다.');
            });
        }
    });
});