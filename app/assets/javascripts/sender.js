var namespace = 'urn:x-cast:com.herokuapp.tvmq';
var session = null;

if (!location.pathname.match('/tv') && (!chrome.cast || !chrome.cast.isAvailable)) {
  setTimeout(initializeCastApi, 1000);
}

function initializeCastApi() {
  if (!chrome.cast) return
  var sessionRequest = new chrome.cast.SessionRequest(window.castApplicationId);
  var apiConfig = new chrome.cast.ApiConfig(sessionRequest, sessionListener, receiverListener);
  chrome.cast.initialize(apiConfig, onInitSuccess, onError);
}

function onInitSuccess() {
  console.log('onInitSuccess')
}

function onError(message) {
  console.log('onError: ' + JSON.stringify(message))
}

function onSuccess(message) {
  console.log('onSuccess: ' + message)
}

function onStopAppSuccess() {
  console.log('onStopAppSuccess')
}

function sessionListener(e) {
  console.log('New session ID:' + e.sessionId)
  session = e;
  session.addUpdateListener(sessionUpdateListener);
  session.addMessageListener(namespace, receiverMessage);
}

function sessionUpdateListener(isAlive) {
  var message = isAlive ? 'Session Updated' : 'Session Removed';
  message += ': ' + session.sessionId
  console.log(message)
  if (!isAlive) session = null
}

function receiverMessage(namespace, message) {
  console.log('receiverMessage: ' + namespace + ', ' + message)
}

function receiverListener(e) {
  if(e === 'available') {
    console.log('receiver found')
  }
  else {
    console.log('receiver list empty')
  }
}

function stopApp() {
  session.stop(onStopAppSuccess, onError);
}

function startCasting(message) {
  if (session != null) return
  chrome.cast.requestSession(function(e) { session = e; }, onError);
}
