'use strict';

let vocTrendChart = null;
let vocCategoryChart = null;

document.addEventListener("DOMContentLoaded", function () {
    initCharts();

    const fp = flatpickr("#monthPicker", {
        plugins: [
            new monthSelectPlugin({
                shorthand: true, 
                dateFormat: "Y-m", 
                altFormat: "Y년 F", 
                theme: "light" 
            })
        ],
        locale: "ko", 
        defaultDate: new Date(),
        onChange: function(selectedDates, dateStr, instance) {
            const [year, month] = dateStr.split("-");
            fetchStatistics(year, month);
        }
    });
	
	const links = document.querySelectorAll('.voc-link');
	
    links.forEach(link => {
        link.addEventListener('click', function() {
            const type = this.getAttribute('data-type');
            const dateStr = document.querySelector('#monthPicker').value;
			
            const [year, month] = dateStr.split("-");
            const startDate = `${year}-${month}-01`;
            const lastDay = new Date(year, month, 0).getDate(); 
            const endDate = `${year}-${month}-${lastDay}`;

            const queryParams = new URLSearchParams({
                page: 1,
                vocType: type,
                vocStatus: '',
                searchStartDate: startDate,
                searchEndDate: endDate,
                storeName: '',
                vocTitle: ''
            });

            window.location.href = `/store/voc/list?${queryParams.toString()}`;
        });
    });
	
	const btnTotal = document.querySelector('#btnTotalVoc');
    btnTotal.addEventListener('click', function() {
        const dateStr = document.querySelector('#monthPicker').value;
		
        const [year, month] = dateStr.split("-");
        const startDate = `${year}-${month}-01`;
        const lastDay = new Date(year, month, 0).getDate();
        const endDate = `${year}-${month}-${lastDay}`;

        const queryParams = new URLSearchParams({
            page: 1,
            vocType: '', 
            vocStatus: '',  
            searchStartDate: startDate,
            searchEndDate: endDate,
            storeName: '',
            vocTitle: ''
        });

        window.location.href = `/store/voc/list?${queryParams.toString()}`;
    });

    const today = new Date();
    const initialMonth = String(today.getMonth() + 1).padStart(2, '0');
    fetchStatistics(today.getFullYear(), initialMonth);
});

function initCharts() {
    let cardColor, headingColor, axisColor, borderColor;
    if (typeof config !== 'undefined') {
        cardColor = config.colors.white;
        headingColor = config.colors.headingColor;
        axisColor = config.colors.axisColor;
        borderColor = config.colors.borderColor;
    } else {
        cardColor = '#fff';
        headingColor = '#566a7f';
        axisColor = '#a1acb8';
        borderColor = '#eceef1';
    }

    const vocTrendEl = document.querySelector('#vocTrendChart');
    if (vocTrendEl) {
        const vocTrendConfig = {
            series: [{
                name: 'VOC 접수',
                data: [] 
            }],
            chart: {
                height: 300,
                type: 'area', 
                toolbar: { show: false }
            },
            dataLabels: { enabled: false },
            stroke: {
                curve: 'smooth',
                width: 2
            },
            grid: {
                borderColor: borderColor,
                strokeDashArray: 3,
                xaxis: { lines: { show: false } }
            },
            colors: [config.colors.primary],
            fill: {
                type: 'gradient',
                gradient: {
                    shade: 'light',
                    shadeIntensity: 0.8,
                    opacityFrom: 0.6,
                    opacityTo: 0.1
                }
            },
            xaxis: {
                categories: [], 
                axisBorder: { show: false },
                axisTicks: { show: false },
                labels: { style: { colors: axisColor, fontSize: '13px' } }
            },
            yaxis: {
                labels: {
                    formatter: function (value) {
                        return value.toFixed(0);
                    }, 
                    style: { colors: axisColor, fontSize: '13px' } 
                }
            },
            tooltip: {
                y: {
                    formatter: function (value) {
                        return value + "건";
                    }
                }
            }
        };
        
        vocTrendChart = new ApexCharts(vocTrendEl, vocTrendConfig);
        vocTrendChart.render();
    }

    const vocCategoryEl = document.querySelector('#vocCategoryChart');
    if (vocCategoryEl) {
        const vocCategoryConfig = {
            series: [],
            labels: ['Hygiene', 'Service', 'Taste'], 
            chart: {
                height: 250,
                type: 'donut'
            },
            colors: [config.colors.primary, config.colors.success, config.colors.info, config.colors.warning],
            stroke: { show: false, curve: 'straight' },
            dataLabels: {
                enabled: true,
                formatter: function (val) {
                    return Math.round(val) + '%';
                }
            },
            tooltip: {
                y: {
                    formatter: function (val) {
                        return val + "건";
                    }
                }
            },
            legend: { show: false },
            plotOptions: {
                pie: {
                    donut: {
                        labels: {
                            show: true,
                            name: { fontSize: '1.5rem', fontFamily: 'Public Sans' },
                            value: {
                                fontSize: '1.5rem',
                                color: headingColor,
                                fontFamily: 'Public Sans',
                                formatter: function (val) {
                                    return parseInt(val) + '건';
                                }
                            },
                            total: {
                                show: true,
                                fontSize: '0.8125rem',
                                color: axisColor,
                                label: 'Total',
                                formatter: function (w) {
                                    return w.globals.seriesTotals.reduce((a, b) => a + b, 0) + '건';
                                }
                            }
                        }
                    }
                }
            }
        };

        vocCategoryChart = new ApexCharts(vocCategoryEl, vocCategoryConfig);
        vocCategoryChart.render();
    }
}

function fetchStatistics(year, month) {
    const trendEl = document.querySelector('#vocTrendChart');
    const catEl = document.querySelector('#vocCategoryChart');
    if(trendEl) trendEl.style.opacity = '0.5';
    if(catEl) catEl.style.opacity = '0.5';

    fetch(`/store/voc/statistics?year=${year}&month=${month}`)
        .then(response => {
            if (!response.ok) throw new Error('Network response was not ok');
            return response.json();
        })
        .then(data => {
            if (vocTrendChart) {
                vocTrendChart.updateOptions({
                    xaxis: { 
                        categories: data.trendLabels,
                        labels: {
                            formatter: function (value) {
                                return Number(value) + "일";
                            }
                        }
                    }
                });
                vocTrendChart.updateSeries([{
                    name: 'VOC 접수',
                    data: data.trendCounts
                }]);
            }

            if (vocCategoryChart) {
                vocCategoryChart.updateSeries(data.categoryCounts);
            }

            const counts = data.categoryCounts;
            const total = counts.reduce((a, b) => a + b, 0);
            const getPercent = (val) => total === 0 ? '0%' : Math.round((val / total) * 100) + '%';

            document.querySelector('#hygieneProgress').innerText = getPercent(counts[0]);
            document.querySelector('#serviceProgress').innerText = getPercent(counts[1]);
            document.querySelector('#tasteProgress').innerText   = getPercent(counts[2]);

            const storeListEl = document.getElementById('topStoreList');
            storeListEl.innerHTML = '';

            if (data.topStores && data.topStores.length > 0) {
                data.topStores.forEach((store, index) => {
                    const badgeClass = (index === 0) ? 'bg-label-danger' : 'bg-label-secondary';
                    const countClass = (index === 0) ? 'text-danger' : '';

                    const li = `
                        <li class="d-flex mb-4 pb-1">
                            <div class="avatar flex-shrink-0 me-3">
								<a href="/store/detail?storeId=${store.activeCount}">
	                                <span class="avatar-initial rounded ${badgeClass}">
	                                    <i class='bx bx-store-alt'></i>
	                                </span>
								</a>
                            </div>
                            <div class="d-flex w-100 flex-wrap align-items-center justify-content-between gap-2">
                                <div class="me-2">
                                    <h6 class="mb-0">${store.category}</h6> <small class="text-muted">${store.description}</small> </div>
                                <div class="user-progress d-flex align-items-center gap-1">
                                    <h6 class="mb-0 ${countClass}">${store.count}건</h6>
                                </div>
                            </div>
                        </li>
                    `;
                    
                    storeListEl.insertAdjacentHTML('beforeend', li);
                });
            } else {
                storeListEl.innerHTML = '<li class="text-center text-muted py-3">데이터가 없습니다.</li>';
            }

            const summary = data.summary;
            if (summary) {
                document.getElementById('kpiTotal').innerText = summary.total + '건';
                renderDiff('#kpiTotalDiff', summary.totalRate, '%', true);
                document.getElementById('kpiResolved').innerText = summary.resolved + '건';
                const rate = summary.total > 0 
                             ? Math.round((summary.resolved / summary.total) * 100) 
                             : 0;
                document.getElementById('kpiRate').innerText = '처리율 ' + rate + '%';
                document.getElementById('kpiPending').innerText = summary.pending + '건';
                document.getElementById('kpiAvgTime').innerText = summary.avgTime + '시간';
                renderDiff('#kpiAvgTimeDiff', summary.avgDiff, '시간', true);
            }

            const tbody = document.getElementById('managerTableBody');
            tbody.innerHTML = '';

            if (data.managerList && data.managerList.length > 0) {
                data.managerList.forEach(item => {
                    const initial = item.category ? item.category.charAt(0) : '?';

                    let badgeClass = 'bg-label-primary';
                    let badgeText = '-';
                    
                    if (item.avgTime <= 24) {
                        badgeClass = 'bg-label-primary';
                        badgeText = '빠름';
                    } else if (item.avgTime <= 48) {
                        badgeClass = 'bg-label-success';
                        badgeText = '보통';
                    } else {
                        badgeClass = 'bg-label-warning';
                        badgeText = '느림';
                    }

                    const tr = `
                        <tr>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="avatar avatar-xs me-2">
                                        <span class="avatar-initial rounded-circle ${badgeClass}">${initial}</span>
                                    </div>
                                    <span>${item.category}</span>
                                </div>
                            </td>
                            <td>${item.count}건</td>
                            <td>${item.activeCount}건</td>
                            <td>${item.pendingCount}건</td>
                            <td>
                                <span class="badge ${badgeClass}">${badgeText}</span>
                                <small class="text-muted ms-1">(${item.avgTime}시간)</small>
                            </td>
                        </tr>
                    `;
                    tbody.insertAdjacentHTML('beforeend', tr);
                });
            } else {
                tbody.innerHTML = '<tr><td colspan="4" class="text-center py-3">데이터가 없습니다.</td></tr>';
            }

        })
        .catch(error => {
            console.error('Error fetching statistics:', error);
        })
        .finally(() => {
            if(trendEl) trendEl.style.opacity = '1';
            if(catEl) catEl.style.opacity = '1';
        });
}

function renderDiff(selector, value, unit, isLowerBetter = false) {
    const el = document.querySelector(selector);
    if (!el) return;

    if (value === 0 || value === undefined) {
        el.className = 'text-muted fw-semibold';
        el.innerHTML = '<i class="bx bx-minus"></i> 변동 없음';
        return;
    }

    const isPlus = value > 0;
    const absValue = Math.abs(value);
    
    let colorClass = '';
    if (isLowerBetter) {
        colorClass = isPlus ? 'text-danger' : 'text-success'; 
    } else {
        colorClass = isPlus ? 'text-success' : 'text-danger';
    }

    const icon = isPlus ? '<i class="bx bx-up-arrow-alt"></i>' : '<i class="bx bx-down-arrow-alt"></i>';
    const text = isPlus ? `+${absValue}${unit}` : `-${absValue}${unit}`;

    el.className = `${colorClass} fw-semibold`;
    el.innerHTML = `${icon} ${text} <span class="text-muted small ms-1">(전월 대비)</span>`;
}