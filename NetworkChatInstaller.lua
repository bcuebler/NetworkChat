fs = require("filesystem")
term = require("term")
computer = require("computer")
computer.beep()

term.clear()
print("OpenChat installer")
print(" ")
print("Install OpenChat? [y/n]")
print(" ")
ans = io.read()

if( string.lower(ans) == "y" ) then
 term.clear()
 print("OpenChat installer")
 print(" ")
 print("Installation path? E.g.: /home")
 path = tostring(io.read())
 path = path .. "/chat.lua"

 if fs.exists(path) then
   print(" ")
   print("The file is already exists! Do you want to overwrite it? [y/n]")
   local overwrite = io.read()
   if string.lower(overwrite) ~= "y" then
     print("Installation aborted by user.")
     if fs.exists("/tmp/ChatInst.lua") then
      print(" ")
      print("Cleaning up...") 
      fs.remove("/tmp/ChatInst.lua")
     end
     return
   end
 end

 print("Installing chat.lua")
 
 file, err = io.open(path, "w")
 if file then
   file:write([[
 component = require("component")
 event = require("event")
if not component.isAvailable("modem") then
    print("This program requires a network card to run.")
    os.exit()
end
 modem = component.modem
 term = require("term")
 computer = require("computer")
 port = 0
 usr = " "
 local inputBuffer = ""
 
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
 io.write("> ")
 
 
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
       -- Új prompt az elküldött üzenet után
       io.write("> ")
 
     elseif char == 8 then
       if #inputBuffer > 0 then
         inputBuffer = inputBuffer:sub(1, -2)
         io.write("\b \b")
       end
 
     else
       if char > 0 and (char >= 32 or char == 9) then
         local c = string.char(char)
         inputBuffer = inputBuffer .. c
         io.write(c)
       end
     end
 
   elseif evt[1] == "modem_message" then
     local _, _, from, port, _, message = table.unpack(evt)
     local x, y = term.getCursor()
     term.setCursor(1, y)
     term.clearLine()
     print(tostring(message))
     os.sleep(0.2)
     io.write("> " .. inputBuffer)
   end
 end

 ]])
   file:close()
   print("Installation complete!")
 else
   print("Error installing file: " .. tostring(err))
 end
else
 print("installation aborted!")
end

if fs.exists("/tmp/ChatInst.lua") then
 print(" ")
 print("Cleaning up...") 
 fs.remove("/tmp/ChatInst.lua")
end

 
