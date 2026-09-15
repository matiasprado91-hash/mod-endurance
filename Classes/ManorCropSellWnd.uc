class ManorCropSellWnd extends UICommonAPI;


const CROP_NAME=0;
const MANOR_NAME=1;
const CROP_REMAIN_CNT=2;
const CROP_PRICE=3;
const PROCURE_TYPE=4;
const MY_CROP_CNT=5;
const SELL_CNT=6;
const CROP_LEVEL=7;
const REWARD_TYPE_1=8;
const REWARD_TYPE_2=9;

const COLUMN_CNT=10;

function OnLoad()
{
	RegisterEvent( EV_ManorCropSellWndShow );
	RegisterEvent( EV_ManorCropSellWndAddItem );
	RegisterEvent( EV_ManorCropSellWndSetCropSell );
}

function OnEvent( int Event_ID, string a_Param)
{
	switch( Event_ID )
	{
	case EV_ManorCropSellWndShow :
		if(IsShowWindow("ManorCropSellWnd"))
		{
			HideWindow("ManorCropSellWnd");
		}
		else
		{
			DeleteAll();		
			ShowWindowWithFocus("ManorCropSellWnd");
		}
		break;

	case  EV_ManorCropSellWndAddItem :
		HandleAddItem(a_Param);
		break;
	case EV_ManorCropSellWndSetCropSell :
		HandleSetCropSell(a_Param);
		break;
	}
}

function DeleteAll()
{
	class'UIAPI_LISTCTRL'.static.DeleteAllItem("ManorCropSellWnd.ManorCropSellListCtrl");
}

function OnDBClickListCtrlRecord( String strID )
{
	switch(strID)
	{
	case "ManorCropSellListCtrl" :
		OnChangeBtn();
		break;
	}
}

function OnClickButton(string strID)
{
	debug(" "$strID);

	switch(strID)
	{
	case "btnChangeSell" :
		OnChangeBtn();
		break;
	case "btnSell" :
		OnSellBtn();
		break;
	case "btnCancel" :
		HideWindow("ManorCropSellWnd");
		break;
	}
}

function OnSellBtn()
{
	local int RecordCount;
	local LVDataRecord record;
	local int SellCnt;	// ???? ?????? ????
	local int CropCnt;	// ???????? ?????? ????
	
	local int CropNum;
	

	local int i;

	local string param;

	RecordCount=class'UIAPI_LISTCTRL'.static.GetRecordCount("ManorCropSellWnd.ManorCropSellListCtrl");

	// ?????????? ?????? ???? ???? ?????? ?????? ????
	CropCnt=0;
	for(i=0; i<RecordCount; ++i)
	{
		record=class'UIAPI_LISTCTRL'.static.GetRecord("ManorCropSellWnd.ManorCropSellListCtrl", i);

		// ?????????? ???????? ??????
		SellCnt=int(record.LVDataList[SELL_CNT].szData);
		if(SellCnt>0)
			CropCnt++;
	}

	ParamAdd(param, "CropCnt", string(CropCnt));

	CropNum=0;
	// ?????? ?????? ?????? ???????? ??????
	for(i=0; i<RecordCount; ++i)
	{
		record=class'UIAPI_LISTCTRL'.static.GetRecord("ManorCropSellWnd.ManorCropSellListCtrl", i);

		// ?????????? ???????? ??????
		SellCnt=int(record.LVDataList[SELL_CNT].szData);
		if(SellCnt<=0)
			continue;

		ParamAdd(param, "CropServerID"$CropNum, string(record.nReserved3));
		ParamAdd(param, "CropID"$CropNum, string(record.nReserved2));
		ParamAdd(param, "ManorID"$CropNum,string(record.nReserved1));
		ParamAdd(param, "SellCount"$CropNum, record.LVDataList[SELL_CNT].szData);
		CropNum++;
	}

	//debug("RequestProcureCropList" $ param);
	RequestProcureCropList(param);

	HideWindow("ManorCropSellWnd");
}

function OnChangeBtn()
{
	local LVDataRecord record;
	local int SelectedIndex;
	local int CropID;
	local string ManorCropSellChangeWndString;

	local string param;
	
	SelectedIndex=class'UIAPI_LISTCTRL'.static.GetSelectedIndex("ManorCropSellWnd.ManorCropSellListCtrl");

	if(SelectedIndex==-1)
		return;

	record=class'UIAPI_LISTCTRL'.static.GetSelectedRecord("ManorCropSellWnd.ManorCropSellListCtrl");
	CropID=record.nReserved2;

	// ?????? ?????? ???? ????
	// ???? ?????? "manor_menu_select?ask=9&state=%d&time=0" <- %d ??????CropID ?? ??????
	ManorCropSellChangeWndString="manor_menu_select?ask=9&state="$string(CropID)$"&time=0";
	RequestBypassToServer(ManorCropSellChangeWndString);

	// ?????????? ???? ???????? ?????? ????????
	ParamAdd(param, "CropName", record.LVDataList[CROP_NAME].szData);
	ParamAdd(param, "RewardType1", record.LVDataList[REWARD_TYPE_1].szData);
	ParamAdd(param, "RewardType2", record.LVDataList[REWARD_TYPE_2].szData);

	ExecuteEvent(EV_ManorCropSellChangeWndSetCropNameAndRewardType, param);
}

function HandleAddItem(string a_Param)
{
	local LVDataRecord record;

	local string CropName;
	local string ManorName;
	local int CropRemainCnt;
	local int CropPrice;
	local int ProcureType;
	local int MyCropCnt;
	local int CropLevel;
	local string RewardType1;
	local string RewardType2;

	local int ManorID;
	local int CropID;
	local int CropServerID;

	record.LVDataList.Length=COLUMN_CNT;

	ParseString(a_Param, "CropName", CropName);
	ParseString(a_Param, "ManorName", ManorName);
	ParseInt(a_Param, "CropRemainCnt", CropRemainCnt);
	ParseInt(a_Param, "CropPrice", CropPrice);
	ParseInt(a_Param, "ProcureType", ProcureType);
	ParseInt(a_Param, "MyCropCnt", MyCropCnt);
	ParseInt(a_Param, "CropLevel", CropLevel);
	ParseString(a_Param, "RewardType1", RewardType1);
	ParseString(a_Param, "RewardType2", RewardType2);

	ParseInt(a_Param, "ManorID", ManorID);
	ParseInt(a_Param, "CropID", CropID);
	ParseInt(a_Param, "CropServerID", CropServerID);


//	debug("CropName"$CropName$"ManorName"$ManorName$"CropRemainCnt"$CropRemainCnt$"CropPrice"$CropPrice$"ProcureType"$ProcureType$"MyCropCnt"$MyCropCnt);

	record.LVDataList[CROP_NAME].szData=CropName;
	record.LVDataList[MANOR_NAME].szData=ManorName;
	record.LVDataList[CROP_REMAIN_CNT].szData=string(CropRemainCnt);
	record.LVDataList[CROP_PRICE].szData=string(CropPrice);
	record.LVDataList[PROCURE_TYPE].szData=string(ProcureType);
	record.LVDataList[MY_CROP_CNT].szData=string(MyCropCnt);
	record.LVDataList[SELL_CNT].szData="0";
	record.LVDataList[CROP_LEVEL].szData=string(CropLevel);
	record.LVDataList[REWARD_TYPE_1].szData=RewardType1;
	record.LVDataList[REWARD_TYPE_2].szData=RewardType2;
	record.nReserved1=ManorID;
	record.nReserved2=CropID;
	record.nReserved3=CropServerID;

	class'UIAPI_LISTCTRL'.static.InsertRecord( "ManorCropSellWnd.ManorCropSellListCtrl", record );
}

function HandleSetCropSell(string a_Param)
{
	local string SellCntString;
	local int ManorID;
	local string ManorName; 
	local string CropRemainCntString;
	local string CropPriceString;
	local string ProcureTypeString;
	local int SelectedIndex;

	local LVDataRecord record;

	ParseString(a_Param, "SellCntString", SellCntString);
	ParseInt(a_Param, "ManorID", ManorID);
	ParseString(a_Param, "ManorName", ManorName);
	ParseString(a_Param, "CropRemainCntString", CropRemainCntString);
	ParseString(a_Param, "CropPriceString", CropPriceString);
	ParseString(a_Param, "ProcureTypeString", ProcureTypeString);

	record=class'UIAPI_LISTCTRL'.static.GetSelectedRecord("ManorCropSellWnd.ManorCropSellListCtrl");

	record.LVDataList[MANOR_NAME].szData=ManorName;
	record.LVDataList[CROP_REMAIN_CNT].szData=CropRemainCntString;
	record.LVDataList[CROP_PRICE].szData=CropPriceString;
	record.LVDataList[PROCURE_TYPE].szData=ProcureTypeString;
	record.LVDataList[SELL_CNT].szData=SellCntString;
	record.nReserved1=ManorID;

	SelectedIndex=class'UIAPI_LISTCTRL'.static.GetSelectedIndex("ManorCropSellWnd.ManorCropSellListCtrl");

	class'UIAPI_LISTCTRL'.static.ModifyRecord("ManorCropSellWnd.ManorCropSellListCtrl", SelectedIndex, record);
}
defaultproperties
{
}
