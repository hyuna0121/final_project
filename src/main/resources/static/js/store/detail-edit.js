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

    // Status
    const viewStatus = document.getElementById('viewStatus');
    const editStatus = document.getElementById('editStatus');
    const selectStatus = document.getElementById('selectStatus');
    const statusBadge = document.getElementById('statusBadge');

    // Time
    const viewTime = document.getElementById('viewTime');
    const editTime = document.getElementById('editTime');
    const inputStartTime = document.getElementById('inputStartTime');
    const inputCloseTime = document.getElementById('inputCloseTime');
    const timeTextSpan = viewTime.querySelector('span');

    btnEditInfo.addEventListener('click', function() {
        const isViewMode = editTime.classList.contains('d-none');
        const currentStatus = viewStatus.dataset.status;

        if (isViewMode) {
            viewTime.classList.add('d-none');
            editTime.classList.remove('d-none');
            viewStatus.classList.add('d-none');
            editStatus.classList.remove('d-none');

            btnEditInfo.classList.replace('btn-outline-warning', 'btn-primary');
            btnText.textContent = '저장 완료';
            btnIcon.classList.replace('bx-edit-alt', 'bx-check');

            selectStatus.innerHTML = '';
            selectStatus.disabled = false;

            let options = [];

            if (currentStatus == '오픈 준비') options = ['오픈 준비', '오픈', '폐업'];
            else if (currentStatus == '오픈') options = ['오픈', '폐업'];
            else if (currentStatus == '오픈 준비') {
                options = ['폐업'];
                selectStatus.disabled = true;
            }

            options.forEach(opt => {
                const optionEl = document.createElement('option');
                optionEl.value = opt;
                optionEl.textContent = opt;
                if (opt === currentStatus) optionEl.selected = true;
                selectStatus.appendChild(optionEl);
            });
        } else {
            const newStatus = selectStatus.value;
            const newStartTime = inputStartTime.value;
            const newCloseTime = inputCloseTime.value;
            const storeId = document.getElementById('storeId').value;

            const requestData = {
                storeId: storeId,
                storeStatus: newStatus,
                storeStartTime: newStartTime,
                storeCloseTime: newCloseTime
            };

            fetch('/store/updateStatus', {
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
                viewStatus.dataset.status = newStatus;
                statusBadge.textContent = newStatus;

                statusBadge.className = 'badge';
                if (newStatus === '오픈') statusBadge.classList.add('bg-label-info');
                else if (newStatus === '오픈 준비') statusBadge.classList.add('bg-label-warning');
                else statusBadge.classList.add('bg-label-danger');

                if (newStatus === '오픈') {
                    const formattedStart = formatTime(newStartTime);
                    const formattedClose = formatTime(newCloseTime);
                    timeTextSpan.textContent = `${formattedStart} ~ ${formattedClose}`;
                } else {
                    timeTextSpan.textContent = '-';
                }

                editTime.classList.add('d-none');
                viewTime.classList.remove('d-none');
                editStatus.classList.add('d-none');
                viewStatus.classList.remove('d-none');

                btnEditInfo.classList.replace('btn-primary', 'btn-outline-warning');
                btnText.textContent = '정보 수정';
                btnIcon.classList.replace('bx-check', 'bx-edit-alt');

                alert('가맹점 정보가 수정되었습니다.');
            })
            .catch(error => {
                alert('가맹점 정보수정에 실패했습니다.');
            });
        }
    });
});