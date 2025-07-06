local fs = require("filesystem")
local file = io.open("/home/chat.lua", "w")
term = require("term")
computer = require("computer")
computer.beep()

--term.clear()
print("Install OpenChat? [y/n]")
print(" ")
ans = io.read()
if( string.lower(ans) == "y" ) then
print("Install path: [for example: /bin/chat.lua]")
 and = io.read()
print("Installing chat.lua")
 local file = io.open(ans, "w")
 if file then
   file:write([[
 component = require("component")
 event = require("event")
 modem = component.modem
 term = require("term")
 computer = require("computer")
 port = 0
 usr = " "
 local inputBuffer = " "
 
 computer.beep()
 term.clear()
 print("Welcome to chat V1!")
 print(" ")
 io.write("Port: ")
 port = tonumber(io.read())
 term.clear()
 io.write("Username: ")
 usr = io.read()
 term.clear()
 modem.open(port)
 if( modem.isOpen(port) ) then
  print("Port opened successfully!")
 else
  error("Failed to open the port")
 end
 
 print("type /EXIT to exit from the program")
 print("")
 --io.write("> ")
 
 
 while true do
   local evt = {event.pullMultiple("key_down", "modem_message")}
 
 
   if evt[1] == "key_down" then
     local char = evt[3]
     
     if( inputBuffer == "/EXIT" ) then
      modem.close(port)
      term.clear()
      break
     end
     
     if char == 13 then
       print("")
       modem.broadcast(port, usr .. ": " .. inputBuffer)
       inputBuffer = ""
       --io.write("> ")
 
     elseif char == 8 then
       if #inputBuffer > 0 then
         inputBuffer = inputBuffer:sub(1, -2)
         io.write("\b \b")
       end
 
     else
       local c = string.char(char)
       inputBuffer = inputBuffer .. c
       io.write(c)
     end
 
   elseif evt[1] == "modem_message" then
     local _, _, from, port, _, message = table.unpack(evt)
     print(tostring(message))
  os.sleep(0.2)
     io.write(inputBuffer)
   end
 end
 ]])
    file:close()
   print("Installation complete!")
 else
   print("Error installing file")
 end
else
 print("installation aborted!")
end
