    document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');

        var calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth', // 월 달력
            locale: 'ko',               
            height: 'auto',             
            headerToolbar: {
                left: 'prev,next today',
                center: '',
                right: '' // 오른쪽 버튼 숨김 
            },

            dateClick: function(info) {
                alert('클릭한 날짜: ' + info.dateStr);
            },

			eventSources: [
                {
                    url: '/member/calendar',
                    method: 'GET',
                    failure: function() {
                        console.log('공휴일 데이터 로딩 실패');
                    }
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
