local me = {
  name = "kCountdown",
  author = "Kangan",
  vars = {
    updateSpeed = 1,
    fadeTime = 2,
    sizeTime = 1,
    cdTime = 16,
    cdLeftTime = 16,
    cdRunning = false,
  }
}

me.OnLoad = function (this)
  this:RegisterEvent("CHAT_MSG_PARTY")
end

me.OnEvent = function (this,event,arg1,arg2,arg3,arg4)
  if ( event == "CHAT_MSG_PARTY") then
    if (string.find(arg1, "kCountdown")) then
      local i, j = string.find(arg1, ":%d+|")
      if (not i) then return end
      local number = string.sub(arg1, i+1, j-1)
      kCountdownTexture:SetTexture("interface/addons/kCountdown/texture/"..number..".tga")
      PlaySoundByPath("Interface/Addons/kCountdown/warn.wav");
      me.vars.fadeTime = 2
      me.vars.sizeTime = 1
    end
  end
end

me.OnUpdate = function (elapsedTime)
  me.vars.updateSpeed = me.vars.updateSpeed - elapsedTime
  me.vars.fadeTime = me.vars.fadeTime - elapsedTime
  me.vars.sizeTime = me.vars.sizeTime - elapsedTime

  if me.vars.updateSpeed <= 0 and me.vars.cdRunning then
    me.vars.updateSpeed = 1
    me.UpdateCountdown()
  end

  if (me.vars.fadeTime >= 0) then
    local alphaVal = me.vars.fadeTime/2
    kCountdownFrame:SetAlpha(alphaVal)
  end

  if (me.vars.sizeTime >= 0) then
    local maxSize = 188
    local sizeToSet = me.vars.sizeTime * maxSize
    if sizeToSet < 124 then sizeToSet = 124 end
    kCountdownTexture:SetSize(sizeToSet, sizeToSet)
  end

end

me.CreateLink = function(linktype, data, text)
	return string.format("|H%s:%s|h%s|h", linktype, data, text);
end

me.UpdateCountdown = function ()
  if (
    (me.vars.cdLeftTime == 15 or
    me.vars.cdLeftTime == 12 or
    me.vars.cdLeftTime == 10 or
    me.vars.cdLeftTime <= 7) and
    me.vars.cdLeftTime > 0
  ) then
    SendChatMessage("|HkCountdown:"..me.vars.cdLeftTime.."|h"..me.vars.cdLeftTime.."|h", "PARTY")
  end

  if (me.vars.cdLeftTime == 0) then
    SendChatMessage("|HkCountdown:"..me.vars.cdLeftTime.."|h|cff00ff00GO!|r|h", "PARTY")
    me.StartStopCountdown() -- stop
    me.vars.cdLeftTime = me.vars.cdTime
  end
  me.vars.cdLeftTime = me.vars.cdLeftTime - 1
end
me.test = function ()
  SendChatMessage("|HkCountdown:15|h|h", "PARTY")
end

me.StartStopCountdown = function ()
  if (GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0) then
    SendWarningMsg("You are not in party!")
    me.vars.cdRunning = false
    return
  end

  if (me.vars.cdRunning) then
    me.vars.cdRunning = false

    if (me.vars.cdLeftTime > 0) then
      SendChatMessage("|H|h|cffff0000CANCEL kCountdown|r|h", "PARTY")
    end
  else
    me.vars.cdLeftTime = me.vars.cdTime
    me.vars.cdRunning = true
    SendChatMessage("|H|h|cffff0000Starting kCountdown|r|h", "PARTY")
  end
  me.vars.updateSpeed = 1
end

_G["kCountdown"] = me