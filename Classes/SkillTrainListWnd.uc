class SkillTrainListWnd extends UICommonAPI;

//////////////////////////////////////////////////////////////////////////////
// CONST
//////////////////////////////////////////////////////////////////////////////
const NORMAL_SKILL=0;		// ????????
const FISHING_SKILL=1;		// ???? ????
const CLAN_SKILL=2;		// ????????
const ENCHANT_SKILL=3;

const OFFSET_X_ICON_TEXTURE=0;
const OFFSET_Y_ICON_TEXTURE=4;
const OFFSET_Y_SECONDLINE = -14;

var int m_iType;

var int m_iState;
var int m_iRootNameLength;
var WindowHandle	m_SkillTrainListWnd;

//var NPHRN_SkillTrainWnd NPHRN_SkillTrainWnd;

var bool EnchantDialogOpened;

function OnLoad()
{
	RegisterEvent( EV_SkillTrainListWndShow );
	RegisterEvent( EV_SkillTrainListWndHide );
	RegisterEvent( EV_SkillTrainListWndAddSkill );
	
	m_SkillTrainListWnd= GetHandle("SkillTrainListWnd.SkillTrainListTree");
	
//	NPHRN_SkillTrainWnd = NPHRN_SkillTrainWnd(GetScript("NPHRN_SkillTrainWnd"));
}

function OnClickButton( string strItemID )
{
	local string strID_Level;
	local string strID;
	local string strLevel;
	local int iID;
	local int iLevel;
	local int iIdxComma;
	local int iLength;

	strID_Level = Mid(strItemID, m_iRootNameLength+1);
	iLength=Len(strID_Level);
//	debug("????:"$strTemp$", ????:"$iLength);
	iIdxComma=InStr(strID_Level, ",");

	strID=Left(strID_Level, iIdxComma);
	strLevel=Right(strID_Level, iLength-iIdxComma-1);

//	debug("iIdxComma:"$iIdxComma$", iLength-iIdxComma:"$(iLength-iIdxComma));
//	debug("ID:"$int(strID)$", Level:"$int(strLevel));

	iID=int(strID);
	iLevel=int(strLevel);

	switch(m_iType)
	{
	case NORMAL_SKILL :
	case FISHING_SKILL :
	case CLAN_SKILL :
		RequestAcquireSkillInfo(iID, iLevel, m_iType);
		break;
	case ENCHANT_SKILL :
		RequestExEnchantSkillInfo(iID, iLevel);
		break;
	}
	HideWindow("SkillTrainListWnd");
	m_SkillTrainListWnd.SetScrollPosition(0); // ???????? ??????
}

// ???? ??????
function Clear()
{
	class'UIAPI_TREECTRL'.static.Clear("SkillTrainListWnd.SkillTrainListTree");
}

function OnEvent(int Event_ID, string param)
{
	local int iType;

	local string strIconName;
	local string strName;
	local int iID;
	local int iLevel;
	local int iSPConsume;

	local string strEnchantName;

	switch(Event_ID)
	{
	case EV_SkillTrainListWndShow :
		ParseInt(param, "Type"	, iType);
		Clear();
		m_iType=iType;

		if(IsShowWindow("SkillTrainInfoWnd"))
			HideWindow("SkillTrainInfoWnd");

		ShowSkillTrainListWnd(iType);
		break;

	case EV_SkillTrainListWndAddSkill :
		ParseString(param, "strIconName", strIconName); 
		ParseString(param, "strName", strName);
		ParseInt(param, "iID", iID);
		ParseInt(param, "iLevel", iLevel);
		ParseInt(param, "iSPConsume", iSPConsume);
		ParseString(param, "strEnchantName", strEnchantName);

		AddSkillTrainListItem(strIconName, strName, iID, iLevel, iSPConsume, strEnchantName);
		break;

	case EV_SkillTrainListWndHide :
		if(IsShowWindow("SkillTrainListWnd"))
			HideWindow("SkillTrainListWnd");
		break;
	}
}

function OnShow()
{
	if(m_iType==ENCHANT_SKILL)
	{
		HideWindow("SkillTrainListWnd.txtSPString");
		HideWindow("SkillTrainListWnd.txtSP");
	}
	else
	{
		ShowWindow("SkillTrainListWnd.txtSPString");
		ShowWindow("SkillTrainListWnd.txtSP");
	}
	EnchantDialogOpened = True;
/*	if ( NPHRN_SkillTrainWnd.EnableSkillProcess )
	{
		HideWindow("SkillTrainListWnd");
	}*/
}

// ???? ???????? ?????? ?????? ????
function ShowSkillTrainListWnd(int iType)
{
	local XMLTreeNodeInfo	infNode;
	local string strTmp;
	local int iWindowTitle;
	local int iSPIdx;

	local UserInfo infoPlayer;
	local int iPlayerSP;

	GetPlayerInfo(infoPlayer);

	switch(m_iType)
	{
	case NORMAL_SKILL :
	case FISHING_SKILL :
	case ENCHANT_SKILL :
		iWindowTitle=477;
		iSPIdx=92;
		iPlayerSP=infoPlayer.nSP;
		break;
	case CLAN_SKILL :
		iWindowTitle=1436;
		iSPIdx=1372;
		iPlayerSP=GetClanNameValue(infoPlayer.nClanID);
		break;
	}

	class'UIAPI_WINDOW'.static.SetWindowTitle("SkillTrainListWnd", iWindowTitle);					// ???? ?????? ????
	if(m_iType!=ENCHANT_SKILL)
	{
		class'UIAPI_TEXTBOX'.static.SetText("SkillTrainListWnd.txtSPString", GetSystemString(iSPIdx));	// SP or ?????????? ????
		class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainListWnd.txtSP", iPlayerSP);						// SP or ??????????
	}

	//?????? Root????
	infNode.strName = "SkillTrainListRoot";
	infNode.nOffSetX = 7;
	infNode.nOffSetY = 0;
	strTmp = class'UIAPI_TREECTRL'.static.InsertNode("SkillTrainListWnd.SkillTrainListTree", "", infNode);
	if (Len(strTmp) < 1)
	{
		debug("ERROR: Can't insert root node. Name: " $ infNode.strName);
		return;
	}

	m_iRootNameLength=Len(infNode.strName);

	class'UIAPI_WINDOW'.static.ShowWindow("SkillTrainListWnd");
	class'UIAPI_WINDOW'.static.SetFocus("SkillTrainListWnd");
}

function AddSkillTrainListItem(string strIconName, string strName, int iID, int iLevel, int iSPConsume, string strEnchantName)
{
	local XMLTreeNodeInfo	infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo	infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;

	local string strRetName;

	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//Insert Node - with No Button
	infNode = infNodeClear;
	infNode.strName = ""$ iID $","$ iLevel;
	infNode.bShowButton = 0;

	//Expand?????????? BackTexture????
	//?????????? ?????? ?????? ExpandedWidth?? ????. ?????? -2???? ?????? ??????.
	infNode.nTexExpandedOffSetX = -7;		//OffSet
	infNode.nTexExpandedOffSetY = 2;		//OffSet
	infNode.nTexExpandedHeight = 38;		//Height
	infNode.nTexExpandedRightWidth = 0;		//?????? ???????????????? ????
	infNode.nTexExpandedLeftUWidth = 32; 		//?????????? ???? ???? ???????? UV????
	infNode.nTexExpandedLeftUHeight = 38;
	infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";

	strRetName = class'UIAPI_TREECTRL'.static.InsertNode("SkillTrainListWnd.SkillTrainListTree", "SkillTrainListRoot", infNode);
	if (Len(strRetName) < 1)
	{
		debug("ERROR: Can't insert node. Name: " $ infNode.strName);
		return;
	}

	//Insert Node Item - ?????? ?????? ?????? ???? ??????
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = OFFSET_X_ICON_TEXTURE;
	infNodeItem.nOffSetY = OFFSET_Y_ICON_TEXTURE;
	infNodeItem.u_nTextureWidth = 34;
	infNodeItem.u_nTextureHeight = 34;
	infNodeItem.u_strTexture = "l2ui_ch3.InventoryWnd.Inventory_OutLine";

	InsertNodeItem(strRetName, infNodeItem);

	//Insert Node Item - ?????? ?????? ?????? ?????? ??????
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -33;
	infNodeItem.nOffSetY = OFFSET_Y_ICON_TEXTURE;
	infNodeItem.u_nTextureWidth = 35;
	infNodeItem.u_nTextureHeight = 35;
	infNodeItem.u_strTexture = "l2ui_ch3.InventoryWnd.Inventory_OutLine";

	InsertNodeItem(strRetName, infNodeItem);

	//Insert Node Item - ?????? ??????
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -35;
	infNodeItem.nOffSetY = OFFSET_Y_ICON_TEXTURE+1;
	infNodeItem.u_nTextureWidth = 32;
	infNodeItem.u_nTextureHeight = 32;
	infNodeItem.u_strTexture = strIconName;

	InsertNodeItem(strRetName, infNodeItem);



	//Insert Node Item - ?????? ????
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = strName;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 3;
	infNodeItem.nOffSetY = 10;

	InsertNodeItem(strRetName, infNodeItem);

	switch(m_iType)
	{
	case NORMAL_SKILL :
	case FISHING_SKILL :
	case CLAN_SKILL :
		//Insert Node Item - "Lv"
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = GetSystemString(88);
		infNodeItem.bLineBreak = true;
		infNodeItem.t_bDrawOneLine = true;
		infNodeItem.nOffSetX = 37;
		infNodeItem.nOffSetY = OFFSET_Y_SECONDLINE;

		infNodeItem.t_color.R = 163;
		infNodeItem.t_color.G = 163;
		infNodeItem.t_color.B = 163;
		infNodeItem.t_color.A = 255;
		InsertNodeItem(strRetName, infNodeItem);

		//Insert Node Item - ????
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = string(iLevel);
		infNodeItem.nOffSetX = 2;
		infNodeItem.nOffSetY = OFFSET_Y_SECONDLINE;

		infNodeItem.t_color.R = 176;
		infNodeItem.t_color.G = 155;
		infNodeItem.t_color.B = 121;
		infNodeItem.t_color.A = 255;
		InsertNodeItem(strRetName, infNodeItem);

		//Insert Node Item - "????SP:"
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;

		switch(m_iType)
		{
		case NORMAL_SKILL :
		case FISHING_SKILL :
			infNodeItem.t_strText = GetSystemString(365)$" : ";
			break;
		case CLAN_SKILL :
			infNodeItem.t_strText = GetSystemString(1437)$" : ";
			break;
		}
		infNodeItem.bLineBreak = true;
		infNodeItem.nOffSetX = 77;
		infNodeItem.nOffSetY = OFFSET_Y_SECONDLINE;

		infNodeItem.t_color.R = 163;
		infNodeItem.t_color.G = 163;
		infNodeItem.t_color.B = 163;
		infNodeItem.t_color.A = 255;
		InsertNodeItem(strRetName, infNodeItem);

		//Insert Node Item - ????SP
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = string(iSPConsume);
		infNodeItem.nOffSetX = 0;
		infNodeItem.nOffSetY = OFFSET_Y_SECONDLINE;

		infNodeItem.t_color.R = 176;
		infNodeItem.t_color.G = 155;
		infNodeItem.t_color.B = 121;
		infNodeItem.t_color.A = 255;
		InsertNodeItem(strRetName, infNodeItem);
		break;
	case ENCHANT_SKILL :
		//Insert Node Item - ????SP
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.bLineBreak = true;
		infNodeItem.t_bDrawOneLine = true;

		infNodeItem.t_strText = strEnchantName;
		infNodeItem.nOffSetX = 37;
		infNodeItem.nOffSetY = OFFSET_Y_SECONDLINE;

		infNodeItem.t_color.R = 176;
		infNodeItem.t_color.G = 155;
		infNodeItem.t_color.B = 121;
		infNodeItem.t_color.A = 255;
		InsertNodeItem(strRetName, infNodeItem);
		break;
	}
}

function InsertNodeItem(string strNodeName, XMLTreeNodeItemInfo infNodeItemName)
{
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SkillTrainListWnd.SkillTrainListTree", strNodeName, infNodeItemName);
}
defaultproperties
{
}
