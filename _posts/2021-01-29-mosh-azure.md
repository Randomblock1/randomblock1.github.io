---
title: "How to Enable Mosh in an Azure VM"
categories:
  - blog
tags:
  - Linux
---
Azure is a pretty great service for hosting cloud services. One of the many things you can do is host a Virtual Machine in the cloud. Mosh is better than SSH (well, except that you need tmux for command history), so it makes sense to use Mosh to connect to devices instead of SSH. By default, VMs have the SSH port open, but if you try to login with Mosh, you’ll get an error about port 60001. How do you fix this? It’s actually pretty easy.

First, login to the Azure Portal, and select the resource group that contains your Linux VM. Second, select your virtual machine. Then, select “Networking” under “Settings” in the sidebar. You’ll see the network traffic rules. By default, the only port open to the Internet is 22, for SSH. Mosh uses port 22 to authenticate with SSH, but it needs extra ports to work properly.

To enable Mosh, click “Add inbound port rule”. Set the source to “Any”, since we want to be able to access it from the open Internet _and_ within other Azure services. If you’re using a VPN to access it, set the source to that. Really, just copy whatever you have chosen for SSH. Set “source port ranges” to “*”. Set “destination” to “any”.

Now, we need to choose what ports to open. Mosh uses ports 60001-69999, but I’m never going to have more than 10 Mosh sessions open, so I’m going to use ports 60001-60010. Set “protocol” to “UDP”, “action” to “Allow”, and “priority” to the priority number you want (I think Mosh is less important than SSH, so I set it to 400) and set the name to something like “Mosh”. Click “Add” and you’re done.

You should now be able to connect to your VM using Mosh. Now you can access your VM wherever you go, without having to worry about SSH problems!
