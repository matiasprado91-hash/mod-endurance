//================================================================================
// ContextMenuWnd.
//================================================================================

class ContextMenuWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle textName;
var ButtonHandle btn_Context[4];
var string TargetName;
var int contextType;
var int targetID;
const BTN_COUNT= 4;

function OnLoad ()
{
  local int i;

  Me = GetHandle("ContextMenuWnd");
  textName = TextBoxHandle(GetHandle("ContextMenuWnd.textContestName"));
  i = 0;
  if ( i < 4 )
  {
    btn_Context[i] = ButtonHandle(GetHandle(("ContextMenuWnd.btnContext" $ string(i))));
    i++;
    
  }
  contextType = 0;
  targetID = -1;
}

function OnClickButton (string strID)
{
  switch (strID)
  {
    case "btnContext0":
    OnContext0(contextType);
    break;
    case "btnContext1":
    OnContext1(contextType);
    break;
    case "btnContext2":
    OnContext2(contextType);
    break;
    case "btnContext3":
    OnContext3(contextType);
    break;
    default:
  }
}

function contextTypeSelect (int Type, int TargetIDin)
{
  contextType = Type;
  targetID = TargetIDin;
  TargetName = Class'UIAPI_NAMECTRL'.static.GetName("TargetStatusWnd.UserName");
  textName.SetText(TargetName);
  switch (Type)
  {
    case 1:
    onContextPlayer();
    break;
    case 2:
    onContextParty();
    break;
    case 3:
    onContextPet();
    break;
    default:
  }
}

function onContextPlayer ()
{
  btn_Context[0].SetButtonName(330);
  btn_Context[1].SetButtonName(362);
  btn_Context[2].SetButtonName(1695);
  btn_Context[3].SetButtonName(904);
}

function onContextParty ()
{
  SysDebug("Party");
}

function onContextPet ()
{
  SysDebug("Pet");
}

function OnContext0 (int Type)
{
  if ( Type == 1 )
  {
    RequestInviteParty(TargetName);
  }
  Me.HideWindow();
}

function OnContext1 (int Type)
{
  if ( Type == 1 )
  {
    ExecuteCommand("/trade");
  }
  Me.HideWindow();
}

function OnContext2(int Type)
{
    if (Type == 1)
    {
        SetChatMessage("\"" $ TargetName);
    }
    Me.HideWindow();
}


function OnContext3 (int Type)
{
  if ( Type == 1 )
  {
    ExecuteCommand(("/friendinvite" @ TargetName));
  }
  Me.HideWindow();
}

function OnLButtonDown (WindowHandle a_WindowHandle, int X, int Y)
{
  if ( a_WindowHandle == Me )
  {
    Me.HideWindow();
  }
}
defaultproperties
{
}
