//================================================================================
// RecipeBuyManufactureWnd.
//================================================================================

class RecipeBuyManufactureWnd extends UIScript;

var int m_merchantID;
var int m_RecipeID;
var int m_SuccessRate;
var int m_Adena;
var int m_MaxMP;
const RECIPEWND_MAX_MP_WIDTH= 165.0f;

function OnLoad ()
{
  RegisterEvent(800);
  RegisterEvent(210);
  RegisterEvent(2600);
  RegisterEvent(2610);
}

function OnEvent (int Event_ID, string param)
{
  local Rect rectWnd;
  local int ServerID;
  local int MPValue;
  local int MerchantID;
  local int RecipeID;
  local int currentMP;
  local int maxMP;
  local int MakingResult;
  local int Adena;

  if ( Event_ID == 800 )
  {
    Class'UIAPI_WINDOW'.static.HideWindow("RecipeBuyListWnd");
    Clear();
    rectWnd = Class'UIAPI_WINDOW'.static.GetRect("RecipeBuyListWnd");
    Class'UIAPI_WINDOW'.static.MoveTo("RecipeBuyManufactureWnd",rectWnd.nX,rectWnd.nY);
    Class'UIAPI_WINDOW'.static.ShowWindow("RecipeBuyManufactureWnd");
    Class'UIAPI_WINDOW'.static.SetFocus("RecipeBuyManufactureWnd");
    ParseInt(param,"MerchantID",MerchantID);
    ParseInt(param,"RecipeID",RecipeID);
    ParseInt(param,"CurrentMP",currentMP);
    ParseInt(param,"MaxMP",maxMP);
    ParseInt(param,"MakingResult",MakingResult);
    ParseInt(param,"Adena",Adena);
    ReceiveRecipeShopSellList(MerchantID,RecipeID,currentMP,maxMP,MakingResult,Adena);
  } else {
    if ( Event_ID == 210 )
    {
      ParseInt(param,"ServerID",ServerID);
      ParseInt(param,"CurrentMP",MPValue);
      if ( (m_merchantID == ServerID) && (m_merchantID > 0) )
      {
        SetMPBar(MPValue);
      }
    } else {
      if ( (Event_ID == 2600) || (Event_ID == 2610) )
      {
        HandleInventoryItem(param);
      }
    }
  }
}

function OnClickButton (string strID)
{
  local string param;

  switch (strID)
  {
    case "btnClose":
    CloseWindow();
    break;
    case "btnPrev":
    Class'RecipeAPI'.static.RequestRecipeShopSellList(m_merchantID);
    CloseWindow();
    break;
    case "btnRecipeTree":
    if ( Class'UIAPI_WINDOW'.static.IsShowWindow("RecipeTreeWnd") )
    {
      Class'UIAPI_WINDOW'.static.HideWindow("RecipeTreeWnd");
    } else {
      ParamAdd(param,"RecipeID",string(m_RecipeID));
      ParamAdd(param,"SuccessRate",string(m_SuccessRate));
      ExecuteEvent(810,param);
    }
    break;
    case "btnManufacture":
    Class'RecipeAPI'.static.RequestRecipeShopMakeDo(m_merchantID,m_RecipeID,m_Adena);
    break;
    default:
  }
}

function CloseWindow ()
{
  Clear();
  Class'UIAPI_WINDOW'.static.HideWindow("RecipeBuyManufactureWnd");
  PlayConsoleSound(IFST_WINDOW_CLOSE);
}

function Clear ()
{
  m_merchantID = 0;
  m_RecipeID = 0;
  m_SuccessRate = 0;
  m_Adena = 0;
  m_MaxMP = 0;
  Class'UIAPI_ITEMWINDOW'.static.Clear("RecipeBuyManufactureWnd.ItemWnd");
}

function ReceiveRecipeShopSellList (int MerchantID, int RecipeID, int currentMP, int maxMP, int MakingResult, int Adena)
{
  local int i;
  local string strTmp;
  local int nTmp;
  local int ProductID;
  local int ProductNum;
  local string ItemName;
  local ParamStack param;
  local ItemInfo infItem;

  m_merchantID = MerchantID;
  m_RecipeID = RecipeID;
  m_SuccessRate = Class'UIDATA_RECIPE'.static.GetRecipeSuccessRate(RecipeID);
  m_Adena = Adena;
  m_MaxMP = maxMP;
  strTmp = GetSystemString(663) $ " - " $ Class'UIDATA_USER'.static.GetUserName(MerchantID);
  Class'UIAPI_WINDOW'.static.SetWindowTitleByText("RecipeBuyManufactureWnd",strTmp);
  ProductID = Class'UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
  strTmp = Class'UIDATA_ITEM'.static.GetItemTextureName(ProductID);
  class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeBuyManufactureWnd.texItem",strTmp);
  ItemName = MakeFullItemName(ProductID);
  nTmp = Class'UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
  strTmp = GetItemGradeString(nTmp);
  if ( Len(strTmp) > 0 )
  {
    strTmp = "`" $ strTmp $ "`";
  }
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtName",ItemName $ " " $ strTmp);
  nTmp = Class'UIDATA_RECIPE'.static.GetRecipeMpConsume(RecipeID);
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtMPConsume","" $ string(nTmp));
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtSuccessRate",string(m_SuccessRate) $ "%");
  ProductNum = Class'UIDATA_RECIPE'.static.GetRecipeProductNum(RecipeID);
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtResultValue","" $ string(ProductNum));
  SetMPBar(currentMP);
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtCountValue","" $ string(GetInventoryItemCount(ProductID)));
  strTmp = "";
  if ( MakingResult == 0 )
  {
    strTmp = MakeFullSystemMsg(GetSystemMessage(960),ItemName,"");
  } else {
    if ( MakingResult == 1 )
    {
      strTmp = MakeFullSystemMsg(GetSystemMessage(959),ItemName,"" $ string(ProductNum));
    }
  }
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtMsg",strTmp);
  param = Class'UIDATA_RECIPE'.static.GetRecipeMaterialItem(RecipeID);
  nTmp = param.GetInt();
  i = 0;
  JL03C4:
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
    Class'UIAPI_ITEMWINDOW'.static.AddItem("RecipeBuyManufactureWnd.ItemWnd",infItem);
    i++;
    goto JL03C4;
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
  Class'UIAPI_WINDOW'.static.SetWindowSize("RecipeBuyManufactureWnd.texMPBar",nMPWidth,12);
}

function HandleInventoryItem (string param)
{
  local int ClassID;
  local int idx;
  local ItemInfo infItem;

  if ( ParseInt(param,"classID",ClassID) )
  {
    idx = Class'UIAPI_ITEMWINDOW'.static.FindItemWithClassID("RecipeBuyManufactureWnd.ItemWnd",ClassID);
    if ( idx > -1 )
    {
      Class'UIAPI_ITEMWINDOW'.static.GetItem("RecipeBuyManufactureWnd.ItemWnd",idx,infItem);
      infItem.ItemNum = GetInventoryItemCount(infItem.ClassID);
      if ( infItem.Reserved > infItem.ItemNum )
      {
        infItem.bDisabled = True;
      } else {
        infItem.bDisabled = False;
      }
      Class'UIAPI_ITEMWINDOW'.static.SetItem("RecipeBuyManufactureWnd.ItemWnd",idx,infItem);
    }
  }
}
defaultproperties
{
}
