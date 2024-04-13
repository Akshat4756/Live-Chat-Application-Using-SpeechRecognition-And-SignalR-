using Microsoft.AspNet.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ChatApplication
{
    public class chatHub : Hub
    {
        public void Send(string Name,string Message)
        {
            Clients.All.sendMessage(Name,Message);
        }
    }
}