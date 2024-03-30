var CurrentmcPage = null;
var OpenedPerson = null;

$(document).on('click', '.mc-block', function(e){
    e.preventDefault();
    var PressedBlock = $(this).data('mcblock');
    OpenmcPage(PressedBlock);
});

OpenmcPage = function(page) {
    CurrentmcPage = page;
    $(".mc-"+CurrentmcPage+"-page").css({"display":"block"});
    $(".mc-homescreen").animate({
        left: 30+"vh"
    }, 200);
    $(".mc-tabs").animate({
        left: 0+"vh"
    }, 200, function(){
        $(".mc-tabs-footer").animate({
            bottom: 0,
        }, 200)
        if (CurrentmcPage == "alerts") {
            $(".mc-recent-alert").removeClass("noodknop");
            $(".mc-recent-alert").css({"background-color":"#ff0f0fd7"}); 
        }
    });
}

SetupmcHome = function() {
    $("#mc-app-name").html("Welcome " + QB.Phone.Data.PlayerData.charinfo.firstname + " " + QB.Phone.Data.PlayerData.charinfo.lastname);
}

mcHomePage = function() {
    $(".mc-tabs-footer").animate({
        bottom: -5+"vh"
    }, 200);
    setTimeout(function(){
        $(".mc-homescreen").animate({
            left: 0+"vh"
        }, 200, function(){
            if (CurrentmcPage == "alerts") {
                $(".mc-alert-new").remove();
            }
            $(".mc-"+CurrentmcPage+"-page").css({"display":"none"});
            CurrentmcPage = null;
        });
        $(".mc-tabs").animate({
            left: -30+"vh"
        }, 200);
    }, 400);
}

$(document).on('click', '.mc-tabs-footer', function(e){
    e.preventDefault();
    mcHomePage();
});


mcorderNotification = function(data) {
    var randId = Math.floor((Math.random() * 10000) + 1);
    var AlertElement = '';
    if (data.alert.coords != undefined && data.alert.coords != null) {
        AlertElement = '<div class="mc-alert" id="alert-'+randId+'"><p class="mc-alert-type"><span class="mc-alert-new" style="margin-bottom: 1vh;">NEW</span> Order: '+data.alert.title+'</p><p class="mc-alert-description">'+data.alert.description+'</p> <hr> <div class="mc-location-button">LOCATION</div> </div>';
    } else {
        AlertElement = '<div class="mc-alert" id="alert-'+randId+'"><p class="mc-alert-type"><span class="mc-alert-new" style="margin-bottom: 1vh;">NEW</span> Order: '+data.alert.title+'</p><p class="mc-alert-description">'+data.alert.description+'</p></div>';
    }
    $(".mc-recent-alerts").html('<div class="mc-recent-alert" id="recent-alert-'+randId+'"><span class="mc-recent-alert-title">Order: '+data.alert.title+'</span><p class="mc-recent-alert-description">'+data.alert.description+'</p></div>');
    $(".mc-alerts").prepend(AlertElement);
    $("#alert-"+randId).data("alertData", data.alert);
    $("#recent-alert-"+randId).data("alertData", data.alert);
}

$(document).on('click', '.mc-recent-alert', function(e){
    e.preventDefault();
    var alertData = $(this).data("alertData");

    if (alertData != undefined){
        if (alertData.coords != undefined && alertData.coords != null) {
            $.post('https://qb-phone/SetAlertWaypoint', JSON.stringify({
                alert: alertData,
            }));
        } else {
            QB.Phone.Notifications.Add("politie", "McDonald's", "This order doesn't have a GPS location!");
        }
    }else {
        QB.Phone.Notifications.Add("politie", "McDonald's", "There are no alerts available.");
    }
});

$(document).on('click', '.mc-location-button', function(e){
    e.preventDefault();
    var alertData = $(this).parent().data("alertData");
    $.post('https://qb-phone/SetAlertWaypoint', JSON.stringify({
        alert: alertData,
    }));
});

$(document).on('click', '.mc-clear-alerts', function(e){
    $(".mc-alerts").html("");
    $(".mc-recent-alerts").html('<div class="mc-recent-alert"> <span class="mc-recent-alert-title">You don\'t have any orders!</span></div>');
    QB.Phone.Notifications.Add("politie", "McDonald's", "All orders have been deleted!");
});
