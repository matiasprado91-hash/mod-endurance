//================================================================================
// RecipeManufactureWnd.
//================================================================================

class RecipeManufactureWnd extends UIScript;

var int m_RecipeID;
var int m_SuccessRate;
var int m_RecipeBookClass;
var int m_MaxMP;
var int m_PlayerID;
var UICommonAPI UICommonAPI;
var WindowHandle Me;
var CheckBoxHandle CreateAuto;
var EditBoxHandle QuantityBox;
var ButtonHandle BtnManufacture;
var bool bIsAuto;
var bool bIsProcess;
var string CurrentItem;
var int Quantity;
const RECIPEWND_MAX_MP_WIDTH= 165.0f;

function OnLoad ()
{
  RegisterEvent(840);
  RegisterEvent(210);
  RegisterEvent(2600);
  RegisterEvent(2610);
  RegisterEvent(580);
  UICommonAPI = UICommonAPI(GetScript("UICommonAPI"));
  Me = GetHandle("RecipeManufactureWnd");
  CreateAuto = CheckBoxHandle(GetHandle("RecipeManufactureWnd.Checkbox_CreateAuto"));
  QuantityBox = EditBoxHandle(GetHandle("RecipeManufactureWnd.QuantityBox"));
  BtnManufacture = ButtonHandle(GetHandle("RecipeManufactureWnd.BtnManufacture"));
  CreateAuto.SetTitle(" Multi Create");
}

function OnShow ()
{
  SetFocus();
  QuantityBox.SetString("");
}

function OnClickCheckBox (string strID)
{
  switch (strID)
  {
    case "Checkbox_CreateAuto":
    SetFocus();
    if ( CreateAuto.IsChecked() )
    {
      bIsAuto = True;
    } else {
      bIsAuto = False;
    }
    break;
    default:
  }
}

function OnChangeEditBox (string strID)
{
  switch (strID)
  {
    case "QuantityBox":
    Quantity = int(QuantityBox.GetString());
    if ( bIsProcess )
    {
      if ( (int(QuantityBox.GetString()) == 0) || (QuantityBox.GetString() == "") )
      {
        HandleStopProcess();
      }
    }
    break;
    default:
  }
}

function OnEvent (int Event_ID, string param)
{
  local Rect rectWnd;
  local int ServerID;
  local int MPValue;
  local int RecipeID;
  local int currentMP;
  local int maxMP;
  local int MakingResult;
  local int Type;

  if ( Event_ID == 840 )
  {
    Class'UIAPI_WINDOW'.static.HideWindow("RecipeBookWnd");
    Clear();
    rectWnd = Class'UIAPI_WINDOW'.static.GetRect("RecipeBookWnd");
    Class'UIAPI_WINDOW'.static.MoveTo("RecipeManufactureWnd",rectWnd.nX,rectWnd.nY);
    Class'UIAPI_WINDOW'.static.ShowWindow("RecipeManufactureWnd");
    Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd");
    ParseInt(param,"RecipeID",RecipeID);
    ParseInt(param,"CurrentMP",currentMP);
    ParseInt(param,"MaxMP",maxMP);
    ParseInt(param,"MakingResult",MakingResult);
    ParseInt(param,"Type",Type);
    ReceiveRecipeItemMakeInfo(RecipeID,currentMP,maxMP,MakingResult,Type);
  } else {
    if ( Event_ID == 210 )
    {
      ParseInt(param,"ServerID",ServerID);
      ParseInt(param,"CurrentMP",MPValue);
      if ( (m_PlayerID == ServerID) && (m_PlayerID > 0) )
      {
        SetMPBar(MPValue);
      }
    } else {
      if ( (Event_ID == 2600) || (Event_ID == 2610) )
      {
        HandleInventoryItem(param);
      } else {
        if ( Event_ID == 580 )
        {
          if ( bIsProcess )
          {
            HandleAutoCraft(param);
          }
        }
      }
    }
  }
}

function OnClickButton (string strID)
{
  local string param;

  switch (strID)
  {
    case "BtnClose":
    case "BtnClose2":
    CloseWindow();
    break;
    case "BtnPrev":
    Class'RecipeAPI'.static.RequestRecipeBookOpen(m_RecipeBookClass);
    CloseWindow();
    break;
    case "BtnRecipeTree":
    if ( Class'UIAPI_WINDOW'.static.IsShowWindow("RecipeTreeWnd") )
    {
      Class'UIAPI_WINDOW'.static.HideWindow("RecipeTreeWnd");
    } else {
      ParamAdd(param,"RecipeID",string(m_RecipeID));
      ParamAdd(param,"SuccessRate",string(m_SuccessRate));
      ExecuteEvent(810,param);
    }
    break;
    case "BtnManufacture":
    if ( bIsProcess )
    {
      HandleStopProcess();
      return;
    }
    if ( bIsAuto && (int(QuantityBox.GetString()) != 0) && bIsAuto && (QuantityBox.GetString() != "") )
    {
      HandleStartProcess();
    } else {
      Class'RecipeAPI'.static.RequestRecipeItemMakeSelf(m_RecipeID);
    }
    break;
    default:
  }
}

function HandleStartProcess ()
{
  Me.SetTimer(1,250);
  BtnManufacture.SetButtonName(1514);
  bIsProcess = True;
}

function HandleStopProcess ()
{
  Me.KillTimer(1);
  BtnManufacture.SetButtonName(645);
  bIsProcess = False;
}

function OnTimer (int TimerID)
{
  if ( TimerID == 1 )
  {
    Me.KillTimer(1);
    Me.SetTimer(1,250);
    Class'RecipeAPI'.static.RequestRecipeItemMakeSelf(m_RecipeID);
  }
  if ( TimerID == 2 )
  {
    Me.KillTimer(2);
    HandleStartProcess();
  }
}

function HandleAutoCraft (string a_Param)
{
  local int Index;
  local string text;

  ParseInt(a_Param,"Index",Index);
  switch (Index)
  {
    case 614:
    HandleStopProcess();
    break;
    case 54:
    ParseString(a_Param,"Param1",text);
    if ( text == CurrentItem )
    {
      Quantity--;
      QuantityBox.SetString(string(Quantity));
    }
    break;
    case 24:
    if ( (int(QuantityBox.GetString()) != 0) || (QuantityBox.GetString() != "") )
    {
      Me.SetTimer(2,6500);
    }
    default:
  }
}

function CloseWindow ()
{
  Clear();
  Class'UIAPI_WINDOW'.static.HideWindow("RecipeManufactureWnd");
  PlayConsoleSound(IFST_WINDOW_CLOSE);
  HandleStopProcess();
}

function Clear ()
{
  m_RecipeID = 0;
  m_SuccessRate = 0;
  m_RecipeBookClass = 0;
  m_MaxMP = 0;
  m_PlayerID = 0;
  Class'UIAPI_ITEMWINDOW'.static.Clear("RecipeManufactureWnd.ItemWnd");
}

function ReceiveRecipeItemMakeInfo (int RecipeID, int currentMP, int maxMP, int MakingResult, int Type)
{
  local int i;
  local string strTmp;
  local int nTmp;
  local int ProductID;
  local int ProductNum;
  local string ItemName;
  local ParamStack param;
  local ItemInfo infItem;

  m_RecipeID = RecipeID;
  m_SuccessRate = Class'UIDATA_RECIPE'.static.GetRecipeSuccessRate(RecipeID);
  m_RecipeBookClass = Type;
  m_MaxMP = maxMP;
  m_PlayerID = Class'UIDATA_PLAYER'.static.GetPlayerID();
  ProductID = Class'UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
  strTmp = Class'UIDATA_ITEM'.static.GetItemTextureName(ProductID);
  class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeManufactureWnd.texItem",strTmp);
  ItemName = MakeFullItemName(ProductID);
  CurrentItem = ItemName;
  nTmp = Class'UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
  strTmp = GetItemGradeString(nTmp);
  if ( Len(strTmp) > 0 )
  {
    strTmp = "`" $ strTmp $ "`";
  }
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtName",ItemName $ " " $ strTmp);
  nTmp = Class'UIDATA_RECIPE'.static.GetRecipeMpConsume(RecipeID);
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtMPConsume","" $ string(nTmp));
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtSuccessRate",string(m_SuccessRate) $ "%");
  ProductNum = Class'UIDATA_RECIPE'.static.GetRecipeProductNum(RecipeID);
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtResultValue","" $ string(ProductNum));
  SetMPBar(currentMP);
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtCountValue","" $ string(GetInventoryItemCount(ProductID)));
  strTmp = "";
  if ( MakingResult == 0 )
  {
    strTmp = MakeFullSystemMsg(GetSystemMessage(960),ItemName,"");
    if ( bIsProcess )
    {
      HandleStopProcess();
    }
  } else {
    if ( MakingResult == 1 )
    {
      strTmp = MakeFullSystemMsg(GetSystemMessage(959),ItemName,"" $ string(ProductNum));
    }
  }
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtMsg",strTmp);
  param = Class'UIDATA_RECIPE'.static.GetRecipeMaterialItem(RecipeID);
  nTmp = param.GetInt();
  i = 0;
  JL0378:
  if ( i < nTmp )
  {
    infItem.ClassID = param.GetInt();
    infItem.Reserved = param.GetInt();
    infItem.Name = Class'UIDATA_ITEM'.static.GetItemName(infItem.ClassID);
    infItem.AdditionalName = Class'UIDATA_ITEM'.static.GetItemAdditionalName(infItem.ClassID);
    infItem.IconName = Class'UIDATA_ITEM'.static.GetItemTextureName(infItem.ClassID);
    infItem.Description = Class'UIDATA_ITEM'.static.GetItemDescription(infItem.ClassID);
    infItem.ItemNum = GetInventoryItemCount(infItem.ClassID);
    if ( infItem.Reserved > infItem.ItemNum )
    {
      infItem.bDisabled = True;
    } else {
      infItem.bDisabled = False;
    }
    Class'UIAPI_ITEMWINDOW'.static.AddItem("RecipeManufactureWnd.ItemWnd",infItem);
    i++;
    goto JL0378;
  }
}

function SetMPBar (int currentMP)
{
  local int nTmp;
  local int nMPWidth;

  nTmp = 165 * currentMP;
  nMPWidth = nTmp / m_MaxMP;
  if ( nMPWidth > 165.0 )
  {
    nMPWidth = 165;
  }
  Class'UIAPI_WINDOW'.static.SetWindowSize("RecipeManufactureWnd.texMPBar",nMPWidth,12);
}

function HandleInventoryItem (string param)
{
  local int ClassID;
  local int idx;
  local ItemInfo infItem;

  if ( ParseInt(param,"classID",ClassID) )
  {
    idx = Class'UIAPI_ITEMWINDOW'.static.FindItemWithClassID("RecipeManufactureWnd.ItemWnd",ClassID);
    if ( idx > -1 )
    {
      Class'UIAPI_ITEMWINDOW'.static.GetItem("RecipeManufactureWnd.ItemWnd",idx,infItem);
      infItem.ItemNum = GetInventoryItemCount(infItem.ClassID);
      if ( infItem.Reserved > infItem.ItemNum )
      {
        infItem.bDisabled = True;
      } else {
        infItem.bDisabled = False;
      }
      Class'UIAPI_ITEMWINDOW'.static.SetItem("RecipeManufactureWnd.ItemWnd",idx,infItem);
    }
  }
}

function SetFocus ()
{
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TexItem");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtName");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtMPMid");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtMPConsume");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtMPCost");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtSuccess");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtSuccessMid");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtSuccessRate");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtResult2");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtResult");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtResultMid");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtResultValue");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtChunk");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtMP");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TexMPBar");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtCount");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtCountValue");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtMsg");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.ItemWnd");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TexOutLine");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.BtnRecipeTree");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.BtnManufacture");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.BtnPrev");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.BtnClose");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.BtnClose2");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.TxtCountMid");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd.QuantityBox");
}

function int GetRecipeID (int ClassID)
{
  switch (ClassID)
  {
    case 1894:
    return 41;
    case 1895:
    return 42;
    default:
  }
}
defaultproperties
{
}
