

SetupMCPHome = function() {
    $("#mcp-app-name").html("Welcome " + QB.Phone.Data.PlayerData.charinfo.firstname + " " + QB.Phone.Data.PlayerData.charinfo.lastname);
}

$(document).on('click', '#mix2meal', function(e){
    $.post('https://qb-phone/mix2meal');
});

$(document).on('click', '#sharebox', function(e){
    $.post('https://qb-phone/sharebox');
});
$(document).on('click', '#mcroyale', function(e){
    $.post('https://qb-phone/mcroyale');
});
$(document).on('click', '#bigmac', function(e){
    $.post('https://qb-phone/bigmac');
});
$(document).on('click', '#bigtasty', function(e){
    $.post('https://qb-phone/bigtasty');
});
$(document).on('click', '#doublebigtasty', function(e){
    $.post('https://qb-phone/doublebigtasty');
});
$(document).on('click', '#bigtastychicken', function(e){
    $.post('https://qb-phone/bigtastychicken');
});
$(document).on('click', '#chickenmac', function(e){
    $.post('https://qb-phone/chickenmac');
});
$(document).on('click', '#cheeseburger', function(e){
    $.post('https://qb-phone/cheeseburger');
});
$(document).on('click', '#chickenfillet', function(e){
    $.post('https://qb-phone/chickenfillet');
});
$(document).on('click', '#cheddarcheesefries', function(e){
    $.post('https://qb-phone/cheddarcheesefries');
});
$(document).on('click', '#mcnuggets', function(e){
    $.post('https://qb-phone/mcnuggets');
});
$(document).on('click', '#gardensalad', function(e){
    $.post('https://qb-phone/gardensalad');
});
$(document).on('click', '#strawberrymilkshake', function(e){
    $.post('https://qb-phone/strawberrymilkshake');
});
$(document).on('click', '#chocolatemilkshake', function(e){
    $.post('https://qb-phone/chocolatemilkshake');
});
$(document).on('click', '#vanillamilkshake', function(e){
    $.post('https://qb-phone/vanillamilkshake');
});
$(document).on('click', '#mcfizzbluepassion', function(e){
    $.post('https://qb-phone/mcfizzbluepassion');
});
$(document).on('click', '#mcfizzstrawberry', function(e){
    $.post('https://qb-phone/mcfizzstrawberry');
});
$(document).on('click', '#cocacola', function(e){
    $.post('https://qb-phone/cocacola');
});
$(document).on('click', '#cocacolazero', function(e){
    $.post('https://qb-phone/cocacolazero');
});
$(document).on('click', '#sprite', function(e){
    $.post('https://qb-phone/sprite');
});
$(document).on('click', '#fanta', function(e){
    $.post('https://qb-phone/fanta');
});
$(document).on('click', '#fantagreenapple', function(e){
    $.post('https://qb-phone/fantagreenapple');
});
$(document).on('click', '#chocolatesundea', function(e){
    $.post('https://qb-phone/chocolatesundea');
});
$(document).on('click', '#strawberrysundea', function(e){
    $.post('https://qb-phone/strawberrysundea');
});
$(document).on('click', '#applepie', function(e){
    $.post('https://qb-phone/applepie');
});
$(document).on('click', '#mcfries', function(e){
    $.post('https://qb-phone/mcfries');
});
