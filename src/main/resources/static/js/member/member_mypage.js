document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');
    var titleEl = document.getElementById('calendarTitle');

    var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'ko',               
        height: 'auto',
        headerToolbar: false,

        datesSet: function(info) {
            if(titleEl) {
                var date = calendar.getDate();
                var year = date.getFullYear();
                var month = String(date.getMonth() + 1).padStart(2, '0');
                titleEl.innerText = year + '. ' + month;
            }
        },
        
        eventSources: [
             {
                 url: '/member/calendar',
                 method: 'GET',
                 failure: function() { console.log('데이터 로딩 실패'); }
             }
         ],
         eventContent: function(arg) {
             let italicEl = document.createElement('div');
             italicEl.innerHTML = arg.event.title;
             italicEl.style.fontSize = '0.85rem';
             italicEl.style.whiteSpace = 'normal';
             return { domNodes: [italicEl] };
         }
    });

    calendar.render();

    var btnPrev = document.getElementById('btnPrev');
    var btnNext = document.getElementById('btnNext');
    var btnToday = document.getElementById('btnToday');

    if(btnPrev) btnPrev.addEventListener('click', function() { calendar.prev(); });
    if(btnNext) btnNext.addEventListener('click', function() { calendar.next(); });
    if(btnToday) btnToday.addEventListener('click', function() { calendar.today(); });


    var btnShowList = document.getElementById('btnShowList');
    var btnShowCalendar = document.getElementById('btnShowCalendar');
    
    var listWrapper = document.getElementById('listWrapper');
    var calendarWrapper = document.getElementById('calendarWrapper');

    btnShowList.addEventListener('click', function() {
        listWrapper.style.display = 'block';
        calendarWrapper.style.display = 'none';

        btnShowList.classList.add('btn-primary', 'active');       
        btnShowList.classList.remove('btn-outline-primary');
        
        btnShowCalendar.classList.remove('btn-primary', 'active');
        btnShowCalendar.classList.add('btn-outline-primary');
    });

    btnShowCalendar.addEventListener('click', function() {
        listWrapper.style.display = 'none';
        calendarWrapper.style.display = 'block';

        btnShowCalendar.classList.add('btn-primary', 'active');  
        btnShowCalendar.classList.remove('btn-outline-primary');

        btnShowList.classList.remove('btn-primary', 'active');  
        btnShowList.classList.add('btn-outline-primary');

        calendar.render(); 
    });
});