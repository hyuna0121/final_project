    document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');

        var calendar = new FullCalendar.Calendar(calendarEl, {
            // [1] 기본 설정
            initialView: 'dayGridMonth', // 월 달력
            locale: 'ko',               // 한국어 설정
            height: 'auto',             // 높이 자동 조절
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: '' // 오른쪽 버튼 숨김 (필요하면 'dayGridMonth,listMonth')
            },

            // [2] 날짜 클릭 시 이벤트 (상세보기 등)
            dateClick: function(info) {
                alert('클릭한 날짜: ' + info.dateStr);
            },

            // [3] 데이터 (나중에 AJAX로 DB 데이터를 여기에 넣으면 됩니다)
            events: [
                {
                    title: '08:50 - 18:00',
                    start: '2025-12-02',
                    color: '#8592a3', // 회색 (정상 출근)
                    textColor: '#ffffff'
                },
                {
                    title: '연차 휴가',
                    start: '2025-12-12',
                    color: '#696cff', // 파란색 (휴가)
                    textColor: '#ffffff'
                },
                {
                    title: '지각 (09:15)',
                    start: '2025-12-20',
                    color: '#ffab00', // 노란색 (지각)
                    textColor: '#ffffff'
                },
                {
                    title: '성탄절',
                    start: '2025-12-25',
                    color: '#ff3e1d', // 빨간색 (공휴일)
                    display: 'background' // 배경색으로 칠하기 (선택사항)
                },
                {
                    title: '성탄절', // 글씨용 이벤트 하나 더 (배경이랑 겹칠 경우)
                    start: '2025-12-25',
                    color: 'transparent',
                    textColor: '#ff3e1d'
                }
            ],
            
            eventContent: function(arg) {
                let italicEl = document.createElement('div');
                italicEl.innerHTML = arg.event.title;
                italicEl.style.fontSize = '0.85rem';
                return { domNodes: [italicEl] };
            }
        });

        calendar.render();
    });
