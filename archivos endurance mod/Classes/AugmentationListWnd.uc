//================================================================================
// AugmentationListWnd.
//================================================================================

class AugmentationListWnd extends UICommonAPI;

var int UnknownID1;
var int UnknownID2;
var WindowHandle Me;
var ListCtrlHandle FoundList;
var ListCtrlHandle SelectedList;

function OnLoad ()
{
	local ButtonHandle btnHandle;

	btnHandle = ButtonHandle(GetHandle("AugmentationListWnd.BtnSave"));
	btnHandle.SetTooltipCustomType(xxMakeTooltipSimpleText("Save List As Favorites"));
	btnHandle = ButtonHandle(GetHandle("AugmentationListWnd.BtnLoad"));
	btnHandle.SetTooltipCustomType(xxMakeTooltipSimpleText("Load Favorites List"));
	btnHandle = ButtonHandle(GetHandle("AugmentationListWnd.BtnDel"));
	btnHandle.SetTooltipCustomType(xxMakeTooltipSimpleText("Remove All"));
	Me = GetHandle("AugmentationListWnd");
	FoundList = ListCtrlHandle(GetHandle("FoundList"));
	SelectedList = ListCtrlHandle(GetHandle("SelectedList"));
	UnknownID1 = 1453;
	UnknownID2 = 1654;
}

function OnChangeEditBox (string param)
{
	switch (param)
	{
		case "FoundBox":
			MaybeHandleFoundItems();
			if ( Len(Class'UIAPI_EDITBOX'.static.GetString("AugmentationListWnd.FoundBox")) != 0 )
			{
				Class'UIAPI_TEXTBOX'.static.SetText("AugmentationListWnd.FoundText","");
			} 
			else 
			{
				Class'UIAPI_TEXTBOX'.static.SetText("AugmentationListWnd.FoundText","Enter Item Skill Name");
			}
			break;
		default:
	}
}

function OnClickButton (string qq_param)
{
	switch (qq_param)
	{
		case "BtnSave":
			RecordsShit1();
			break;
		case "BtnLoad":
			SeemsGetInfoFromItemGrp();
			break;
		case "BtnDel":
			SelectedList.DeleteAllItem();
			break;
		default:
	}
}

function RecordsShit1 ()
{
	local int i;
	local LVDataRecord record;
	local string param;
	local string tmp;
	local int j;
	local string Name;
	local string textureStr;
	local string textureStr2;

	i = 0;
JL0007:
	if ( i < SelectedList.GetRecordCount() )
	{
		record = SelectedList.GetRecord(i);
		Name = record.LVDataList[0].szData;
		j = 0;
	JL0058:
		if ( j < Len(Name) )
		{
			if ( Mid(Name,j,1) == " " )
			{
				textureStr = Left(Name,j);
				textureStr2 = Right(Name,Len(Name) -j - 1);
				Name = textureStr$"_"$textureStr2;
				goto JL0057;
			}
			j++;
			goto JL0058;
		}
	JL0057:
		param = param$"Name"$string(i)$"="$Name$" ";
		tmp = tmp$"Type"$string(i)$"="$record.LVDataList[1].szData$" ";
		i++;
		goto JL0007;
	}
	SetINIString("Favorites","Name",param,"ItemSkillGrp.ini");
	SetINIString("Favorites","Type",tmp,"ItemSkillGrp.ini");
	SetINIInt("Favorites","Amount",SelectedList.GetRecordCount(),"ItemSkillGrp.ini");
}

function SeemsGetInfoFromItemGrp ()
{
	local int i;
	local int j;
	local LVDataRecord record;
	local string param;
	local string tmp;
	local int Amount;
	local string SeemsName;
	local string qq_param;
	local string Name;
	local string Type;
	local string Level;
	local string Id;
	local string textureStr;
	local string textureStr2;

	GetINIString("Favorites","Name",param,"ItemSkillGrp.ini");
	GetINIString("Favorites","Type",tmp,"ItemSkillGrp.ini");
	GetINIInt("Favorites","Amount",Amount,"ItemSkillGrp.ini");

	record.LVDataList.Length = UnknownID2 - UnknownID1;
	i = 0;
JL00A4:
	if ( i < Amount )
	{
		ParseString(param,"Name"$string(i),SeemsName);
		ParseString(tmp,"Type"$string(i),qq_param);
		j = 0;
	JL00F8:
		if ( j < Len(SeemsName) )
		{
			if ( Mid(SeemsName,j,1) == "_" )
			{
				textureStr = Left(SeemsName,j);
				textureStr2 = Right(SeemsName,Len(SeemsName) -j - 1);
				SeemsName = textureStr$" "$textureStr2;
				goto brk;
			}
			j++;
			goto JL00F8;
		}
	brk:
		j = UnknownID1;
	JL017A:
		if ( j < UnknownID2 )
		{
			GetINIString(""$string(j),"Name",Name,"ItemSkillGrp.ini");
			GetINIString(""$string(j),"Type",Type,"ItemSkillGrp.ini");
			if ( (SeemsName == Name) && (qq_param == Type) )
			{
				GetINIString(""$string(j),"Level",Level,"ItemSkillGrp.ini");
				GetINIString(""$string(j),"ID",Id,"ItemSkillGrp.ini");
				record.LVDataList[0].szData = Name;
				record.LVDataList[1].szData = Type;
				record.LVDataList[2].szData = Level;
				record.LVDataList[3].nTextureWidth = 16;
				record.LVDataList[3].nTextureHeight = 16;
				record.LVDataList[3].szData = "";
				record.LVDataList[3].szTexture = GetDataTexture(Name);
				record.szReserved = Id;
				record.LVDataList[1].bUseTextColor = True;
				record.LVDataList[1].TextColor = SetAugmentColor(Type);
				record.LVDataList[0].bUseTextColor = False;
				record.LVDataList[2].bUseTextColor = False;
				
				SelectedList.InsertRecord(record);
				goto brk2;
			}
			j++;
			goto JL017A;
		}
	brk2:
		i++;
		goto JL00A4;
	}
}

function MaybeHandleFoundItems ()
{
	local string param;
	local int tmp;
	local string Name;
	local string Type;
	local string Level;
	local string Id;
	local int i;
	local LVDataRecord record;

	record.LVDataList.Length = UnknownID2 - UnknownID1;
	FoundList.DeleteAllItem();
	param = Class'UIAPI_EDITBOX'.static.GetString("AugmentationListWnd.FoundBox");
	tmp = Len(param);
	if ( tmp != 0 )
	{
		i = UnknownID1;
	JL007D:
		if ( i < UnknownID2 )
		{
			GetINIString(""$string(i),"Name",Name,"ItemSkillGrp.ini");
			if ( Left(Name,tmp) ~= param )
			{
				GetINIString(""$string(i),"Type",Type,"ItemSkillGrp.ini");
				GetINIString(""$string(i),"Level",Level,"ItemSkillGrp.ini");
				GetINIString(""$string(i),"ID",Id,"ItemSkillGrp.ini");
				record.LVDataList[0].szData = Name;
				record.LVDataList[1].szData = Type;
				record.LVDataList[2].szData = Level;
				record.LVDataList[3].nTextureWidth = 16;
				record.LVDataList[3].nTextureHeight = 16;
				record.LVDataList[3].szData = "";
				record.LVDataList[3].szTexture = GetDataTexture(Name);
				record.szReserved = Id;
				record.LVDataList[1].bUseTextColor = True;
				record.LVDataList[1].TextColor = SetAugmentColor(Type);
		
				FoundList.InsertRecord(record);
			}
			i++;
			goto JL007D;
		}
	}
}

function OnClickListCtrlRecord (string param)
{
	local LVDataRecord record;

	switch (param)
	{
		case "FoundList":
			record = FoundList.GetSelectedRecord();
			break;
		case "SelectedList":
			record = SelectedList.GetSelectedRecord();
			break;
		default:
	}
	Class'UIAPI_TEXTBOX'.static.SetText("AugmentationListWnd.Description",record.LVDataList[1].szData$": "$GetDescription(record.LVDataList[0].szData));
}

function OnDBClickListCtrlRecord (string param)
{
	local int i;
	local bool tmp;
	local LVDataRecord record;

	switch (param)
	{
		case "FoundList":
			record = FoundList.GetSelectedRecord();
			i = 0;
		JL0031:
			if ( i < SelectedList.GetRecordCount() )
			{
				if ( record.szReserved == SelectedList.GetRecord(i).szReserved )
				{
					tmp = True;
				}
				i++;
				goto JL0031;
			}
			if (  !tmp )
			{
				record.LVDataList[3].nTextureWidth = 16;
				record.LVDataList[3].nTextureHeight = 16;
				record.LVDataList[3].szTexture = GetDataTexture(record.LVDataList[0].szData);
				record.LVDataList[1].bUseTextColor = True;
				record.LVDataList[1].TextColor = SetAugmentColor(record.LVDataList[1].szData);
				record.LVDataList[0].bUseTextColor = False;
				record.LVDataList[2].bUseTextColor = False;
				SelectedList.InsertRecord(record);
			}
			break;
		case "SelectedList":
			i = SelectedList.GetSelectedIndex();
			SelectedList.DeleteRecord(i);
			break;
		default:
	}
}

function string GetDataTexture (string qq_param)
{
	local int i;
	local string textureStr;
	local string textureStr2;

	i = 0;
JL0007:
	if ( i < Len(qq_param) )
	{
		if ( Mid(qq_param,i,1) == " " )
		{
			textureStr = Left(qq_param,i);
			textureStr2 = Right(qq_param,Len(qq_param) -i - 1);
			return "InterfaceTextures.ItemSkill_"$textureStr$textureStr2;
		}
		i++;
		goto JL0007;
	}
	return "InterfaceTextures.ItemSkill_"$qq_param;
}

function Color SetAugmentColor (string qq_param)
{
	local Color MsnColor;

	switch (qq_param)
	{
		case "Active":
			MsnColor.R = 225;
			MsnColor.G = 195;
			MsnColor.B = 0;
			break;
		case "Passive":
			MsnColor.R = 218;
			MsnColor.G = 165;
			MsnColor.B = 32;
			break;
		case "Chance":
			MsnColor.R = 255;
			MsnColor.G = 255;
			MsnColor.B = 185;
			break;
		case "Physical":
			MsnColor.R = 255;
			MsnColor.G = 255;
			MsnColor.B = 185;
			break;
		case "Critical":
			MsnColor.R = 234;
			MsnColor.G = 165;
			MsnColor.B = 245;
			break;
		default:
			MsnColor.R = 187;
			MsnColor.G = 181;
			MsnColor.B = 138;
	}
	return MsnColor;
}

function string GetDescription (string SeemsName)
{
	local string param;

	GetINIString("Description",SeemsName,param,"ItemSkillGrp.ini");
	return param;
}
defaultproperties
{
}
