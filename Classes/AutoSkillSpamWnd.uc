//================================================================================
// AutoSkillSpamWnd.
//================================================================================

class AutoSkillSpamWnd extends UICommonAPI;

const TIMERID_SPAM_SKILL = 9999;
var bool useSpam_1;
var bool useSpam_2;
var bool useSpam_3;
var bool useSpam_4;
var bool useSpam_5;

var WindowHandle m_hOptWnd;
var WindowHandle AutoSkillSpamWnd;
var ItemWindowHandle SkillBox_Spam_1;
var ItemWindowHandle SkillBox_Spam_2;
var ItemWindowHandle SkillBox_Spam_3;
var ItemWindowHandle SkillBox_Spam_4;
var ItemWindowHandle SkillBox_Spam_5;
var ItemInfo SkillBox_Spam_Spam_Item_1;
var ItemInfo SkillBox_Spam_Spam_Item_2;
var ItemInfo SkillBox_Spam_Spam_Item_3;
var ItemInfo SkillBox_Spam_Spam_Item_4;
var ItemInfo SkillBox_Spam_Spam_Item_5;
var TextureHandle Toggle_Skill_Spam_1;
var TextureHandle Toggle_Skill_Spam_2;
var TextureHandle Toggle_Skill_Spam_3;
var TextureHandle Toggle_Skill_Spam_4;
var TextureHandle Toggle_Skill_Spam_5;


function OnLoad ()
{
	RegisterEvent(EV_GamingStateEnter);
	registerEvent(EV_GamingStateExit);
	
	useSpam_1 = false;
	useSpam_2 = false;
	useSpam_3 = false;
	useSpam_4 = false;
	useSpam_5 = false;
	
	AutoSkillSpamWnd = GetHandle("AutoSkillSpamWnd");
	
	SkillBox_Spam_1 = ItemWindowHandle(GetHandle("AutoSkillSpamWnd.SkillBox_Spam_1"));
	SkillBox_Spam_2 = ItemWindowHandle(GetHandle("AutoSkillSpamWnd.SkillBox_Spam_2"));
	SkillBox_Spam_3 = ItemWindowHandle(GetHandle("AutoSkillSpamWnd.SkillBox_Spam_3"));
	SkillBox_Spam_4 = ItemWindowHandle(GetHandle("AutoSkillSpamWnd.SkillBox_Spam_4"));
	SkillBox_Spam_5 = ItemWindowHandle(GetHandle("AutoSkillSpamWnd.SkillBox_Spam_5"));
	
	Toggle_Skill_Spam_1 = TextureHandle(GetHandle("AutoSkillSpamWnd.Toggle_Skill_Spam_1"));
	Toggle_Skill_Spam_2 = TextureHandle(GetHandle("AutoSkillSpamWnd.Toggle_Skill_Spam_2"));
	Toggle_Skill_Spam_3 = TextureHandle(GetHandle("AutoSkillSpamWnd.Toggle_Skill_Spam_3"));
	Toggle_Skill_Spam_4 = TextureHandle(GetHandle("AutoSkillSpamWnd.Toggle_Skill_Spam_4"));
	Toggle_Skill_Spam_5 = TextureHandle(GetHandle("AutoSkillSpamWnd.Toggle_Skill_Spam_5"));
	
	Toggle_Skill_Spam_1.HideWindow();
	Toggle_Skill_Spam_2.HideWindow();
	Toggle_Skill_Spam_3.HideWindow();
	Toggle_Skill_Spam_4.HideWindow();
	Toggle_Skill_Spam_5.HideWindow();
}

function OnEvent (int a_EventID, string a_Param)
{
	if (a_EventID == EV_GamingStateEnter)
	{
		HandleGamingStateEnter();
	}
	if (a_EventID == EV_GamingStateExit)
	{
		saveINI();
	}
}

function HandleGamingStateEnter ()
{
	Reset();
	AutoSkillSpamWnd.SetTimer(10210,2000);
	AutoSkillSpamWnd.SetTimer( TIMERID_SPAM_SKILL, 300);
}

function Reset()
{
	AutoSkillSpamWnd.KillTimer(10210);
	AutoSkillSpamWnd.KillTimer(TIMERID_SPAM_SKILL);
	useSpam_1 = false;
	useSpam_2 = false;
	useSpam_3 = false;
	useSpam_4 = false;
	useSpam_5 = false;
	SkillBox_Spam_1.Clear();
	SkillBox_Spam_2.Clear();
	SkillBox_Spam_3.Clear();
	SkillBox_Spam_4.Clear();
	SkillBox_Spam_5.Clear();
	SkillBox_Spam_Spam_Item_1.ClassID = 0;
	SkillBox_Spam_Spam_Item_2.ClassID = 0;
	SkillBox_Spam_Spam_Item_3.ClassID = 0;
	SkillBox_Spam_Spam_Item_4.ClassID = 0;
	SkillBox_Spam_Spam_Item_5.ClassID = 0;
	Toggle_Skill_Spam_1.HideWindow();
	Toggle_Skill_Spam_2.HideWindow();
	Toggle_Skill_Spam_3.HideWindow();
	Toggle_Skill_Spam_4.HideWindow();
	Toggle_Skill_Spam_5.HideWindow();
}

function InsertSkillsOnStart ()
{
	local int outValue;
	local UserInfo userinfo;
	
	GetPlayerInfo(userinfo);

	GetINIInt(userinfo.name, "SkillBox_Spam_Spam_Item_1", outValue, "Option");
	if ((outValue == 2) || (outValue == 4))
	{
		GetActionInfoFunc(outValue,SkillBox_Spam_Spam_Item_1);
	} else {
		GetSkillInfoFunc(outValue,SkillBox_Spam_Spam_Item_1);
	}
	if (SkillBox_Spam_Spam_Item_1.ClassID > 0)
	{
		SkillBox_Spam_1.AddItem(SkillBox_Spam_Spam_Item_1);
	}
	
	GetINIInt(userinfo.name, "SkillBox_Spam_Spam_Item_2", outValue, "Option");
	if ((outValue == 2) || (outValue == 4))
	{
		GetActionInfoFunc(outValue,SkillBox_Spam_Spam_Item_2);
	} else {
		GetSkillInfoFunc(outValue,SkillBox_Spam_Spam_Item_2);
	}
	if (SkillBox_Spam_Spam_Item_2.ClassID > 0)
	{
		SkillBox_Spam_2.AddItem(SkillBox_Spam_Spam_Item_2);
	}
	
	GetINIInt(userinfo.name, "SkillBox_Spam_Spam_Item_3", outValue, "Option");
	if ((outValue == 2) || (outValue == 4))
	{
		GetActionInfoFunc(outValue,SkillBox_Spam_Spam_Item_3);
	} else {
		GetSkillInfoFunc(outValue,SkillBox_Spam_Spam_Item_3);
	}
	if (SkillBox_Spam_Spam_Item_3.ClassID > 0)
	{
		SkillBox_Spam_3.AddItem(SkillBox_Spam_Spam_Item_3);
	}
	
	GetINIInt(userinfo.name, "SkillBox_Spam_Spam_Item_4", outValue, "Option");
	if ((outValue == 2) || (outValue == 4))
	{
		GetActionInfoFunc(outValue,SkillBox_Spam_Spam_Item_4);
	} else {
		GetSkillInfoFunc(outValue,SkillBox_Spam_Spam_Item_4);
	}
	if (SkillBox_Spam_Spam_Item_4.ClassID > 0)
	{
		SkillBox_Spam_4.AddItem(SkillBox_Spam_Spam_Item_4);
	}
	
	GetINIInt(userinfo.name, "SkillBox_Spam_Spam_Item_5", outValue, "Option");
	if ((outValue == 2) || (outValue == 4))
	{
		GetActionInfoFunc(outValue,SkillBox_Spam_Spam_Item_5);
	} else {
		GetSkillInfoFunc(outValue,SkillBox_Spam_Spam_Item_5);
	}
	if (SkillBox_Spam_Spam_Item_5.ClassID > 0)
	{
		SkillBox_Spam_5.AddItem(SkillBox_Spam_Spam_Item_5);
	}
}

function OnTimer( int a_TimerID )
{
	if (a_TimerID == 9999)
	{
		SpamSkills();
	}
	if (a_TimerID == 10210)
	{
		AutoSkillSpamWnd.KillTimer(10210);
		InsertSkillsOnStart();
	}
}

function SpamSkills()
{
	local UserInfo userinfo;
	GetPlayerInfo(userinfo);
	if (userinfo.nCurHP > 0) 
	{
		if (useSpam_1)
		{
			if ((SkillBox_Spam_Spam_Item_1.ClassID == 4) || (SkillBox_Spam_Spam_Item_1.ClassID == 2))
			{
				DoAction(SkillBox_Spam_Spam_Item_1.ClassID);
			} else {
				UseSkill(SkillBox_Spam_Spam_Item_1.ClassID);
			}
		}
		if (useSpam_2)
		{
			if ((SkillBox_Spam_Spam_Item_2.ClassID == 4) || (SkillBox_Spam_Spam_Item_2.ClassID == 2))
			{
				DoAction(SkillBox_Spam_Spam_Item_2.ClassID);
			} else {
				UseSkill(SkillBox_Spam_Spam_Item_2.ClassID);
			}
		}
		if (useSpam_3)
		{
			if ((SkillBox_Spam_Spam_Item_3.ClassID == 4) || (SkillBox_Spam_Spam_Item_3.ClassID == 2))
			{
				DoAction(SkillBox_Spam_Spam_Item_3.ClassID);
			} else {
				UseSkill(SkillBox_Spam_Spam_Item_3.ClassID);
			}
		}
		if (useSpam_4)
		{
			if ((SkillBox_Spam_Spam_Item_4.ClassID == 4) || (SkillBox_Spam_Spam_Item_4.ClassID == 2))
			{
				DoAction(SkillBox_Spam_Spam_Item_4.ClassID);
			} else {
				UseSkill(SkillBox_Spam_Spam_Item_4.ClassID);
			}
		}
		if (useSpam_5)
		{
			if ((SkillBox_Spam_Spam_Item_5.ClassID == 4) || (SkillBox_Spam_Spam_Item_5.ClassID == 2))
			{
				DoAction(SkillBox_Spam_Spam_Item_5.ClassID);
			} else {
				UseSkill(SkillBox_Spam_Spam_Item_5.ClassID);
			}
		}
	}
}

function OnDropItem (string a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
	if (a_WindowID == "SkillBox_Spam_1")
	{
		SkillBox_Spam_1.Clear();
		SkillBox_Spam_Spam_Item_1 = a_ItemInfo;
		SkillBox_Spam_1.AddItem(a_ItemInfo);
	} else if (a_WindowID == "SkillBox_Spam_2")
	{
		SkillBox_Spam_2.Clear();
		SkillBox_Spam_Spam_Item_2 = a_ItemInfo;
		SkillBox_Spam_2.AddItem(a_ItemInfo);
	} else if (a_WindowID == "SkillBox_Spam_3")
	{
		SkillBox_Spam_3.Clear();
		SkillBox_Spam_Spam_Item_3 = a_ItemInfo;
		SkillBox_Spam_3.AddItem(a_ItemInfo);
	} else if (a_WindowID == "SkillBox_Spam_4")
	{
		SkillBox_Spam_4.Clear();
		SkillBox_Spam_Spam_Item_4 = a_ItemInfo;
		SkillBox_Spam_4.AddItem(a_ItemInfo);
	} else if (a_WindowID == "SkillBox_Spam_5")
	{
		SkillBox_Spam_5.Clear();
		SkillBox_Spam_Spam_Item_5 = a_ItemInfo;
		SkillBox_Spam_5.AddItem(a_ItemInfo);
	}
	saveINI();
}

function OnClickItem (string strID, int Index)
{
	if (strID == "SkillBox_Spam_1" && Index > -1)
	{
		if (!useSpam_1)
		{
			EnableSkill(SkillBox_Spam_1);
		} else {
			DisableSkill(SkillBox_Spam_1);
		}
	} else if (strID == "SkillBox_Spam_2" && Index > -1)
	{
		if (!useSpam_2)
		{
			EnableSkill(SkillBox_Spam_2);
		} else {
			DisableSkill(SkillBox_Spam_2);
		}
	} else if (strID == "SkillBox_Spam_3" && Index > -1)
	{
		if (!useSpam_3)
		{
			EnableSkill(SkillBox_Spam_3);
		} else {
			DisableSkill(SkillBox_Spam_3);
		}
	} else if (strID == "SkillBox_Spam_4" && Index > -1)
	{
		if (!useSpam_4)
		{
			EnableSkill(SkillBox_Spam_4);
		} else {
			DisableSkill(SkillBox_Spam_4);
		}
	} else if (strID == "SkillBox_Spam_5" && Index > -1)
	{
		if (!useSpam_5)
		{
			EnableSkill(SkillBox_Spam_5);
		} else {
			DisableSkill(SkillBox_Spam_5);
		}
	}
}

function DisableSkill (ItemWindowHandle ItemWnd)
{
	switch (ItemWnd)
	{
		case SkillBox_Spam_1:
			Toggle_Skill_Spam_1.HideWindow();
			useSpam_1 = False;
			break;
		case SkillBox_Spam_2:
			Toggle_Skill_Spam_2.HideWindow();
			useSpam_2 = False;
			break;
		case SkillBox_Spam_3:
			Toggle_Skill_Spam_3.HideWindow();
			useSpam_3 = False;
			break;
		case SkillBox_Spam_4:
			Toggle_Skill_Spam_4.HideWindow();
			useSpam_4 = False;
			break;
		case SkillBox_Spam_5:
			Toggle_Skill_Spam_5.HideWindow();
			useSpam_5 = False;
			break;
			default:
	}
}

function EnableSkill (ItemWindowHandle ItemWnd)
{
	switch (ItemWnd)
	{
		case SkillBox_Spam_1:
			Toggle_Skill_Spam_1.ShowWindow();
			useSpam_1 = true;
			break;
		case SkillBox_Spam_2:
			Toggle_Skill_Spam_2.ShowWindow();
			useSpam_2 = true;
			break;
		case SkillBox_Spam_3:
			Toggle_Skill_Spam_3.ShowWindow();
			useSpam_3 = true;
			break;
		case SkillBox_Spam_4:
			Toggle_Skill_Spam_4.ShowWindow();
			useSpam_4 = true;
			break;
		case SkillBox_Spam_5:
			Toggle_Skill_Spam_5.ShowWindow();
			useSpam_5 = true;
			break;
			default:
	}
}

function OnRClickItem (string strID, int Index)
{
	if (strID == "SkillBox_Spam_1")
	{
		DisableSkill(SkillBox_Spam_1);
		SkillBox_Spam_1.Clear();
		SkillBox_Spam_Spam_Item_1.ClassID = 0;
	} else if (strID == "SkillBox_Spam_2")
	{
		DisableSkill(SkillBox_Spam_2);
		SkillBox_Spam_2.Clear();
		SkillBox_Spam_Spam_Item_2.ClassID = 0;
	} else if (strID == "SkillBox_Spam_3")
	{
		DisableSkill(SkillBox_Spam_3);
		SkillBox_Spam_3.Clear();
		SkillBox_Spam_Spam_Item_3.ClassID = 0;
	} else if (strID == "SkillBox_Spam_4")
	{
		DisableSkill(SkillBox_Spam_4);
		SkillBox_Spam_4.Clear();
		SkillBox_Spam_Spam_Item_4.ClassID = 0;
	} else if (strID == "SkillBox_Spam_5")
	{
		DisableSkill(SkillBox_Spam_5);
		SkillBox_Spam_5.Clear();
		SkillBox_Spam_Spam_Item_5.ClassID = 0;
	}
	saveINI();
}

function GetSkillInfoFunc(int id, out ItemInfo Info)
{
	local int index;
	local ItemInfo Skill;
	RequestSkillList();
	index = class'UIAPI_ITEMWINDOW'.static.FindItemWithClassID("MagicSkillWnd.ASkill.SkillItem",id);
	if(class'UIAPI_ITEMWINDOW'.static.GetItem("MagicSkillWnd.ASkill.SkillItem",index,Skill))
	{
		Info=Skill;
	}
}

function GetActionInfoFunc(int id, out ItemInfo Info)
{
	local int index;
	local ItemInfo Skill;
	class'ActionAPI'.static.RequestActionList();
	index = class'UIAPI_ITEMWINDOW'.static.FindItemWithClassID("ActionWnd.ActionBasicItem",id);
	
	if(class'UIAPI_ITEMWINDOW'.static.GetItem("ActionWnd.ActionBasicItem",index,Skill))
	{
		Info=Skill;
	}
}

function saveINI()
{
	local UserInfo userinfo;
	
	GetPlayerInfo(userinfo);
	SetINIInt(userinfo.name, "SkillBox_Spam_Spam_Item_1", SkillBox_Spam_Spam_Item_1.ClassID, "Option");
	SetINIInt(userinfo.name, "SkillBox_Spam_Spam_Item_2", SkillBox_Spam_Spam_Item_2.ClassID, "Option");
	SetINIInt(userinfo.name, "SkillBox_Spam_Spam_Item_3", SkillBox_Spam_Spam_Item_3.ClassID, "Option");
	SetINIInt(userinfo.name, "SkillBox_Spam_Spam_Item_4", SkillBox_Spam_Spam_Item_4.ClassID, "Option");
	SetINIInt(userinfo.name, "SkillBox_Spam_Spam_Item_5", SkillBox_Spam_Spam_Item_5.ClassID, "Option");
}
defaultproperties
{
}
