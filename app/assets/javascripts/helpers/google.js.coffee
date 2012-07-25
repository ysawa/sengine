$.extend
  check_if_google_analytics_enabled: ->
    typeof _gaq != "undefined"
  google_analytics_track_pageview: (url = null) ->
    if url
      _gaq.push(['_trackPageview', url])
    else
      _gaq.push(['_trackPageview'])
