//================================================================================
// RecipeTreeWnd.
//================================================================================

class RecipeTreeWnd extends UICommonAPI;

function OnLoad ()
{
  RegisterEvent(810);
}

function OnEvent (int Event_ID, string param)
{
  local int RecipeID;
  local int SuccessRate;

  if ( Event_ID == 810 )
  {
    ParseInt(param,"RecipeID",RecipeID);
    ParseInt(param,"SuccessRate",SuccessRate);
    StartRecipeTreeWnd(RecipeID,SuccessRate);
  }
}

function OnClickButton (string strID)
{
  switch (strID)
  {
    case "btnClose":
    CloseWindow();
    break;
    default:
  }
}

function CloseWindow ()
{
  Clear();
  Class'UIAPI_WINDOW'.static.HideWindow("RecipeTreeWnd");
  PlayConsoleSound(IFST_WINDOW_CLOSE);
}

function Clear ()
{
  Class'UIAPI_TREECTRL'.static.Clear("RecipeTreeWnd.MainTree");
}

function StartRecipeTreeWnd (int RecipeID, int SuccessRate)
{
  Class'UIAPI_WINDOW'.static.ShowWindow("RecipeTreeWnd");
  Class'UIAPI_WINDOW'.static.SetFocus("RecipeTreeWnd");
  Clear();
  SetRecipeInfo(RecipeID,SuccessRate);
}

function SetRecipeInfo (int RecipeID, int SuccessRate)
{
  local string strTmp;
  local string strTmp2;
  local int nTmp;
  local XMLTreeNodeInfo infNode;
  local int ProductID;

  strTmp = Class'UIDATA_RECIPE'.static.GetRecipeIconName(RecipeID);
  if ( Len(strTmp) > 0 )
  {
    class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeTreeWnd.texIcon",strTmp);
  } else {
    class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeTreeWnd.texIcon","Default.BlackTexture");
  }
  ProductID = Class'UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
  strTmp = MakeFullItemName(ProductID);
  nTmp = Class'UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
  strTmp2 = GetItemGradeString(nTmp);
  if ( Len(strTmp2) > 0 )
  {
    strTmp2 = "`" $ strTmp2 $ "`";
  }
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtName",strTmp $ " " $ strTmp2);
  nTmp = Class'UIDATA_RECIPE'.static.GetRecipeMpConsume(RecipeID);
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtMPConsume","" $ string(nTmp));
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtSuccessRate",string(SuccessRate) $ "%");
  nTmp = Class'UIDATA_RECIPE'.static.GetRecipeLevel(RecipeID);
  Class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtLevel","Lv." $ string(nTmp));
  infNode.strName = "root";
  infNode.nOffSetX = 1;
  infNode.nOffSetY = 5;
  strTmp = Class'UIAPI_TREECTRL'.static.InsertNode("RecipeTreeWnd.MainTree","",infNode);
  if ( Len(strTmp) < 1 )
  {
    Debug("ERROR: Can't insert root node. Name: " $ infNode.strName);
    return;
  }
  AddRecipeItem(ProductID,SuccessRate,0,"root");
}

function AddRecipeItem (int ProductID, int SuccessRate, int NeedCount, string NodeName)
{
  local int i;
  local ParamStack param;
  local int nTmp;
  local string strTmp;
  local string strTmp2;
  local int nMax;
  local bool bIamRoot;
  local array<int> arrMatID;
  local array<int> arrMatRate;
  local array<int> arrMatNeedCount;
  local XMLTreeNodeInfo infNode;
  local XMLTreeNodeItemInfo infNodeItem;
  local XMLTreeNodeInfo infNodeClear;
  local XMLTreeNodeItemInfo infNodeItemClear;
  local string strRetName;

  strTmp = Class'UIDATA_RECIPE'.static.GetRecipeNameBy2Condition(ProductID,SuccessRate);
  if ( Len(strTmp) > 0 )
  {
    if ( NodeName == "root" )
    {
      bIamRoot = True;
    } else {
      bIamRoot = False;
    }
    infNode = infNodeClear;
    infNode.strName = "" $ string(ProductID) $ "_" $ string(SuccessRate);
    infNode.ToolTip = xxMakeTooltipSimpleText(strTmp);
    infNode.bFollowCursor = True;
    if (  !bIamRoot )
    {
      infNode.nOffSetX = 16;
    }
    infNode.bShowButton = 1;
    infNode.nTexBtnWidth = 12;
    infNode.nTexBtnHeight = 12;
    infNode.nTexBtnOffSetY = 10;
    infNode.strTexBtnExpand = "L2UI.RecipeWnd.TreePlus";
    infNode.strTexBtnCollapse = "L2UI.RecipeWnd.TreeMinus";
    strRetName = Class'UIAPI_TREECTRL'.static.InsertNode("RecipeTreeWnd.MainTree",NodeName,infNode);
    if ( Len(strRetName) < 1 )
    {
      Log("ERROR: Can't insert node. Name: " $ infNode.strName);
      return;
    }
    strTmp2 = Class'UIDATA_RECIPE'.static.GetRecipeIconNameBy2Condition(ProductID,SuccessRate);
    if ( Len(strTmp2) < 1 )
    {
      strTmp2 = "Default.BlackTexture";
    }
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = XTNITEM_TEXTURE;
    infNodeItem.nOffSetX = 2;
    infNodeItem.nOffSetY = 0;
    infNodeItem.u_nTextureWidth = 32;
    infNodeItem.u_nTextureHeight = 32;
    infNodeItem.u_strTexture = strTmp2;
    Class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree",strRetName,infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = XTNITEM_TEXTURE;
    infNodeItem.nOffSetX = -32;
    infNodeItem.nOffSetY = 0;
    infNodeItem.u_nTextureWidth = 32;
    infNodeItem.u_nTextureHeight = 32;
    infNodeItem.u_strTexture = "L2UI.RecipeWnd.RecipeTreeIconBack";
    infNodeItem.u_strTextureExpanded = "L2UI.RecipeWnd.RecipeTreeIconBack_click";
    Class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree",strRetName,infNodeItem);
    if (  !bIamRoot )
    {
      nTmp = GetInventoryItemCount(ProductID);
      if ( nTmp < NeedCount )
      {
        infNodeItem = infNodeItemClear;
        infNodeItem.eType = XTNITEM_TEXTURE;
        infNodeItem.nOffSetX = -32;
        infNodeItem.nOffSetY = 0;
        infNodeItem.u_nTextureWidth = 32;
        infNodeItem.u_nTextureHeight = 32;
        infNodeItem.u_strTexture = "Default.ChatBack";
        Class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree",strRetName,infNodeItem);
      }
    }
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = XTNITEM_TEXT;
    infNodeItem.t_strText = strTmp;
    infNodeItem.t_bDrawOneLine = True;
    infNodeItem.nOffSetX = 5;
    infNodeItem.nOffSetY = 4;
    Class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree",strRetName,infNodeItem);
    if (  !bIamRoot )
    {
      infNodeItem = infNodeItemClear;
      infNodeItem.eType = XTNITEM_TEXT;
      infNodeItem.t_strText = "(" $ string(nTmp) $ "/" $ string(NeedCount) $ ")";
      infNodeItem.bLineBreak = True;
      infNodeItem.nOffSetX = 51;
      infNodeItem.nOffSetY = -14;
      Class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree",strRetName,infNodeItem);
    }
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = XTNITEM_BLANK;
    infNodeItem.bStopMouseFocus = True;
    infNodeItem.b_nHeight = 6;
    Class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree",strRetName,infNodeItem);
    param = Class'UIDATA_RECIPE'.static.GetRecipeMaterialItemBy2Condition(ProductID,SuccessRate);
    nMax = param.GetInt();
    arrMatID.Length = nMax;
    arrMatRate.Length = nMax;
    arrMatNeedCount.Length = nMax;
    i = 0;
	JL0611:
    if ( i < nMax )
    {
      arrMatID[i] = param.GetInt();
      arrMatRate[i] = param.GetInt();
      arrMatNeedCount[i] = param.GetInt();
      i++;
      goto JL0611;
    }
    i = 0;
	JL0682:
    if ( i < nMax )
    {
      AddRecipeItem(arrMatID[i],arrMatRate[i],arrMatNeedCount[i],strRetName);
      i++;
      goto JL0682;
    }
  } else {
    strTmp = Class'UIDATA_ITEM'.static.GetItemName(ProductID);
    infNode = infNodeClear;
    infNode.strName = "" $ string(ProductID) $ "_" $ string(SuccessRate);
    infNode.nOffSetX = 30;
    infNode.ToolTip = xxMakeTooltipSimpleText(strTmp);
    infNode.bFollowCursor = True;
    infNode.bShowButton = 0;
    strRetName = Class'UIAPI_TREECTRL'.static.InsertNode("RecipeTreeWnd.MainTree",NodeName,infNode);
    if ( Len(strRetName) < 1 )
    {
      Log("ERROR: Can't insert node. Name: " $ infNode.strName);
      return;
    }
    strTmp2 = Class'UIDATA_ITEM'.static.GetItemTextureName(ProductID);
    if ( Len(strTmp2) < 1 )
    {
      strTmp2 = "Default.BlackTexture";
    }
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = XTNITEM_TEXTURE;
    infNodeItem.nOffSetX = 0;
    infNodeItem.nOffSetY = 0;
    infNodeItem.u_nTextureWidth = 32;
    infNodeItem.u_nTextureHeight = 32;
    infNodeItem.u_strTexture = strTmp2;
    Class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree",strRetName,infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = XTNITEM_TEXTURE;
    infNodeItem.nOffSetX = -32;
    infNodeItem.nOffSetY = 0;
    infNodeItem.u_nTextureWidth = 32;
    infNodeItem.u_nTextureHeight = 32;
    infNodeItem.u_strTexture = "L2UI.RecipeWnd.RecipeTreeIconDisableBack";
    Class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree",strRetName,infNodeItem);
    nTmp = GetInventoryItemCount(ProductID);
    if ( nTmp < NeedCount )
    {
      infNodeItem = infNodeItemClear;
      infNodeItem.eType = XTNITEM_TEXTURE;
      infNodeItem.nOffSetX = -32;
      infNodeItem.nOffSetY = 0;
      infNodeItem.u_nTextureWidth = 32;
      infNodeItem.u_nTextureHeight = 32;
      infNodeItem.u_strTexture = "Default.ChatBack";
      Class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree",strRetName,infNodeItem);
    }
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = XTNITEM_TEXT;
    infNodeItem.t_strText = strTmp;
    infNodeItem.t_bDrawOneLine = True;
    infNodeItem.nOffSetX = 5;
    infNodeItem.nOffSetY = 3;
    Class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree",strRetName,infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = XTNITEM_TEXT;
    infNodeItem.t_strText = "(" $ string(nTmp) $ "/" $ string(NeedCount) $ ")";
    infNodeItem.bLineBreak = True;
    infNodeItem.nOffSetX = 37;
    infNodeItem.nOffSetY = -14;
    Class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree",strRetName,infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = XTNITEM_BLANK;
    infNodeItem.bStopMouseFocus = True;
    infNodeItem.b_nHeight = 4;
    Class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree",strRetName,infNodeItem);
  }
}
defaultproperties
{
}
