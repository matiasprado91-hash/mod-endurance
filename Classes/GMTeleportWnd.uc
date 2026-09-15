//================================================================================
// GMTeleportWnd.
//================================================================================

class GMTeleportWnd extends UICommonAPI;

var WindowHandle Me;
var int i_TeleportCount;
var string lastLoc;
var int lastBtn;
const TreeName= "TeleportsInfo";
const MAX_TELEPORT= 100;

function OnLoad ()
{
  local string param;
  local int i;

  Me = xxGetWindowHandle("GMTeleportWnd");
  if ( !(GetINIString("TeleportList","0",param,"GMTeleport")) )
  {
    i = 0;
    while ( i < 100 )
    {
      SetINIString("TeleportList",string(i),"","GMTeleport");
      i++;
      
    }
  }
}

function OnShow ()
{
  HandleTeleportOpen();
}

function HandleTeleportOpen ()
{
  local int i;
  local string param;
  local string Name;
  local string Loc;

  RefreshINI("GMTeleport");

  TreeClear("TeleportsInfo");
  xxGetButtonHandle("GMTeleportWnd.btnGo").DisableWindow();
  xxGetButtonHandle("GMTeleportWnd.btnDel").DisableWindow();
  xxGetButtonHandle("GMTeleportWnd.btnSave").DisableWindow();
  lastLoc = "";
  lastBtn = -1;
  i_TeleportCount = 0;
  i = 0;
  while ( i < 100 )
  {
    if ( GetINIString("TeleportList",string(i),param,"GMTeleport") )
    {
      if ( !(ParseString(param,"Name",Name)) )
      {
        return;
      }
      ParseString(param,"Loc",Loc);
      if ( i_TeleportCount == 0 )
      {
        firstTeleport("TeleportsInfo");
      }
      addTeleport("TeleportsInfo",Name,i_TeleportCount,Loc);
      i_TeleportCount++;
    }
    i++;
    
  }
}

function addTeleport (string l_TREEName, string t_Name, int i_Line, string t_Loc)
{
  local XMLTreeNodeInfo infNode;
  local string strRetName;
  local string tmpTREEName;

  tmpTREEName = ("GMTeleportWnd." $ "TeleportsInfo");
  infNode.strName = string(i_Line);
  infNode.bFollowCursor = True;
  infNode.nOffSetY = 0;
  infNode.bShowButton = 0;
  infNode.nTexExpandedHeight = 30;
  infNode.nTexExpandedRightWidth = 5;
  infNode.nTexExpandedLeftUWidth = 30;
  infNode.nTexExpandedLeftUHeight = 30;
  infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
  strRetName = getxml(tmpTREEName,l_TREEName,infNode);
  if ( ((i_Line % 2) == 0) )
  {
    xxstx2k23(tmpTREEName,strRetName,"L2UI_CH3.Null",262,30);
  } else {
    xxstx2k23(tmpTREEName,strRetName,"L2UI_CH3.etc.GroupBox_df_LineBack",262,30);
  }
  xxstx2k23(tmpTREEName,strRetName,"L2UI_CH3.TeleportWnd.teleportIcon",15,15,-251,8);
    xxStxXml(tmpTREEName,strRetName,t_Name,7,8,0,True);
}

function firstTeleport (string l_TREEName)
{
  local XMLTreeNodeInfo infNode;
  local string tmpTREEName;
  local string val;

  tmpTREEName = ("GMTeleportWnd." $ "TeleportsInfo");

  TreeClear(tmpTREEName);
  infNode.strName = l_TREEName;
  infNode.nOffSetX = 0;
  infNode.nOffSetY = 0;
  val = getxml(tmpTREEName,"",infNode);
}

function OnClickButton (string Str)
{
  local string i_Teleport;
  local string param;
  local string Loc;
  local string Name;
  local Vector vLoc;

  if ( (InStr(Str,"TeleportsInfo") >= 0) )
  {
    i_Teleport = Mid(Str,(InStr(Str,".") + 1));
    if ( GetINIString("TeleportList",i_Teleport,param,"GMTeleport") )
    {
      ParseString(param,"Name",Name);
      ParseString(param,"Loc",Loc);
      vLoc = GetVectorLoc(Loc);
      lastLoc = Loc;
      lastBtn = int(i_Teleport);
      xxGetButtonHandle("GMTeleportWnd.btnGo").EnableWindow();
      xxGetButtonHandle("GMTeleportWnd.btnDel").EnableWindow();
      xxGetButtonHandle("GMTeleportWnd.btnSave").EnableWindow();
      EditBoxHandle("GMTeleportWnd.editName").SetString(Name);
      EditBoxHandle("GMTeleportWnd.editPosX").SetString(string(int(vLoc.X)));
      EditBoxHandle("GMTeleportWnd.editPosY").SetString(string(int(vLoc.Y)));
      EditBoxHandle("GMTeleportWnd.editPosZ").SetString(string(int(vLoc.Z)));
    }
    return;
  }
  switch (Str)
  {
    case "btnAdd":
    AddNewTeleport();
    break;
    case "btnDel":
    DeleteTeleport();
    break;
    case "btnGo":
    if ( lastLoc != "" )
    {
      ExecuteCommand(("//teleport " $ lastLoc));
    }
    break;
    case "btnSave":
    HandleSaveTeleport();
    break;
    default:
  }
}

function HandleSaveTeleport ()
{
  local string Name;
  local string X;
  local string Y;
  local string Z;
  local string param;

  Name = EditBoxHandle("GMTeleportWnd.editName").GetString();
  X = EditBoxHandle("GMTeleportWnd.editPosX").GetString();
  Y = EditBoxHandle("GMTeleportWnd.editPosY").GetString();
  Z = EditBoxHandle("GMTeleportWnd.editPosZ").GetString();
  param = (((" Name=" $ tpgm(Name)) $ " Loc=") $ tpgm(((((string(int(X)) $ " ") $ string(int(Y))) $ " ") $ string(int(Z)))));
  SetINIString("TeleportList",string(lastBtn),param,"GMTeleport");
  lastLoc = tpgm(((((string(int(X)) $ " ") $ string(int(Y))) $ " ") $ string(int(Z))));
  HandleTeleportOpen();
}

function Vector GetVectorLoc (string InString)
{
  local array<string> Substrings;
  local Vector ParsedVector;

  Substrings = xxlista23(InString," ");
  if ( Substrings.Length >= 3 )
  {
    ParsedVector.X = int(Substrings[0]);
    ParsedVector.Y = int(Substrings[1]);
    ParsedVector.Z = int(Substrings[2]);
  }
  return ParsedVector;
}

function AddNewTeleport ()
{
  local int i;
  local string param;
  local Vector Loc;

  i = 0;
  while ( i < 100 )
  {
    if ( GetINIString("TeleportList",string(i),param,"GMTeleport") )
    {
      if ( param == "" )
      {
        Loc = GetPlayerPosition();
        param = (((" Name=" $ tpgm(("Teleport Name " $ string(i)))) $ " Loc=") $ tpgm(((((string(int(Loc.X)) $ " ") $ string(int(Loc.Y))) $ " ") $ string(int(Loc.Z)))));
        SetINIString("TeleportList",string(i),param,"GMTeleport");
      } else {
        i++;
        
      }
    }
  }
  HandleTeleportOpen();
}

function DeleteTeleport ()
{
  local int i;
  local string param;
  local array<string> arrTmp;

  i = 0;
  while ( i < 100 )
  {
    if ( i == lastBtn )
    {
      return;
    }
    param = "";
    if ( GetINIString("TeleportList",string(i),param,"GMTeleport") )
    {
      arrTmp[arrTmp.Length] = param;
    }
JL006E:
    i++;
    
  }
  i = 0;
  while ( i < arrTmp.Length )
  {
    SetINIString("TeleportList",string(i),arrTmp[i],"GMTeleport");
    i++;
    
  }
  HandleTeleportOpen();
}
defaultproperties
{
}
