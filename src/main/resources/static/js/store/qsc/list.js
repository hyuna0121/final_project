$(function() {
    let startParam = $('#searchStartDate').val(); 
    let endParam = $('#searchEndDate').val();

    let startMoment = moment();
    let endMoment = moment();
    let hasValidData = false; 

    if (startParam && endParam) {
        let s = moment(startParam, 'YYYY-MM-DD');
        let e = moment(endParam, 'YYYY-MM-DD');
        
        if (s.isValid() && e.isValid()) {
            startMoment = s;
            endMoment = e;
            hasValidData = true;
        }
    }

    $('#daterange').daterangepicker({
        startDate: startMoment,
        endDate: endMoment,
        autoUpdateInput: false, 
        locale: {
            format: "YYYY-MM-DD",
            separator: " ~ ",
            applyLabel: "확인",
            cancelLabel: "취소",
            fromLabel: "부터",
            toLabel: "까지",
            customRangeLabel: "직접 선택",
            daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
            monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
            firstDay: 0
        },
		ranges: {
	        '오늘': [moment(), moment()],
	        '어제': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
	        '최근 7일': [moment().subtract(6, 'days'), moment()],
	        '최근 30일': [moment().subtract(29, 'days'), moment()],
	        '이번 달': [moment().startOf('month'), moment().endOf('month')],
	        '지난 달': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
		}
    });

    if (hasValidData) {
        $('#daterange').val(startMoment.format('YYYY-MM-DD') + ' ~ ' + endMoment.format('YYYY-MM-DD'));
    } else {
        $('#daterange').val(''); 
    }

    $('#daterange').on('apply.daterangepicker', function(ev, picker) {
        const sDate = picker.startDate.format('YYYY-MM-DD');
        const eDate = picker.endDate.format('YYYY-MM-DD');

        $(this).val(sDate + ' ~ ' + eDate);
        
        $('#searchStartDate').val(sDate);
        $('#searchEndDate').val(eDate);
    });

    $('#daterange').on('cancel.daterangepicker', function(ev, picker) {
        $(this).val('');
        $('#searchStartDate').val('');
        $('#searchEndDate').val('');
    });
});

function searchQsc() {
    document.getElementById("page").value = 1;
    document.getElementById("qscSearchForm").submit();
}

function resetSearchForm() {
	const inputs = document.querySelectorAll('#qscSearchForm input');
    inputs.forEach(input => input.value = '');
	
	const selects = document.querySelectorAll('#qscSearchForm select');
    selects.forEach(select => select.selectedIndex = 0);

    if(document.getElementById('page')) {
        document.getElementById('page').value = 1;
    }
}

function downloadExcel() {
    const form = document.getElementById('qscSearchForm');
    const params = new URLSearchParams(new FormData(form));

    const currentUrlParams = new URLSearchParams(window.location.search);

    currentUrlParams.forEach((value, key) => {
        if (key.startsWith('sortConditions')) {
            params.append(key, value);
        }
    });

    const currentPath = window.location.pathname;
    let url = `/store/qsc/downloadExcel`;

    if (currentPath.includes(`my-list`)) url = `/store/qsc/my-downloadExcel`;

    location.href = url + '?' + params.toString();
}

function movePage(page) {
    if (page < 1) page = 1;

    document.getElementById("page").value = page;

    const form = document.getElementById('qscSearchForm');

    const currentUrlParams = new URLSearchParams(window.location.search);
    currentUrlParams.forEach((value, key) => {
        if (key.startsWith('sortConditions')) {
            if (form.querySelector(`input[name="${key}"]`)) {
                form.querySelector(`input[name="${key}"]`).value = value;
            } else {
                const input = document.createElement("input");
                input.type = "hidden";
                input.value = value;
                form.appendChild(input);
            }
        }
    });

    form.submit();
}

function changePerPage(val) {
    document.querySelector('#hiddenPerPage').value = val;
    document.querySelector('#page').value = 1;
    const form = document.getElementById('qscSearchForm');

    const currentUrlParams = new URLSearchParams(window.location.search);
    currentUrlParams.forEach((value, key) => {
        if (key.startsWith('sortConditions')) {
            if (form.querySelector(`input[name="${key}"]`)) {
                form.querySelector(`input[name="${key}"]`).value = value;
            } else {
                const input = document.createElement("input");
                input.type = "hidden";
                input.value = value;
                form.appendChild(input);
            }
        }
    });

    form.submit();
}