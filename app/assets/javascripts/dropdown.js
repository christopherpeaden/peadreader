$(document).ready(function () {
    $('#navbar li').hover(
    function () {
        //show submenu
        $('ul', this).show();
    }, function () {
        //hide submenu
        $('ul', this).hide();
    });
});
