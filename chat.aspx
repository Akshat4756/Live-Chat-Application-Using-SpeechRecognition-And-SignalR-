<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="chat.aspx.cs" Inherits="ChatApplication.chat" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chat Application</title>
    <script src="Scripts/jquery-3.4.1.js"></script>
    <script src="Scripts/jquery.signalR-2.2.2.js"></script>
    <script src="signalr/hubs"></script>
</head>
<body>
  <label>Enter Name</label>
    <input type="text" id="txtname" />
    <input id="btnSetName" type="button" value="Set Name" />
    <label>Enter Message</label>
    <input id="txtMessage" type="text" style="width:400px;" />
    <input id="btnGiveCommand" type="button" value="Give Voice Command" />
    <br /><br />
    <input id="btnSend" type="button" value="Send Message" />
    <div id="divName" style="display:block;margin:5px auto;font-size:20px;width:200px"></div>
        <div id="divMessage" style="display:block;margin:0 auto;width:500px;border:1px solid black;"></div>
    <script>
        $(function () {
            let txtName = document.getElementById('txtname');
            let txtMessage = document.getElementById('txtMessage');
            let btnSetName = document.getElementById('btnSetName');
            let btnSend = document.getElementById('btnSend');
            let divName = document.getElementById('divName');
            let divMessage = document.getElementById('divMessage');
            let giveCommandButton = document.getElementById('btnGiveCommand');

            //adding the reference to the chatHub
            let chat = $.connection.chatHub;
            btnSetName.onclick = function () {
                
                console.log(txtName.value);
                divName.innerText = `Name: ${txtName.value}`;
            }
            chat.client.sendMessage = function (Name, Message) {
                $(divMessage).append($(`<div style=border:1px solid black;padding:5px;margin:5px;><b>${Name}:</b>${Message}</div>`))
            }
            $.connection.hub.start().done(function () {
                btnSend.onclick = function () {
                    chat.server.send(`${txtName.value}`, `${txtMessage.value}`);
                };
            });

            var SpeechRecognition = SpeechRecognition || webkitSpeechRecognition;
            var SpeechGrammarList = SpeechGrammarList || webkitSpeechGrammarList;
            var grammar = '#JSGF V1.0';
            var recognition = new SpeechRecognition();
            var SpeechRecognitionList = new SpeechGrammarList();
            SpeechRecognitionList.addFromString(grammar, 1);
            recognition.grammars = SpeechRecognitionList;
            recognition.lang = 'en-IN';
            recognition.interimResults = true;


            recognition.onresult = function (event) {
                let command = event.results[0][0].transcript;
                let isfinal = event.results[0].isFinal;
                txtMessage.value = command;
                if (isfinal) {
                    chat.server.send(txtName.value, command);
                }
            }
            giveCommandButton.onclick = function () {
                recognition.start();
            };
            recognition.onspeechend = function () {
                recognition.stop();
            };
            recognition.onerrror = function (event) {
                txtMessage.value = 'Error occured in recognition: ' + event.error;
            }
        });
    </script>
</body>
</html>
