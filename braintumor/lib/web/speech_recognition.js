function startRecognition() {
  if (!('webkitSpeechRecognition' in window)) {
    alert('Speech recognition not supported.');
    return;
  }

  const recognition = new webkitSpeechRecognition();
  recognition.lang = 'en-US';
  recognition.interimResults = false;
  recognition.maxAlternatives = 1;

  recognition.onresult = function(event) {
    const transcript = event.results[0][0].transcript;
    console.log("Speech result:", transcript);
    window.postMessage(transcript, "*");
  };

  recognition.onerror = function(event) {
    console.error("Speech recognition error:", event);
  };

  recognition.onend = function() {
    console.log("Speech recognition ended.");
  };

  recognition.start();
}
