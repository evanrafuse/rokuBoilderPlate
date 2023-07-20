function init()
 ? "Initializing componentTemplate"
end function

function OnKeyEvent(key, press) as Boolean
  result = false
  if press
    ? key
  end if
  return result
end function
