# This is where all begins. It launches your applications
chrome.app.runtime.onLaunched.addListener ->
  chrome.app.window.create('index.html', {id: 'main'})
