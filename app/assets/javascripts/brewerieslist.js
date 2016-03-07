var BREWERIES = {};
BREWERIES.list = [];


BREWERIES.show = function(){
    $("#brewerytable tr:gt(0)").remove();

    var table = $("#brewerytable");

    $.each(BREWERIES.list, function (index, brewery) {
        table.append('<tr>'
            +'<td>'+brewery['name']+'</td>'
            +'<td>'+brewery['year']+'</td>'
            +'<td>'+brewery['beers'].length+'</td>'
            +'</tr>');
    });
};

BREWERIES.sort_by_name = function(){
    BREWERIES.list.sort( function(a,b){
        return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
    });
};

BREWERIES.sort_by_year = function(){
    BREWERIES.list.sort( function(a,b){
        return a.year > b.year;
    });
};

BREWERIES.sort_by_beers_count = function(){
    BREWERIES.list.sort( function(a,b){
        return a.beers.length > b.beers.length;
    });
};

$(document).ready(function () {
    $("#name").click(function (e) {
        BREWERIES.sort_by_name();
        BREWERIES.show();
        e.preventDefault();
    });

    $("#year").click(function (e) {
        BREWERIES.sort_by_year();
        BREWERIES.show();
        e.preventDefault();
    });

    $("#beers").click(function (e) {
        BREWERIES.sort_by_beers_count();
        BREWERIES.show();
        e.preventDefault();
    });

    if ( $("#brewerytable").length>0 ) {
        $.getJSON('breweries.json', function (beers) {
            BREWERIES.list = beers;
            BREWERIES.sort_by_name();
            BREWERIES.show();
        });
    }
});