# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@dateToYMDHMS = (str_date) ->
    date_converted = new Date(str_date)
    day = date_converted.getDate()
    month = date_converted.getMonth() + 1
    year = date_converted.getFullYear()
    hours = date_converted.getHours()
    am_pm = "AM"
    am_pm = "PM" if (hours >= 12)
    hours = hours - 12 if hours > 12
    minutes = date_converted.getMinutes()
    seconds = date_converted.getSeconds()
    day = "0" + day if (day<=9)
    month = "0" + month if (month<=9)
    hours = "0" + hours if (hours<=9)
    minutes = "0" + minutes if (minutes<=9)
    seconds = "0" + seconds if (seconds<=9)
    day + "/" + month + "/" + year + " " + hours + ":" + minutes + ":" + seconds + " " + am_pm