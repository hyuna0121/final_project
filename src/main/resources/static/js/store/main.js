$(document).ready(function() {
    loadTab('store', $('#btn-store'));
});

function loadTab(tabName, element) {
    if (element) {
        $('.nav-pills-custom .nav-link').removeClass('active');
        $(element).addClass('active');
    }

    // AJAX로 JSP 조각 불러오기
    // Controller URL: /franchise/tab/{tabName}
    const url = '/store/tab/' + tabName;
    
    $('#tab-content-area').fadeOut(100, function() {
        $(this).load(url, function(response, status, xhr) {
            if (status == "error") {
                $(this).html('<div class="alert alert-danger">페이지를 불러오는데 실패했습니다.</div>');
            }
            $(this).fadeIn(100);
        });
    });
}