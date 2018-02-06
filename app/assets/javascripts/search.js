$(function() {
  $("#search input").keyup(function() {
    console.log($("#search").serialize());
    $.get($("#search").attr("action"), $("#search").serialize(), null, "script");
    return false;
  });
});