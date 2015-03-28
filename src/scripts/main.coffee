# This is where all begins. It launches your applications
chrome.app.runtime.onLaunched.addListener ->
  chrome.app.window.create('index.html', {id: 'main'})


LIVERELOAD_HOST = 'localhost:'
LIVERELOAD_PORT = 35729
connection = new WebSocket('ws://' + LIVERELOAD_HOST + LIVERELOAD_PORT + '/livereload')

connection.onerror = (e) ->
  console.log('reload connection got error' + JSON.stringify(e))


connection.onmessage = (e) ->
  if e.data
    data = JSON.parse(e.data)
    if data and data.command == 'reload' then chrome.runtime.reload()
