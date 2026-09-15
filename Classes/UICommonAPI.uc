class UICommonAPI extends UIScript;

// Dialog API
enum EDialogType
{
	DIALOG_OKCancel,
	DIALOG_OK,
	DIALOG_OKCancelInput,
	DIALOG_OKInput,
	DIALOG_Warning,
	DIALOG_Notice,
	DIALOG_NumberPad,
	DIALOG_Progress,
};

enum DialogDefaultAction
{
	EDefaultNone,
	EDefaultOK,
	EDefaultCancel,
};

enum HeaderPosition
{
	Header_Head,
	Header_MidBody,
	Header_LowBody
};

struct PlayerStatusInfo
{
	var int CreatureID;
	var int CurHP;
	var int MaxHP;
	var int CurMP;
	var int MaxMP;
	var int Team;
};

struct infoautobuff
{
	var int Id;
	var string Name;
	var bool answermatha;
	var int quequierestuax2;
};

// ??????????????? ?????????? strMessage : ???? ???????? ???????( ???????????"????????????????????????" )
// ????? ???????? ??????????????? ???? ????? DialogSetID() ??????????????????
function DialogShow( EDialogType dialogType, string strMessage )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.ShowDialog( dialogType, strMessage, string(Self) );
}

// ??????????????? ???????? ??????????????? ?? ???? ????????? ????? ??????????????? ?????????????? DialogHide() ????????? ??????????????
function DialogHide()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.HideDialog();
}

// ???????? ?????? ????????????????????? ??????????? ????????????????????? ??????????
// ?????????????????? ??????? ????????? ??????????? Cancel ???????? ???????????????? ?????? ????
// ????? ????????????????????????? ???????? ?????????????? OK??? ????????????? ????? ??????????????????? ???????????????????
function DialogSetDefaultOK()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetDefaultAction( EDefaultOK );
}

// EV_DialogOK ????? ?????????????????????? ???? ??, ????????????????? ????????????????????????????????????? ?? ???????? ???????????????????????????? ??????????????? ????
function bool DialogIsMine()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	if( script.GetTarget() == string(Self) )
		return True;
	return False;
}

// ??????? uc???? ??????????????? ???????? ?????????? ????????? ???????????, ??????????????? ?????????????? ????????, ???????????????uc????  ????????????????????????? ????
// ???? ??????? ????????? ????? ?????????????, ?????????????????????? ?????? ?????????????????????????? ?????????????? ??????? ????
// ?????????????????????????? ?????? ????????? ???????????? DialogSetID() ??????? ??????????????????????? DialogGetID()???????? ?????? ?????? ???????????????????
function DialogSetID( int id )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetID( id );
}

// ???????????????? ?????????????? ?????????? ?????????? ?? ???? ???? ???????? ?????, ?????????? ?? XML ?????????? ?????? ??????.
function DialogSetEditType( string strType )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetEditType( strType );
}

// ???????????????? ????????????? ??????? ????????? ??????????
function string DialogGetString()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetEditMessage();
}

// ???????????????? ????????????? ????????? ?????????
function DialogSetString(string strInput)
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetEditMessage(strInput);
}

function int DialogGetID()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetID();
}

// ParamInt?? ???????????????? ??????????????? ????????? ??????????????????????? Progress?? timeup ?????, NumberPad???? max??? ??
function DialogSetParamInt( int param )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetParamInt( param );
}

// ReservedXXX ???????? ???????????????? ????????????? ????? ??????????? ??????? ?????? ParamXXX???? ???????
function DialogSetReservedInt( int value )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedInt( value );
}

function DialogSetReservedInt2( int value )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedInt2( value );
}

function DialogSetReservedInt3( int value )
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedInt3( value );
}

function int DialogGetReservedInt()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetReservedInt();
}

function int DialogGetReservedInt2()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetReservedInt2();
}

function int DialogGetReservedInt3()
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	return script.GetReservedInt3();
}

function DialogSetEditBoxMaxLength(int maxLength)
{
	local DialogBox	script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetEditBoxMaxLength(maxLength);
}

function int Split( string strInput, string delim, out array<string> arrToken )
{
	local int arrSize;
	
	while ( InStr(strInput, delim) > 0 )
	{
		arrToken.Insert(arrToken.Length, 1);
		arrToken[arrToken.Length - 1] = Left(strInput, InStr(strInput, delim));
		strInput = Mid(strInput, InStr(strInput, delim) + 1);
		arrSize = arrSize + 1;
	}
	arrToken.Insert(arrToken.Length, 1);
	arrToken[arrToken.Length - 1] = strInput;
	arrSize = arrSize + 1;
	
	return arrSize;
}

function ShowWindow( string a_ControlID )
{
	class'UIAPI_WINDOW'.static.ShowWindow( a_ControlID );
}

function ShowWindowWithFocus( string a_ControlID )
{
	class'UIAPI_WINDOW'.static.ShowWindow( a_ControlID );
	class'UIAPI_WINDOW'.static.SetFocus( a_ControlID );
}


function HideWindow( string a_ControlID )
{
	class'UIAPI_WINDOW'.static.HideWindow( a_ControlID );
}

function bool IsShowWindow( string a_ControlID )
{
	return class'UIAPI_WINDOW'.static.IsShowWindow( a_ControlID );
}


function HideWindowTutorial(string Window)
{
    // End:0x55
	if( (IsShowWindow("TutorialOverlayWnd")) || IsShowWindow("TutorialLightWnd") )
	{
		ExecuteEvent(99970, "Window="$Window);
	}

}



function TextureHandle xxGetTextureHandle(string WindowName)
{
	local TextureHandle Handle;

	Handle = TextureHandle(GetHandle(WindowName));
	return Handle;
}

function TextBoxHandle xxGetTextBoxHandle(string WindowName)
{
	local TextBoxHandle Handle;

	Handle = TextBoxHandle(GetHandle(WindowName));
	return Handle;
}

function AnimTextureHandle xxGetAnimTextureHandle(string WindowName)
{
	local AnimTextureHandle Handle;

	Handle = AnimTextureHandle(GetHandle(WindowName));
	return Handle;
}

function float xxfloat(int zzsada, int zzwdasd)
{
	return float(zzsada) / float(zzwdasd);

}


function BarHandle xxGetBarHandle(string WindowName)
{
	local private BarHandle Handle;

	Handle = BarHandle(GetHandle(WindowName));
	return Handle;
 
}


function ButtonHandle xxGetButtonHandle(string WindowName)
{
	local ButtonHandle Handle;

	Handle = ButtonHandle(GetHandle(WindowName));
	return Handle;
}

function ItemWindowHandle xxGetItemWindowHandle(string WindowName)
{
	local ItemWindowHandle Handle;

	Handle = ItemWindowHandle(GetHandle(WindowName));
	return Handle;
}



function WindowHandle xxGetWindowHandle(string WindowName)
{
	local WindowHandle Handle;

	Handle = GetHandle(WindowName);
	return Handle;
}




function ParamToItemInfo (string index, out ItemInfo Info)
{
	local int tmpInt;
	local EItemType eItemType;
	eItemType = EItemType(info.ItemType);

	ParseInt(index,"classID",Info.ClassID);
	ParseInt(index,"level",Info.Level);
	ParseString(index,"name",Info.Name);
	ParseString(index,"additionalName",Info.AdditionalName);
	ParseString(index,"iconName",Info.IconName);
	ParseString(index,"description",Info.Description);
	ParseInt(index,"itemType",Info.ItemType);
	ParseInt(index,"serverID",Info.ServerID);
	ParseInt(index,"itemNum",Info.ItemNum);
	ParseInt(index,"slotBitType",Info.SlotBitType);
	ParseInt(index,"enchanted",Info.Enchanted);
	ParseInt(index,"blessed",Info.Blessed);
	ParseInt(index,"damaged",Info.Damaged);
	if ( ParseInt(index,"equipped",tmpInt) )
	{
		Info.bEquipped = bool(tmpInt);
	}
	ParseInt(index,"price",Info.Price);
	ParseInt(index,"reserved",Info.Reserved);
	ParseInt(index,"defaultPrice",Info.DefaultPrice);
	ParseInt(index,"refineryOp1",Info.RefineryOp1);
	ParseInt(index,"refineryOp2",Info.RefineryOp2);
	ParseInt(index,"currentDurability",Info.CurrentDurability);
	ParseInt(index,"weight",Info.Weight);
	ParseInt(index,"materialType",Info.MaterialType);
	ParseInt(index,"weaponType",Info.WeaponType);
	ParseInt(index,"physicalDamage",Info.PhysicalDamage);
	ParseInt(index,"magicalDamage",Info.MagicalDamage);
	ParseInt(index,"shieldDefense",Info.ShieldDefense);
	ParseInt(index,"shieldDefenseRate",Info.ShieldDefenseRate);
	ParseInt(index,"durability",Info.Durability);
	ParseInt(index,"crystalType",Info.CrystalType);
	ParseInt(index,"randomDamage",Info.RandomDamage);
	ParseInt(index,"critical",Info.Critical);
	ParseInt(index,"hitModify",Info.HitModify);
	ParseInt(index,"attackSpeed",Info.AttackSpeed);
	ParseInt(index,"mpConsume",Info.MpConsume);
	ParseInt(index,"avoidModify",Info.AvoidModify);
	ParseInt(index,"soulshotCount",Info.SoulshotCount);
	ParseInt(index,"spiritshotCount",Info.SpiritshotCount);
	ParseInt(index,"armorType",Info.ArmorType);
	ParseInt(index,"physicalDefense",Info.PhysicalDefense);
	ParseInt(index,"magicalDefense",Info.MagicalDefense);
	ParseInt(index,"mpBonus",Info.MpBonus);
	ParseInt(index,"consumeType",Info.ConsumeType);
	ParseInt(index,"ItemSubType",Info.ItemSubType);
	ParseString(index,"iconNameEx1",Info.IconNameEx1);
	ParseString(index,"iconNameEx2",Info.IconNameEx2);
	ParseString(index,"iconNameEx3",Info.IconNameEx3);
	ParseString(index,"iconNameEx4",Info.IconNameEx4);
	if ( ParseInt(index,"arrow",tmpInt) )
	{
		Info.bArrow = bool(tmpInt);
	}
	if ( ParseInt(index,"recipe",tmpInt) )
	{
		Info.bRecipe = bool(tmpInt);
	}
	if ( (eItemType == ITEM_WEAPON || eItemType == ITEM_ARMOR || eItemType == ITEM_ACCESSARY) && (Info.Enchanted <= 50 && Info.Enchanted > 0) )
	{
		Info.ForeTexture = "L2UI_CH3.ENCHANT"$Info.Enchanted$"";
	}

	if ( Info.ItemNum > 1 )
	{
		if ( Info.ItemNum > 99 )
		{
			Info.ForeTexture = "L2UI_CH3.ItemCount.texCount99+";
		}
		else
		{
			Info.ForeTexture = "L2UI_CH3.ItemCount.texCount"$string(Info.ItemNum);
		}
	}


}

function texcountinfoaa(ItemInfo zzinfo, out ItemInfo zzsdaa)
{
	zzsdaa.ForeTexture = "";
    // End:0x95
	if( zzinfo.ItemNum > 1 )
	{
        // End:0x5C
		if( zzinfo.ItemNum > 99 )
		{
			zzsdaa.ForeTexture = "L2UI_CH3.ItemCount.texCount99+";            
		}
		else
		{
			zzsdaa.ForeTexture = "L2UI_CH3.ItemCount.texCount"$string(zzinfo.ItemNum);
		}        
	}
	else
	{
        // End:0x101
		if( ((zzsdaa.Enchanted <= 50) && zzsdaa.Enchanted > 0) && zzsdaa.SlotBitType > 0 )
		{
			zzsdaa.ForeTexture = "L2UI_CH3.ItemEnchant.enchant"$string(zzsdaa.Enchanted);
		}
	}
	return;
}



function ParamToRecord( string param, out LVDataRecord record )
{
	local int idx;
	local int MaxColumn;
	
	ParseString( param, "szReserved", record.szReserved );
	ParseInt( param, "nReserved1", record.nReserved1 );
	ParseInt( param, "nReserved2", record.nReserved2 );
	ParseInt( param, "nReserved3", record.nReserved3 );

	ParseInt( param, "MaxColumn", MaxColumn );
	record.LVDataList.Length = MaxColumn;
	for ( idx = 0; idx < MaxColumn; idx++ )
	{
		ParseString( param, "szData_"$idx, record.LVDataList[idx].szData );
		ParseString( param, "szReserved_"$idx, record.LVDataList[idx].szReserved );
		ParseInt( param, "nReserved1_"$idx, record.LVDataList[idx].nReserved1 );
		ParseInt( param, "nReserved2_"$idx, record.LVDataList[idx].nReserved2 );
		ParseInt( param, "nReserved3_"$idx, record.LVDataList[idx].nReserved3 );
	}
}

function bool GetPlayerActor(out Actor actor)
{
	actor = xxgetInstanceL2Util().GetActor();
    // End:0x23
	if( actor != None )
	{
		return True;
	}
	return False;

}

function bool GetPlayerController(out LineagePlayerController controller)
{
	controller = xxgetInstanceL2Util().GetController();
    // End:0x23
	if( controller != None )
	{
		return True;
	}
	return False;

}


function L2Util xxgetInstanceL2Util()
{
	local L2Util utilbar;
	utilbar = L2Util(GetScript("L2Util"));
	return utilbar;
}

function L2Util getInstanceL2Util()
{
	local L2Util utilbar;
	utilbar = L2Util(GetScript("L2Util"));
	return utilbar;
}

function EnableWindow (string Window)
{
	class'UIAPI_WINDOW'.static.EnableWindow(Window);
}

function DisableWindow (string Window)
{
	class'UIAPI_WINDOW'.static.DisableWindow(Window);
}

function SetPlayerActor(Actor actor)
{
	xxgetInstanceL2Util().SetActor(actor);

}

function SetPlayerController(LineagePlayerController controller)
{
	xxgetInstanceL2Util().SetController(controller);

}

function bool NeedUpdateActor()
{
	local Actor actor;

    // End:0x12
	if( !GetPlayerActor(actor) )
	{
		return True;
	}
	return False;

}

function bool NeedUpdateController()
{
	local LineagePlayerController controller;

    // End:0x12
	if( !GetPlayerController(controller) )
	{
		return True;
	}
	return False;

}

function CalculateHeaderPosition(UserInfo Info, HeaderPosition HeaderPos,optional out float OutX,optional out float OutY)
{
	local vector CameraLocation;
	local rotator CameraRotation;
	local vector CameraDirection, CameraRight, CameraUp;
	local int ScreenWidth, ScreenHeight;
	local float FOV, Near, Far, Aspect, Top, Bottom, Right, Left;
	local Matrix ProjMat, ViewMat, MVP;
	local Plane PosHomog, PosMvp;
	local Actor TargetActor;
	local Pawn TargetPawn;
	local LineagePlayerController TargetController;
	local vector TargetLocation;
	local float ManualOffset, ScreenX, ScreenY, PercentX, PercentY, Calibrate;

    // End:0x12
	if ( !GetPlayerActor(TargetActor) )
	{
		return;
	}
    // End:0x24
	if ( !GetPlayerController(TargetController) )
	{
		return;
	}
    // End:0x3D
	if ( Info.bNpc )
	{
		ManualOffset = -0.7;
	}
	TargetController.PlayerCalcView(TargetActor, CameraLocation, CameraRotation);
	GetCurrentResolution(ScreenWidth, ScreenHeight);
	GetAxes(CameraRotation, CameraDirection, CameraRight, CameraUp);
    // End:0x223
	foreach TargetActor.CollidingActors(class'Pawn', TargetPawn, 50, Info.Loc)
	{
        // End:0x222
		if ( Info.nID == TargetPawn.CreatureID )
		{
			TargetLocation = Info.Loc;
			ManualOffset = ManualOffset + TargetPawn.NameOffset;
			TargetLocation.Z = (TargetLocation.Z + TargetPawn.CollisionHeight) + ManualOffset;
		}
	}
	FOV = 60.0;
	Near = 0.1;
	Far = 1000.0;
	Aspect = ScreenWidth / ScreenHeight;
	Top = Tan(FOV * 0.5) * Near;
	Bottom = -Top;
	Right = Top * Aspect;
	Left = -Right;
	ProjMat.XPlane = GetPlane(2.0 * Near / (Right - Left), 0, 0, 0);
	ProjMat.YPlane = GetPlane(0, 2.0 * Near / (Top - Bottom), 0, 0);
	ProjMat.ZPlane = GetPlane((Right + Left) / (Right - Left), (Top + Bottom) / (Top - Bottom), (-2.0 * Far * Near) / (Far - Near), -1);
	ProjMat.WPlane = GetPlane(0, 0, (-Far - Near) / (Far - Near), 0);
	ViewMat.XPlane = GetPlane(CameraRight.X, CameraUp.X, -CameraDirection.X, 0);
	ViewMat.YPlane = GetPlane(CameraRight.Y, CameraUp.Y, -CameraDirection.Y, 0);
	ViewMat.ZPlane = GetPlane(CameraRight.Z, CameraUp.Z, -CameraDirection.Z, 0);
	ViewMat.WPlane = GetPlane(- Dot (CameraRight, CameraLocation), - Dot (CameraUp, CameraLocation), Dot (CameraDirection, CameraLocation), 1);
	MVP = multiplyMatrices(ProjMat, ViewMat);
	PosHomog = GetPlane(TargetLocation.X, TargetLocation.Y, TargetLocation.Z, 1);
	PosMvp = multiplyMatrixVector(MVP, PosHomog);
	PosMvp.X = PosMvp.X / (PosMvp.W / 1000);
	PosMvp.Y = PosMvp.Y / (PosMvp.W / 1000);
	PosMvp.Z = PosMvp.Z / (PosMvp.W / 1000);
	Calibrate = 27.5 * (ScreenWidth / ScreenHeight) / 1000;
	PercentX = (((PosMvp.X * 0.5) * ScreenWidth) + (ScreenWidth / Calibrate)) / ((ScreenWidth / Calibrate) * 0.5);
	PercentY = (((PosMvp.Y * 0.5) * ScreenHeight) + (ScreenHeight / Calibrate)) / ((ScreenHeight / Calibrate) * 0.5);
	ScreenX = (100 - PercentX) * ScreenWidth / 100;
	ScreenY = PercentY * ScreenHeight / 100;
    // End:0x4FA
	if ( (Dot ((TargetLocation - CameraLocation), CameraDirection) < 0) || (ScreenX < -100) || (ScreenX > ScreenWidth + 100) || (ScreenY < -100) || (ScreenY > ScreenHeight + 100) )
	{
		OutX = -100;
		OutY = -100;
		return;
	}
	OutX = ScreenX;
	OutY = ScreenY;
}

function float Dot(Vector v1, Vector v2)
{
	return v1 Dot v2;

}

function Plane nak(float f1, float f2, float f3, float f4)
{
	local Plane P;

	P.X = f1;
	P.Y = f2;
	P.Z = f3;
	P.W = f4;
	return P;

}

function Matrix ComputeProjectionMatrix(float FOV, float near, float far, float aspect)
{
	local float top, bottom, Right, Left;
	local Matrix projMat;

	top = Tan(FOV / float(2)) * near;
	bottom = -top;
	Right = top * aspect;
	Left = -Right;
	projMat.XPlane = nak((2 * near) / (Right - Left), 0, 0, 0);
	projMat.YPlane = nak(0, (2 * near) / (top - bottom), 0, 0);
	projMat.ZPlane = nak((Right + Left) / (Right - Left), (top + bottom) / (top - bottom), ((-1 * far) - near) / (far - near), -1);
	projMat.WPlane = nak(0, 0, ((-2 * far) * near) / (far - near), 0);
	return projMat;

}

function Matrix ComputeViewMatrix(Vector CameraLocation, Vector cameraDirection, Vector cameraRight, Vector cameraUp)
{
	local Matrix viewMat;

	viewMat.XPlane = nak(cameraRight.X, cameraUp.X, -cameraDirection.X, 0);
	viewMat.YPlane = nak(cameraRight.Y, cameraUp.Y, -cameraDirection.Y, 0);
	viewMat.ZPlane = nak(cameraRight.Z, cameraUp.Z, -cameraDirection.Z, 0);
	viewMat.WPlane = nak(-1 * (cameraRight Dot CameraLocation), -1 * (cameraUp Dot CameraLocation), cameraDirection Dot CameraLocation, 1);
	return viewMat;

}













function Matrix multiplyMatrices(Matrix A, Matrix B)
{
	local Matrix C;

	C.XPlane.X = (((A.XPlane.X * B.XPlane.X) + (A.YPlane.X * B.XPlane.Y)) + (A.ZPlane.X * B.XPlane.Z)) + (A.WPlane.X * B.XPlane.W);
	C.XPlane.Y = (((A.XPlane.Y * B.XPlane.X) + (A.YPlane.Y * B.XPlane.Y)) + (A.ZPlane.Y * B.XPlane.Z)) + (A.WPlane.Y * B.XPlane.W);
	C.XPlane.Z = (((A.XPlane.Z * B.XPlane.X) + (A.YPlane.Z * B.XPlane.Y)) + (A.ZPlane.Z * B.XPlane.Z)) + (A.WPlane.Z * B.XPlane.W);
	C.XPlane.W = (((A.XPlane.W * B.XPlane.X) + (A.YPlane.W * B.XPlane.Y)) + (A.ZPlane.W * B.XPlane.Z)) + (A.WPlane.W * B.XPlane.W);
	C.YPlane.X = (((A.XPlane.X * B.YPlane.X) + (A.YPlane.X * B.YPlane.Y)) + (A.ZPlane.X * B.YPlane.Z)) + (A.WPlane.X * B.YPlane.W);
	C.YPlane.Y = (((A.XPlane.Y * B.YPlane.X) + (A.YPlane.Y * B.YPlane.Y)) + (A.ZPlane.Y * B.YPlane.Z)) + (A.WPlane.Y * B.YPlane.W);
	C.YPlane.Z = (((A.XPlane.Z * B.YPlane.X) + (A.YPlane.Z * B.YPlane.Y)) + (A.ZPlane.Z * B.YPlane.Z)) + (A.WPlane.Z * B.YPlane.W);
	C.YPlane.W = (((A.XPlane.W * B.YPlane.X) + (A.YPlane.W * B.YPlane.Y)) + (A.ZPlane.W * B.YPlane.Z)) + (A.WPlane.W * B.YPlane.W);
	C.ZPlane.X = (((A.XPlane.X * B.ZPlane.X) + (A.YPlane.X * B.ZPlane.Y)) + (A.ZPlane.X * B.ZPlane.Z)) + (A.WPlane.X * B.ZPlane.W);
	C.ZPlane.Y = (((A.XPlane.Y * B.ZPlane.X) + (A.YPlane.Y * B.ZPlane.Y)) + (A.ZPlane.Y * B.ZPlane.Z)) + (A.WPlane.Y * B.ZPlane.W);
	C.ZPlane.Z = (((A.XPlane.Z * B.ZPlane.X) + (A.YPlane.Z * B.ZPlane.Y)) + (A.ZPlane.Z * B.ZPlane.Z)) + (A.WPlane.Z * B.ZPlane.W);
	C.ZPlane.W = (((A.XPlane.W * B.ZPlane.X) + (A.YPlane.W * B.ZPlane.Y)) + (A.ZPlane.W * B.ZPlane.Z)) + (A.WPlane.W * B.ZPlane.W);
	C.WPlane.X = (((A.XPlane.X * B.WPlane.X) + (A.YPlane.X * B.WPlane.Y)) + (A.ZPlane.X * B.WPlane.Z)) + (A.WPlane.X * B.WPlane.W);
	C.WPlane.Y = (((A.XPlane.Y * B.WPlane.X) + (A.YPlane.Y * B.WPlane.Y)) + (A.ZPlane.Y * B.WPlane.Z)) + (A.WPlane.Y * B.WPlane.W);
	C.WPlane.Z = (((A.XPlane.Z * B.WPlane.X) + (A.YPlane.Z * B.WPlane.Y)) + (A.ZPlane.Z * B.WPlane.Z)) + (A.WPlane.Z * B.WPlane.W);
	C.WPlane.W = (((A.XPlane.W * B.WPlane.X) + (A.YPlane.W * B.WPlane.Y)) + (A.ZPlane.W * B.WPlane.Z)) + (A.WPlane.W * B.WPlane.W);
	return C;

}

function Plane multiplyMatrixVector(Matrix Matrix, Plane Vector)
{
	local Plane Result;

	Result.X = (((Matrix.XPlane.X * Vector.X) + (Matrix.YPlane.X * Vector.Y)) + (Matrix.ZPlane.X * Vector.Z)) + (Matrix.WPlane.X * Vector.W);
	Result.Y = (((Matrix.XPlane.Y * Vector.X) + (Matrix.YPlane.Y * Vector.Y)) + (Matrix.ZPlane.Y * Vector.Z)) + (Matrix.WPlane.Y * Vector.W);
	Result.Z = (((Matrix.XPlane.Z * Vector.X) + (Matrix.YPlane.Z * Vector.Y)) + (Matrix.ZPlane.Z * Vector.Z)) + (Matrix.WPlane.Z * Vector.W);
	Result.W = (((Matrix.XPlane.W * Vector.X) + (Matrix.YPlane.W * Vector.Y)) + (Matrix.ZPlane.W * Vector.Z)) + (Matrix.WPlane.W * Vector.W);
	return Result;

}

function Plane GetPlane(float f1, float f2, float f3, float f4)
{
	local Plane P;

	P.X = f1;
	P.Y = f2;
	P.Z = f3;
	P.W = f4;
	return P;

}



function bool xxchekaxmu2ax111(int Id)
{
	local bool loqueteax;

	switch(Id)
	{
        // End:0x0F
		case 276:
        // End:0x17
		case 273:
        // End:0x1F
		case 365:
        // End:0x27
		case 275:
        // End:0x2F
		case 274:
        // End:0x37
		case 271:
        // End:0x3F
		case 272:
        // End:0x47
		case 310:
        // End:0x4F
		case 264:
        // End:0x57
		case 265:
        // End:0x5F
		case 266:
        // End:0x67
		case 267:
        // End:0x6F
		case 268:
        // End:0x77
		case 269:
        // End:0x7F
		case 349:
        // End:0x87
		case 270:
        // End:0x8F
		case 304:
        // End:0x97
		case 305:
        // End:0x9F
		case 306:
        // End:0xA7
		case 308:
        // End:0xAF
		case 363:
        // End:0xB7
		case 364:
        // End:0xBF
		case 529:
        // End:0xC7
		case 277:
        // End:0xCF
		case 307:
        // End:0xD7
		case 309:
        // End:0xDF
		case 311:
        // End:0xE7
		case 366:
        // End:0xEF
		case 530:
        // End:0x102
		case 915:
			loqueteax = True;
            // End:0x105
			break;
        // End:0xFFFF
		default:
			break;
	}
	return loqueteax;

}






function bool checkidaoa(int Id)
{
	local bool chelakua;

	chelakua = False;
	switch(Id)
	{
        // End:0x14
		case 28:
        // End:0x19
		case 92:
        // End:0x1E
		case 101:
        // End:0x23
		case 102:
        // End:0x28
		case 105:
        // End:0x2D
		case 115:
        // End:0x32
		case 129:
        // End:0x3A
		case 1069:
        // End:0x42
		case 1083:
        // End:0x4A
		case 1160:
        // End:0x52
		case 1164:
        // End:0x5A
		case 1167:
        // End:0x62
		case 1168:
        // End:0x6A
		case 1184:
        // End:0x72
		case 1201:
        // End:0x7A
		case 1206:
        // End:0x82
		case 1222:
        // End:0x8A
		case 1223:
        // End:0x92
		case 1224:
        // End:0x97
		case 100:
        // End:0x9C
		case 95:
        // End:0xA1
		case 96:
        // End:0xA6
		case 120:
        // End:0xAB
		case 223:
        // End:0xB3
		case 1092:
        // End:0xBB
		case 1095:
        // End:0xC3
		case 1096:
        // End:0xCB
		case 1097:
        // End:0xD3
		case 1099:
        // End:0xDB
		case 1100:
        // End:0xE3
		case 1101:
        // End:0xEB
		case 1102:
        // End:0xF3
		case 1107:
        // End:0xFB
		case 1208:
        // End:0x103
		case 1209:
        // End:0x108
		case 18:
        // End:0x10D
		case 48:
        // End:0x112
		case 65:
        // End:0x117
		case 84:
        // End:0x11C
		case 97:
        // End:0x121
		case 98:
        // End:0x126
		case 103:
        // End:0x12B
		case 106:
        // End:0x130
		case 107:
        // End:0x135
		case 116:
        // End:0x13A
		case 122:
        // End:0x13F
		case 127:
        // End:0x147
		case 260:
        // End:0x14F
		case 279:
        // End:0x157
		case 281:
        // End:0x15F
		case 1042:
        // End:0x167
		case 1049:
        // End:0x16F
		case 1064:
        // End:0x177
		case 1071:
        // End:0x17F
		case 1072:
        // End:0x187
		case 1074:
        // End:0x18F
		case 1104:
        // End:0x197
		case 1108:
        // End:0x19F
		case 1169:
        // End:0x1A7
		case 1170:
        // End:0x1AF
		case 1183:
        // End:0x1B7
		case 1210:
        // End:0x1BF
		case 1231:
        // End:0x1C7
		case 1233:
        // End:0x1CF
		case 1236:
        // End:0x1D7
		case 1237:
        // End:0x1DF
		case 1244:
        // End:0x1E7
		case 1246:
        // End:0x1EF
		case 1247:
        // End:0x1F7
		case 1248:
        // End:0x1FF
		case 286:
        // End:0x207
		case 1263:
        // End:0x20F
		case 1269:
        // End:0x217
		case 1272:
        // End:0x21F
		case 1289:
        // End:0x227
		case 1290:
        // End:0x22F
		case 1291:
        // End:0x237
		case 1298:
        // End:0x23F
		case 342:
        // End:0x247
		case 352:
        // End:0x24F
		case 353:
        // End:0x257
		case 354:
        // End:0x25F
		case 358:
        // End:0x267
		case 361:
        // End:0x26F
		case 362:
        // End:0x277
		case 367:
        // End:0x27F
		case 1336:
        // End:0x287
		case 1337:
        // End:0x28F
		case 1338:
        // End:0x297
		case 1339:
        // End:0x29F
		case 1340:
        // End:0x2A7
		case 1341:
        // End:0x2AF
		case 1342:
        // End:0x2B7
		case 1343:
        // End:0x2BF
		case 1358:
        // End:0x2C7
		case 1359:
        // End:0x2CF
		case 1360:
        // End:0x2D7
		case 1361:
        // End:0x2DF
		case 1366:
        // End:0x2E7
		case 1367:
        // End:0x2EF
		case 1375:
        // End:0x2F7
		case 1376:
        // End:0x2FF
		case 400:
        // End:0x307
		case 401:
        // End:0x30F
		case 402:
        // End:0x317
		case 403:
        // End:0x31F
		case 404:
        // End:0x327
		case 407:
        // End:0x32F
		case 408:
        // End:0x337
		case 412:
        // End:0x33F
		case 1380:
        // End:0x347
		case 1381:
        // End:0x34F
		case 1382:
        // End:0x357
		case 1383:
        // End:0x35F
		case 1384:
        // End:0x367
		case 1385:
        // End:0x36F
		case 1386:
        // End:0x377
		case 1394:
        // End:0x37F
		case 1396:
        // End:0x387
		case 437:
        // End:0x38F
		case 452:
        // End:0x397
		case 485:
        // End:0x39F
		case 1435:
        // End:0x3A7
		case 494:
        // End:0x3AF
		case 495:
        // End:0x3B7
		case 501:
        // End:0x3BF
		case 1437:
        // End:0x3C7
		case 1445:
        // End:0x3CF
		case 1446:
        // End:0x3D7
		case 1447:
        // End:0x3DF
		case 1448:
        // End:0x3E7
		case 509:
        // End:0x3EF
		case 522:
        // End:0x3F7
		case 523:
        // End:0x3FF
		case 531:
        // End:0x407
		case 537:
        // End:0x40F
		case 1452:
        // End:0x417
		case 1454:
        // End:0x41F
		case 1455:
        // End:0x427
		case 1458:
        // End:0x42F
		case 1462:
        // End:0x437
		case 1467:
        // End:0x43F
		case 1468:
        // End:0x447
		case 559:
        // End:0x44F
		case 564:
        // End:0x457
		case 571:
        // End:0x45F
		case 573:
        // End:0x467
		case 578:
        // End:0x46F
		case 581:
        // End:0x477
		case 582:
        // End:0x47F
		case 588:
        // End:0x487
		case 1481:
        // End:0x48F
		case 1482:
        // End:0x497
		case 1483:
        // End:0x49F
		case 1484:
        // End:0x4A7
		case 1485:
        // End:0x4AF
		case 1486:
        // End:0x4B7
		case 627:
        // End:0x4BF
		case 680:
        // End:0x4C7
		case 681:
        // End:0x4CF
		case 682:
        // End:0x4D7
		case 683:
        // End:0x4DF
		case 686:
        // End:0x4E7
		case 688:
        // End:0x4EF
		case 692:
        // End:0x4F7
		case 695:
        // End:0x4FF
		case 696:
        // End:0x507
		case 708:
        // End:0x50F
		case 716:
        // End:0x517
		case 730:
        // End:0x51F
		case 732:
        // End:0x527
		case 736:
        // End:0x52F
		case 741:
        // End:0x537
		case 747:
        // End:0x53F
		case 749:
        // End:0x547
		case 752:
        // End:0x54F
		case 762:
        // End:0x557
		case 763:
        // End:0x55F
		case 774:
        // End:0x567
		case 775:
        // End:0x56F
		case 776:
        // End:0x577
		case 1495:
        // End:0x57F
		case 1508:
        // End:0x587
		case 1509:
        // End:0x58F
		case 1511:
        // End:0x597
		case 1512:
        // End:0x59F
		case 791:
        // End:0x5A7
		case 792:
        // End:0x5AF
		case 793:
        // End:0x5B7
		case 794:
        // End:0x5BF
		case 798:
        // End:0x5C7
		case 808:
        // End:0x5CF
		case 1524:
        // End:0x5D7
		case 1525:
        // End:0x5DF
		case 835:
        // End:0x5E7
		case 1529:
        // End:0x5EF
		case 877:
        // End:0x5F7
		case 879:
        // End:0x5FF
		case 883:
        // End:0x607
		case 886:
        // End:0x60F
		case 887:
        // End:0x617
		case 899:
        // End:0x61F
		case 904:
        // End:0x627
		case 905:
        // End:0x62F
		case 909:
        // End:0x637
		case 910:
        // End:0x63F
		case 927:
        // End:0x647
		case 1539:
        // End:0x64F
		case 1540:
        // End:0x657
		case 1541:
        // End:0x65F
		case 949:
        // End:0x667
		case 954:
        // End:0x66F
		case 1546:
        // End:0x677
		case 969:
        // End:0x67F
		case 973:
        // End:0x687
		case 974:
        // End:0x68F
		case 977:
        // End:0x697
		case 978:
        // End:0x69F
		case 979:
        // End:0x6A7
		case 980:
        // End:0x6AF
		case 981:
        // End:0x6B7
		case 985:
        // End:0x6BF
		case 991:
        // End:0x6C7
		case 1554:
        // End:0x6CF
		case 1555:
        // End:0x6D7
		case 995:
        // End:0x6DF
		case 996:
        // End:0x6E7
		case 997:
        // End:0x6EF
		case 2074:
        // End:0x6F7
		case 2234:
        // End:0x6FF
		case 2239:
        // End:0x707
		case 2399:
        // End:0x70F
		case 2839:
        // End:0x717
		case 3005:
        // End:0x71F
		case 3016:
        // End:0x727
		case 3020:
        // End:0x72F
		case 3021:
        // End:0x737
		case 3024:
        // End:0x73F
		case 3040:
        // End:0x747
		case 3041:
        // End:0x74F
		case 3052:
        // End:0x757
		case 3053:
        // End:0x75F
		case 3054:
        // End:0x767
		case 3055:
        // End:0x76F
		case 3061:
        // End:0x777
		case 3062:
        // End:0x77F
		case 3070:
        // End:0x787
		case 3074:
        // End:0x78F
		case 3075:
        // End:0x797
		case 3078:
        // End:0x79F
		case 3079:
        // End:0x7A7
		case 3571:
        // End:0x7AF
		case 3574:
        // End:0x7B7
		case 3577:
        // End:0x7BF
		case 3579:
        // End:0x7C7
		case 3584:
        // End:0x7CF
		case 3586:
        // End:0x7D7
		case 3588:
        // End:0x7DF
		case 3590:
        // End:0x7E7
		case 3594:
        // End:0x7EF
		case 3083:
        // End:0x7F7
		case 3084:
        // End:0x7FF
		case 3085:
        // End:0x807
		case 3086:
        // End:0x80F
		case 3087:
        // End:0x817
		case 3088:
        // End:0x81F
		case 3089:
        // End:0x827
		case 3090:
        // End:0x82F
		case 3091:
        // End:0x837
		case 3092:
        // End:0x83F
		case 3093:
        // End:0x847
		case 3094:
        // End:0x84F
		case 3096:
        // End:0x857
		case 3097:
        // End:0x85F
		case 3098:
        // End:0x867
		case 3099:
        // End:0x86F
		case 3100:
        // End:0x877
		case 3101:
        // End:0x87F
		case 3102:
        // End:0x887
		case 3103:
        // End:0x88F
		case 3104:
        // End:0x897
		case 3105:
        // End:0x89F
		case 3106:
        // End:0x8A7
		case 3107:
        // End:0x8AF
		case 3111:
        // End:0x8B7
		case 3112:
        // End:0x8BF
		case 3113:
        // End:0x8C7
		case 3114:
        // End:0x8CF
		case 3115:
        // End:0x8D7
		case 3116:
        // End:0x8DF
		case 3117:
        // End:0x8E7
		case 3118:
        // End:0x8EF
		case 3119:
        // End:0x8F7
		case 3120:
        // End:0x8FF
		case 3121:
        // End:0x907
		case 3122:
        // End:0x90F
		case 3137:
        // End:0x917
		case 3187:
        // End:0x91F
		case 3188:
        // End:0x927
		case 3189:
        // End:0x92F
		case 3190:
        // End:0x937
		case 3191:
        // End:0x93F
		case 3192:
        // End:0x947
		case 3193:
        // End:0x94F
		case 3194:
        // End:0x957
		case 3195:
        // End:0x95F
		case 3196:
        // End:0x967
		case 3197:
        // End:0x96F
		case 3198:
        // End:0x977
		case 3331:
        // End:0x97F
		case 8240:
        // End:0x987
		case 8276:
        // End:0x98F
		case 8357:
        // End:0x997
		case 7007:
        // End:0x99F
		case 4018:
        // End:0x9A7
		case 4019:
        // End:0x9AF
		case 4034:
        // End:0x9B7
		case 4035:
        // End:0x9BF
		case 4036:
        // End:0x9C7
		case 4037:
        // End:0x9CF
		case 4038:
        // End:0x9D7
		case 4046:
        // End:0x9DF
		case 4047:
        // End:0x9E7
		case 4052:
        // End:0x9EF
		case 4053:
        // End:0x9F7
		case 4054:
        // End:0x9FF
		case 4055:
        // End:0xA07
		case 4063:
        // End:0xA0F
		case 4064:
        // End:0xA17
		case 4070:
        // End:0xA1F
		case 4072:
        // End:0xA27
		case 4073:
        // End:0xA2F
		case 4075:
        // End:0xA37
		case 4076:
        // End:0xA3F
		case 4082:
        // End:0xA47
		case 4088:
        // End:0xA4F
		case 4098:
        // End:0xA57
		case 4102:
        // End:0xA5F
		case 4104:
        // End:0xA67
		case 4106:
        // End:0xA6F
		case 4107:
        // End:0xA77
		case 4108:
        // End:0xA7F
		case 4109:
        // End:0xA87
		case 4111:
        // End:0xA8F
		case 4117:
        // End:0xA97
		case 4118:
        // End:0xA9F
		case 4119:
        // End:0xAA7
		case 4120:
        // End:0xAAF
		case 4126:
        // End:0xAB7
		case 4131:
        // End:0xABF
		case 4140:
        // End:0xAC7
		case 4145:
        // End:0xACF
		case 4146:
        // End:0xAD7
		case 4148:
        // End:0xADF
		case 4149:
        // End:0xAE7
		case 4150:
        // End:0xAEF
		case 4153:
        // End:0xAF7
		case 4162:
        // End:0xAFF
		case 4164:
        // End:0xB07
		case 4165:
        // End:0xB0F
		case 4166:
        // End:0xB17
		case 4167:
        // End:0xB1F
		case 4182:
        // End:0xB27
		case 4183:
        // End:0xB2F
		case 4184:
        // End:0xB37
		case 4185:
        // End:0xB3F
		case 4186:
        // End:0xB47
		case 4187:
        // End:0xB4F
		case 4188:
        // End:0xB57
		case 4189:
        // End:0xB5F
		case 4190:
        // End:0xB67
		case 4196:
        // End:0xB6F
		case 4197:
        // End:0xB77
		case 4198:
        // End:0xB7F
		case 4199:
        // End:0xB87
		case 4200:
        // End:0xB8F
		case 4201:
        // End:0xB97
		case 4202:
        // End:0xB9F
		case 4203:
        // End:0xBA7
		case 4204:
        // End:0xBAF
		case 4205:
        // End:0xBB7
		case 4206:
        // End:0xBBF
		case 4215:
        // End:0xBC7
		case 4219:
        // End:0xBCF
		case 4236:
        // End:0xBD7
		case 4237:
        // End:0xBDF
		case 4238:
        // End:0xBE7
		case 4243:
        // End:0xBEF
		case 4245:
        // End:0xBF7
		case 4249:
        // End:0xBFF
		case 4258:
        // End:0xC07
		case 4259:
        // End:0xC0F
		case 4315:
        // End:0xC17
		case 4319:
        // End:0xC1F
		case 4320:
        // End:0xC27
		case 4321:
        // End:0xC2F
		case 4361:
        // End:0xC37
		case 4362:
        // End:0xC3F
		case 4363:
        // End:0xC47
		case 4382:
        // End:0xC4F
		case 4515:
        // End:0xC57
		case 4533:
        // End:0xC5F
		case 4534:
        // End:0xC67
		case 4535:
        // End:0xC6F
		case 4536:
        // End:0xC77
		case 4537:
        // End:0xC7F
		case 4538:
        // End:0xC87
		case 4539:
        // End:0xC8F
		case 4540:
        // End:0xC97
		case 4541:
        // End:0xC9F
		case 4547:
        // End:0xCA7
		case 4577:
        // End:0xCAF
		case 4578:
        // End:0xCB7
		case 4579:
        // End:0xCBF
		case 4580:
        // End:0xCC7
		case 4581:
        // End:0xCCF
		case 4582:
        // End:0xCD7
		case 4583:
        // End:0xCDF
		case 4584:
        // End:0xCE7
		case 4586:
        // End:0xCEF
		case 4587:
        // End:0xCF7
		case 4589:
        // End:0xCFF
		case 4590:
        // End:0xD07
		case 4591:
        // End:0xD0F
		case 4592:
        // End:0xD17
		case 4593:
        // End:0xD1F
		case 4594:
        // End:0xD27
		case 4596:
        // End:0xD2F
		case 4597:
        // End:0xD37
		case 4598:
        // End:0xD3F
		case 4599:
        // End:0xD47
		case 4600:
        // End:0xD4F
		case 4602:
        // End:0xD57
		case 4603:
        // End:0xD5F
		case 4604:
        // End:0xD67
		case 4605:
        // End:0xD6F
		case 4606:
        // End:0xD77
		case 4615:
        // End:0xD7F
		case 4620:
        // End:0xD87
		case 4624:
        // End:0xD8F
		case 4625:
        // End:0xD97
		case 4640:
        // End:0xD9F
		case 4643:
        // End:0xDA7
		case 4649:
        // End:0xDAF
		case 4657:
        // End:0xDB7
		case 4658:
        // End:0xDBF
		case 4659:
        // End:0xDC7
		case 4660:
        // End:0xDCF
		case 4661:
        // End:0xDD7
		case 4662:
        // End:0xDDF
		case 4670:
        // End:0xDE7
		case 4683:
        // End:0xDEF
		case 4684:
        // End:0xDF7
		case 4688:
        // End:0xDFF
		case 4689:
        // End:0xE07
		case 4694:
        // End:0xE0F
		case 4695:
        // End:0xE17
		case 4696:
        // End:0xE1F
		case 4705:
        // End:0xE27
		case 4706:
        // End:0xE2F
		case 4708:
        // End:0xE37
		case 4710:
        // End:0xE3F
		case 4169:
        // End:0xE47
		case 4724:
        // End:0xE4F
		case 4725:
        // End:0xE57
		case 4726:
        // End:0xE5F
		case 4727:
        // End:0xE67
		case 4728:
        // End:0xE6F
		case 4172:
        // End:0xE77
		case 4180:
        // End:0xE7F
		case 4744:
        // End:0xE87
		case 4745:
        // End:0xE8F
		case 4746:
        // End:0xE97
		case 4747:
        // End:0xE9F
		case 4748:
        // End:0xEA7
		case 4208:
        // End:0xEAF
		case 4759:
        // End:0xEB7
		case 4760:
        // End:0xEBF
		case 4761:
        // End:0xEC7
		case 4762:
        // End:0xECF
		case 4763:
        // End:0xED7
		case 4496:
        // End:0xEDF
		case 4769:
        // End:0xEE7
		case 4770:
        // End:0xEEF
		case 4771:
        // End:0xEF7
		case 4772:
        // End:0xEFF
		case 4773:
        // End:0xF07
		case 4463:
        // End:0xF0F
		case 4464:
        // End:0xF17
		case 4465:
        // End:0xF1F
		case 4466:
        // End:0xF27
		case 4467:
        // End:0xF2F
		case 4473:
        // End:0xF37
		case 4480:
        // End:0xF3F
		case 4481:
        // End:0xF47
		case 4482:
        // End:0xF4F
		case 4483:
        // End:0xF57
		case 4486:
        // End:0xF5F
		case 4487:
        // End:0xF67
		case 4488:
        // End:0xF6F
		case 4492:
        // End:0xF77
		case 4991:
        // End:0xF7F
		case 4992:
        // End:0xF87
		case 5004:
        // End:0xF8F
		case 5012:
        // End:0xF97
		case 5016:
        // End:0xF9F
		case 5020:
        // End:0xFA7
		case 5022:
        // End:0xFAF
		case 5023:
        // End:0xFB7
		case 5024:
        // End:0xFBF
		case 5037:
        // End:0xFC7
		case 5068:
        // End:0xFCF
		case 5069:
        // End:0xFD7
		case 5070:
        // End:0xFDF
		case 5071:
        // End:0xFE7
		case 5072:
        // End:0xFEF
		case 5081:
        // End:0xFF7
		case 5083:
        // End:0xFFF
		case 5085:
        // End:0x1007
		case 5086:
        // End:0x100F
		case 5092:
        // End:0x1017
		case 5112:
        // End:0x101F
		case 5114:
        // End:0x1027
		case 5116:
        // End:0x102F
		case 5117:
        // End:0x1037
		case 5120:
        // End:0x103F
		case 5134:
        // End:0x1047
		case 5137:
        // End:0x104F
		case 5138:
        // End:0x1057
		case 5140:
        // End:0x105F
		case 5145:
        // End:0x1067
		case 5160:
        // End:0x106F
		case 5166:
        // End:0x1077
		case 5167:
        // End:0x107F
		case 5168:
        // End:0x1087
		case 5169:
        // End:0x108F
		case 5170:
        // End:0x1097
		case 5171:
        // End:0x109F
		case 5172:
        // End:0x10A7
		case 5173:
        // End:0x10AF
		case 5174:
        // End:0x10B7
		case 5175:
        // End:0x10BF
		case 5176:
        // End:0x10C7
		case 5177:
        // End:0x10CF
		case 5183:
        // End:0x10D7
		case 5196:
        // End:0x10DF
		case 5197:
        // End:0x10E7
		case 5198:
        // End:0x10EF
		case 5199:
        // End:0x10F7
		case 5202:
        // End:0x10FF
		case 5203:
        // End:0x1107
		case 5206:
        // End:0x110F
		case 5207:
        // End:0x1117
		case 5219:
        // End:0x111F
		case 5220:
        // End:0x1127
		case 7066:
        // End:0x112F
		case 7067:
        // End:0x1137
		case 7076:
        // End:0x113F
		case 7077:
        // End:0x1147
		case 7080:
        // End:0x114F
		case 5229:
        // End:0x1157
		case 5230:
        // End:0x115F
		case 5231:
        // End:0x1167
		case 5232:
        // End:0x116F
		case 5238:
        // End:0x1177
		case 5240:
        // End:0x117F
		case 5241:
        // End:0x1187
		case 5242:
        // End:0x118F
		case 5243:
        // End:0x1197
		case 5247:
        // End:0x119F
		case 5250:
        // End:0x11A7
		case 5251:
        // End:0x11AF
		case 5252:
        // End:0x11B7
		case 5253:
        // End:0x11BF
		case 5254:
        // End:0x11C7
		case 5255:
        // End:0x11CF
		case 5256:
        // End:0x11D7
		case 5258:
        // End:0x11DF
		case 5259:
        // End:0x11E7
		case 5260:
        // End:0x11EF
		case 5261:
        // End:0x11F7
		case 5264:
        // End:0x11FF
		case 5266:
        // End:0x1207
		case 5268:
        // End:0x120F
		case 5269:
        // End:0x1217
		case 5270:
        // End:0x121F
		case 5271:
        // End:0x1227
		case 5301:
        // End:0x122F
		case 5302:
        // End:0x1237
		case 5303:
        // End:0x123F
		case 5304:
        // End:0x1247
		case 5305:
        // End:0x124F
		case 5306:
        // End:0x1257
		case 5307:
        // End:0x125F
		case 5308:
        // End:0x1267
		case 5309:
        // End:0x126F
		case 5333:
        // End:0x1277
		case 5362:
        // End:0x127F
		case 5363:
        // End:0x1287
		case 5364:
        // End:0x128F
		case 5365:
        // End:0x1297
		case 5366:
        // End:0x129F
		case 5367:
        // End:0x12A7
		case 5368:
        // End:0x12AF
		case 5369:
        // End:0x12B7
		case 5370:
        // End:0x12BF
		case 5394:
        // End:0x12C7
		case 5399:
        // End:0x12CF
		case 5401:
        // End:0x12D7
		case 5422:
        // End:0x12DF
		case 5423:
        // End:0x12E7
		case 5424:
        // End:0x12EF
		case 5431:
        // End:0x12F7
		case 5434:
        // End:0x12FF
		case 5435:
        // End:0x1307
		case 5443:
        // End:0x130F
		case 5444:
        // End:0x1317
		case 5447:
        // End:0x131F
		case 5456:
        // End:0x1327
		case 5459:
        // End:0x132F
		case 5460:
        // End:0x1337
		case 5481:
        // End:0x133F
		case 5482:
        // End:0x1347
		case 5495:
        // End:0x134F
		case 5496:
        // End:0x1357
		case 5497:
        // End:0x135F
		case 5500:
        // End:0x1367
		case 5501:
        // End:0x136F
		case 5502:
        // End:0x1377
		case 5505:
        // End:0x137F
		case 5506:
        // End:0x1387
		case 5507:
        // End:0x138F
		case 5508:
        // End:0x1397
		case 5509:
        // End:0x139F
		case 5510:
        // End:0x13A7
		case 5511:
        // End:0x13AF
		case 5512:
        // End:0x13B7
		case 5523:
        // End:0x13BF
		case 5529:
        // End:0x13C7
		case 5530:
        // End:0x13CF
		case 5551:
        // End:0x13D7
		case 5565:
        // End:0x13DF
		case 5566:
        // End:0x13E7
		case 5567:
        // End:0x13EF
		case 5568:
        // End:0x13F7
		case 5569:
        // End:0x13FF
		case 5581:
        // End:0x1407
		case 5583:
        // End:0x140F
		case 5584:
        // End:0x1417
		case 5585:
        // End:0x141F
		case 5592:
        // End:0x1427
		case 5594:
        // End:0x142F
		case 5595:
        // End:0x1437
		case 5596:
        // End:0x143F
		case 5600:
        // End:0x1447
		case 5602:
        // End:0x144F
		case 5623:
        // End:0x1457
		case 5624:
        // End:0x145F
		case 5625:
        // End:0x1467
		case 5660:
        // End:0x146F
		case 5661:
        // End:0x1477
		case 5665:
        // End:0x147F
		case 5666:
        // End:0x1487
		case 5667:
        // End:0x148F
		case 5668:
        // End:0x1497
		case 5669:
        // End:0x149F
		case 5670:
        // End:0x14A7
		case 5671:
        // End:0x14AF
		case 5672:
        // End:0x14B7
		case 5673:
        // End:0x14BF
		case 5679:
        // End:0x14C7
		case 5683:
        // End:0x14CF
		case 5687:
        // End:0x14D7
		case 5688:
        // End:0x14DF
		case 5693:
        // End:0x14E7
		case 5696:
        // End:0x14EF
		case 5697:
        // End:0x14F7
		case 5703:
        // End:0x14FF
		case 5706:
        // End:0x1507
		case 5707:
        // End:0x150F
		case 5715:
        // End:0x1517
		case 5716:
        // End:0x151F
		case 5733:
        // End:0x1527
		case 5735:
        // End:0x152F
		case 5747:
        // End:0x1537
		case 5764:
        // End:0x153F
		case 5778:
        // End:0x1547
		case 5794:
        // End:0x154F
		case 5795:
        // End:0x1557
		case 5796:
        // End:0x155F
		case 5797:
        // End:0x1567
		case 5798:
        // End:0x156F
		case 5799:
        // End:0x1577
		case 5800:
        // End:0x157F
		case 5801:
        // End:0x1587
		case 5802:
        // End:0x158F
		case 5803:
        // End:0x1597
		case 5804:
        // End:0x159F
		case 5806:
        // End:0x15A7
		case 5807:
        // End:0x15AF
		case 5808:
        // End:0x15B7
		case 5809:
        // End:0x15BF
		case 5810:
        // End:0x15C7
		case 5811:
        // End:0x15CF
		case 5812:
        // End:0x15D7
		case 5813:
        // End:0x15DF
		case 5814:
        // End:0x15E7
		case 5831:
        // End:0x15EF
		case 5832:
        // End:0x15F7
		case 5843:
        // End:0x15FF
		case 5846:
        // End:0x1607
		case 5849:
        // End:0x160F
		case 5851:
        // End:0x1617
		case 5854:
        // End:0x161F
		case 5855:
        // End:0x1627
		case 5860:
        // End:0x162F
		case 5861:
        // End:0x1637
		case 5866:
        // End:0x163F
		case 5867:
        // End:0x1647
		case 5868:
        // End:0x164F
		case 5869:
        // End:0x1657
		case 5870:
        // End:0x165F
		case 5871:
        // End:0x1667
		case 5872:
        // End:0x166F
		case 5873:
        // End:0x1677
		case 5874:
        // End:0x167F
		case 5875:
        // End:0x1687
		case 5876:
        // End:0x168F
		case 5877:
        // End:0x1697
		case 5878:
        // End:0x169F
		case 5879:
        // End:0x16A7
		case 5880:
        // End:0x16AF
		case 5881:
        // End:0x16B7
		case 5882:
        // End:0x16BF
		case 5883:
        // End:0x16C7
		case 5884:
        // End:0x16CF
		case 5885:
        // End:0x16D7
		case 5886:
        // End:0x16DF
		case 5887:
        // End:0x16E7
		case 5888:
        // End:0x16EF
		case 5889:
        // End:0x16F7
		case 5890:
        // End:0x16FF
		case 5891:
        // End:0x1707
		case 5892:
        // End:0x170F
		case 5893:
        // End:0x1717
		case 5894:
        // End:0x171F
		case 5895:
        // End:0x1727
		case 5896:
        // End:0x172F
		case 5897:
        // End:0x1737
		case 5898:
        // End:0x173F
		case 5899:
        // End:0x1747
		case 5900:
        // End:0x174F
		case 5901:
        // End:0x1757
		case 5903:
        // End:0x175F
		case 5904:
        // End:0x1767
		case 5905:
        // End:0x176F
		case 5907:
        // End:0x1777
		case 5908:
        // End:0x177F
		case 5912:
        // End:0x1787
		case 5914:
        // End:0x178F
		case 5919:
        // End:0x1797
		case 5921:
        // End:0x179F
		case 5922:
        // End:0x17A7
		case 5937:
        // End:0x17AF
		case 5941:
        // End:0x17B7
		case 5942:
        // End:0x17BF
		case 5943:
        // End:0x17C7
		case 5944:
        // End:0x17CF
		case 5945:
        // End:0x17D7
		case 5960:
        // End:0x17DF
		case 5961:
        // End:0x17E7
		case 5967:
        // End:0x17EF
		case 5969:
        // End:0x17F7
		case 5981:
        // End:0x17FF
		case 5984:
        // End:0x1807
		case 5992:
        // End:0x180F
		case 5993:
        // End:0x1817
		case 5994:
        // End:0x181F
		case 6024:
        // End:0x1827
		case 6033:
        // End:0x182F
		case 6090:
        // End:0x1837
		case 6091:
        // End:0x183F
		case 6092:
        // End:0x1847
		case 6095:
        // End:0x184F
		case 6125:
        // End:0x1857
		case 6126:
        // End:0x185F
		case 6129:
        // End:0x1867
		case 6130:
        // End:0x186F
		case 6131:
        // End:0x1877
		case 6132:
        // End:0x187F
		case 6133:
        // End:0x1887
		case 6134:
        // End:0x188F
		case 6135:
        // End:0x1897
		case 6140:
        // End:0x189F
		case 6141:
        // End:0x18A7
		case 6142:
        // End:0x18AF
		case 6146:
        // End:0x18B7
		case 6148:
        // End:0x18BF
		case 6149:
        // End:0x18C7
		case 6150:
        // End:0x18CF
		case 6151:
        // End:0x18D7
		case 6152:
        // End:0x18DF
		case 6153:
        // End:0x18E7
		case 6154:
        // End:0x18EF
		case 6155:
        // End:0x18F7
		case 6166:
        // End:0x18FF
		case 6167:
        // End:0x1907
		case 6168:
        // End:0x190F
		case 6169:
        // End:0x1917
		case 6187:
        // End:0x191F
		case 6189:
        // End:0x1927
		case 6190:
        // End:0x192F
		case 6205:
        // End:0x1937
		case 6206:
        // End:0x193F
		case 6237:
        // End:0x1947
		case 6238:
        // End:0x194F
		case 6240:
        // End:0x1957
		case 6250:
        // End:0x195F
		case 6263:
        // End:0x1967
		case 6266:
        // End:0x196F
		case 6269:
        // End:0x1977
		case 6273:
        // End:0x197F
		case 6274:
        // End:0x1987
		case 6275:
        // End:0x198F
		case 6276:
        // End:0x1997
		case 6280:
        // End:0x199F
		case 6281:
        // End:0x19A7
		case 6283:
        // End:0x19AF
		case 6299:
        // End:0x19B7
		case 6300:
        // End:0x19BF
		case 6304:
        // End:0x19C7
		case 6306:
        // End:0x19CF
		case 6307:
        // End:0x19D7
		case 6308:
        // End:0x19DF
		case 6309:
        // End:0x19E7
		case 6312:
        // End:0x19EF
		case 6314:
        // End:0x19F7
		case 6320:
        // End:0x19FF
		case 6326:
        // End:0x1A07
		case 6328:
        // End:0x1A0F
		case 6331:
        // End:0x1A17
		case 6332:
        // End:0x1A1F
		case 6333:
        // End:0x1A27
		case 6334:
        // End:0x1A2F
		case 6335:
        // End:0x1A37
		case 6336:
        // End:0x1A3F
		case 6339:
        // End:0x1A47
		case 6340:
        // End:0x1A4F
		case 6342:
        // End:0x1A57
		case 6370:
        // End:0x1A5F
		case 6373:
        // End:0x1A67
		case 6374:
        // End:0x1A6F
		case 6375:
        // End:0x1A77
		case 6378:
        // End:0x1A7F
		case 6379:
        // End:0x1A87
		case 6380:
        // End:0x1A8F
		case 6381:
        // End:0x1A97
		case 6382:
        // End:0x1A9F
		case 6383:
        // End:0x1AA7
		case 6384:
        // End:0x1AAF
		case 6385:
        // End:0x1AB7
		case 6386:
        // End:0x1ABF
		case 6389:
        // End:0x1AC7
		case 6390:
        // End:0x1ACF
		case 6391:
        // End:0x1AD7
		case 6392:
        // End:0x1ADF
		case 6395:
        // End:0x1AE7
		case 6396:
        // End:0x1AEF
		case 6397:
        // End:0x1AF7
		case 6398:
        // End:0x1AFF
		case 6400:
        // End:0x1B07
		case 6402:
        // End:0x1B0F
		case 6403:
        // End:0x1B17
		case 6404:
        // End:0x1B1F
		case 6406:
        // End:0x1B27
		case 6407:
        // End:0x1B2F
		case 6408:
        // End:0x1B37
		case 6410:
        // End:0x1B3F
		case 6414:
        // End:0x1B47
		case 6416:
        // End:0x1B4F
		case 6417:
        // End:0x1B57
		case 6418:
        // End:0x1B5F
		case 6423:
        // End:0x1B67
		case 6428:
        // End:0x1B6F
		case 6435:
        // End:0x1B77
		case 6436:
        // End:0x1B7F
		case 6437:
        // End:0x1B87
		case 6438:
        // End:0x1B8F
		case 6439:
        // End:0x1B97
		case 6440:
        // End:0x1B9F
		case 6441:
        // End:0x1BA7
		case 6618:
        // End:0x1BAF
		case 6619:
        // End:0x1BB7
		case 6622:
        // End:0x1BBF
		case 6624:
        // End:0x1BC7
		case 6650:
        // End:0x1BCF
		case 6651:
        // End:0x1BD7
		case 6662:
        // End:0x1BDF
		case 6677:
        // End:0x1BE7
		case 6688:
        // End:0x1BEF
		case 6690:
        // End:0x1BF7
		case 6697:
        // End:0x1BFF
		case 6698:
        // End:0x1C07
		case 6705:
        // End:0x1C0F
		case 6733:
        // End:0x1C17
		case 6734:
        // End:0x1C1F
		case 6735:
        // End:0x1C27
		case 6738:
        // End:0x1C2F
		case 6743:
        // End:0x1C37
		case 6744:
        // End:0x1C3F
		case 6746:
        // End:0x1C47
		case 6748:
        // End:0x1C4F
		case 6750:
        // End:0x1C57
		case 6751:
        // End:0x1C5F
		case 6754:
        // End:0x1C67
		case 6757:
        // End:0x1C6F
		case 6760:
        // End:0x1C77
		case 6761:
        // End:0x1C7F
		case 6763:
        // End:0x1C87
		case 6768:
        // End:0x1C8F
		case 6769:
        // End:0x1C97
		case 6772:
        // End:0x1C9F
		case 6774:
        // End:0x1CA7
		case 6775:
        // End:0x1CAF
		case 6776:
        // End:0x1CB7
		case 6777:
        // End:0x1CBF
		case 6779:
        // End:0x1CC7
		case 6815:
        // End:0x1CCF
		case 6816:
        // End:0x1CD7
		case 6819:
        // End:0x1CDF
		case 6821:
        // End:0x1CE7
		case 6822:
        // End:0x1CEF
		case 6825:
        // End:0x1CF7
		case 6827:
        // End:0x1CFF
		case 6828:
        // End:0x1D07
		case 6830:
        // End:0x1D0F
		case 6836:
        // End:0x1D17
		case 6840:
        // End:0x1D1F
		case 6853:
        // End:0x1D27
		case 6854:
        // End:0x1D2F
		case 6862:
        // End:0x1D37
		case 6863:
        // End:0x1D3F
		case 6865:
        // End:0x1D47
		case 6873:
        // End:0x1D4F
		case 6875:
        // End:0x1D57
		case 6878:
        // End:0x1D5F
		case 6880:
        // End:0x1D67
		case 6882:
        // End:0x1D6F
		case 6890:
        // End:0x1D77
		case 6897:
        // End:0x1D7F
		case 6912:
        // End:0x1D87
		case 23069:
        // End:0x1D8F
		case 23070:
        // End:0x1D97
		case 23071:
        // End:0x1D9F
		case 23124:
        // End:0x1DA7
		case 23169:
        // End:0x1DAF
		case 23170:
        // End:0x1DB7
		case 6921:
        // End:0x1DBF
		case 23298:
        // End:0x1DC7
		case 23299:
        // End:0x1DCF
		case 23300:
        // End:0x1DD7
		case 23319:
        // End:0x1DDF
		case 23320:
        // End:0x1DE7
		case 23321:
        // End:0x1DEF
		case 23322:
        // End:0x1E02
		case 23323:
			chelakua = True;
            // End:0x1E05
			break;
        // End:0xFFFF
		default:
			break;
	}
	return chelakua;

}


function bool xxgetcoinida2(int Id)
{
	local bool testkaxa;

	switch(Id)
	{
        // End:0x0F
		case 2057:
        // End:0x17
		case 2058:
        // End:0x2A
		case 2059:
			testkaxa = True;
            // End:0x2D
			break;
        // End:0xFFFF
		default:
			break;
	}
	return testkaxa;

}




function CustomTooltip xxMakeTooltipSimpleText(string Text)
{
	local CustomTooltip ToolTip;
	local DrawItemInfo Info;

	ToolTip.DrawList.Length = 1;
	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = True;
	Info.t_strText = Text;
	ToolTip.DrawList[0] = Info;
	return ToolTip;
}



function Color getColor (string m_Color)
{
	local Color MsnColor;

	switch (m_Color)
	{
		case "Yellow":
			MsnColor.R = 255;
			MsnColor.G = 255;
			MsnColor.B = 0;
			break;
		case "System":
			MsnColor.R = 176;
			MsnColor.G = 155;
			MsnColor.B = 121;
			break;
		case "Amber":
			MsnColor.R = 218;
			MsnColor.G = 165;
			MsnColor.B = 32;
			break;
		case "White":
			MsnColor.R = 255;
			MsnColor.G = 255;
			MsnColor.B = 255;
			break;
		case "Gray":
			MsnColor.R = 153;
			MsnColor.G = 153;
			MsnColor.B = 153;
			break;
		case "Magenta":
			MsnColor.R = 255;
			MsnColor.G = 0;
			MsnColor.B = 255;
			break;
		case "Blue":
			MsnColor.R = 64;
			MsnColor.G = 140;
			MsnColor.B = 255;
			break;
		case "COMMANDER":
			MsnColor.R = 255;
			MsnColor.G = 150;
			MsnColor.B = 150;
			break;
		case "Ivory":
			MsnColor.R = 228;
			MsnColor.G = 218;
			MsnColor.B = 188;
			break;
		case "Red":
			MsnColor.R = 204;
			MsnColor.G = 51;
			MsnColor.B = 51;
			break;
		default:
			MsnColor.R = 204;
			MsnColor.G = 204;
			MsnColor.B = 204;
			break;
	}
	return MsnColor;
}


function float calculeflo(int i, int x)
{
	return float(i) / float(x);

}

function bool calculebol(int i, int o)
{
	return i == o;

}

function bool calculemixmax(int i, int o)
{
	return i > o;

}

function calculemenosmenosa(out int i)
{
	i--;
	return;
}

function bool calculesame(string i, string o)
{
	return i == o;

}

function bool calculemulti(bool i, bool o)
{
	return i || o;

}

function int calculeresta(int i, int o)
{
	return i - o;

}


function int calculesuma(int i, int o)
{
	return i + o;

}


function bool calculemenor(int i, int o)
{
	return i < o;

}

function caculemasmas(out int i)
{
	i++;
	return;
}


function bool calculeand2(bool i, bool o)
{
	return i && o;

}

function bool calculedesigual(bool i)
{
	return !i;

}


function string calculeburgatugar(string i, string o)
{
	return i$o;

}

function bool calculemayorigual(int i, int o)
{
	return i >= o;

}

function bool calculemenorigual(int i, int o)
{
	return i <= o;

}

function bool xxIsUseAutoEquipSoulShot()
{
	return True;
}

function showfocutios(string param)
{
    // End:0x1C
	if( IsShowWindow(param) )
	{
		HideWindow(param);
	}
	else
	{
		ShowWindow(param);
		class'UIAPI_WINDOW'.static.SetFocus(param);
	}
	return;
}

function int xxGetShotSlot(int shotID)
{
	switch (shotID)
	{
		case 1835:
		case 1463:
		case 1464:
		case 1465:
		case 1466:
		case 1467:
			return 1;
			break;
		case 3947:
		case 3948:
		case 3949:
		case 3950:
		case 3951:
		case 3952:
		case 2509:
		case 2510:
		case 2511:
		case 2512:
		case 2513:
		case 2514:
			return 2;
			break;
		case 6645:
			return 3;
			break;
		case 6646:
		case 6647:
			return 4;
			break;
		default:
	}
}


function int xxGetSoulShotID(int WeaponGrade)
{
	local ItemInfo weaponItemInfo;

	switch (WeaponGrade)
	{
		case 0:
			if ( xxGetItemWindowHandle("InventoryWnd.EquipItem_RHand").GetItem(0,weaponItemInfo) )
			{
				return 1835;
			}
			break;
		case 1:
			return 1463;
			break;
		case 2:
			return 1464;
			break;
		case 3:
			return 1465;
			break;
		case 4:
			return 1466;
			break;
		case 5:
			return 1467;
			break;
		default:
	}
}



function int xxGetSpiritShotID(int WeaponGrade)
{
	local ItemInfo weaponItemInfo;

	switch (WeaponGrade)
	{
		case 0:
			if ( xxGetItemWindowHandle("InventoryWnd.EquipItem_RHand").GetItem(0,weaponItemInfo) )
			{
				return 2509;
			}
			break;
		case 1:
			return 2510;
			break;
		case 2:
			return 2511;
			break;
		case 3:
			return 2512;
			break;
		case 4:
			return 2513;
			break;
		case 5:
			return 2514;
			break;
		default:
	}
}

function int xxGetBlessedSpiritShotID(int WeaponGrade)
{
	local ItemInfo weaponItemInfo;

	switch (WeaponGrade)
	{
		case 0:
			if ( xxGetItemWindowHandle("InventoryWnd.EquipItem_RHand").GetItem(0,weaponItemInfo) )
			{
				return 3947;
			}
			break;
		case 1:
			return 3948;
			break;
		case 2:
			return 3949;
			break;
		case 3:
			return 3950;
			break;
		case 4:
			return 3951;
			break;
		case 5:
			return 3952;
			break;
		default:
	}
}


function calculetamax3ia(out int i)
{
	++i;
	return;
}




function SetPositions (string index, string param, int idx, int X, int Y)
{
	switch (idx)
	{
		case 1:
			class'UIAPI_WINDOW'.static.SetAnchor(index,param,"TopLeft","TopLeft",X,Y);
			break;
		case 2:
			class'UIAPI_WINDOW'.static.SetAnchor(index,param,"TopCenter","TopCenter",X,Y);
			break;
		case 3:
			class'UIAPI_WINDOW'.static.SetAnchor(index,param,"TopRight","TopRight",X,Y);
			break;
		case 4:
			class'UIAPI_WINDOW'.static.SetAnchor(index,param,"CenterLeft","CenterLeft",X,Y);
			break;
		case 5:
			class'UIAPI_WINDOW'.static.SetAnchor(index,param,"Center","Center",X,Y);
			break;
		case 6:
			class'UIAPI_WINDOW'.static.SetAnchor(index,param,"CenterRight","CenterRight",X,Y);
			break;
		case 7:
			class'UIAPI_WINDOW'.static.SetAnchor(index,param,"BottomLeft","BottomLeft",X,Y);
			break;
		case 8:
			class'UIAPI_WINDOW'.static.SetAnchor(index,param,"BottomCenter","BottomCenter",X,Y);
			break;
		default:
	}
}








function ItemInfoToParam (ItemInfo Info, out string param)
{
	ParamAdd(param,"ClassID",string(Info.ClassID));
	ParamAdd(param,"ServerID",string(Info.ServerID));
	ParamAdd(param,"level",string(Info.Level));
	ParamAdd(param,"name",Info.Name);
	ParamAdd(param,"additionalName",Info.AdditionalName);
	ParamAdd(param,"iconName",Info.IconName);
	ParamAdd(param,"description",Info.Description);
	ParamAdd(param,"itemType",string(Info.ItemType));
	ParamAdd(param,"itemNum",string(Info.ItemNum));
	ParamAdd(param,"slotBitType",string(Info.SlotBitType));
	ParamAdd(param,"enchanted",string(Info.Enchanted));
	ParamAdd(param,"blessed",string(Info.Blessed));
	ParamAdd(param,"damaged",string(Info.Damaged));
	ParamAdd(param,"equipped",string(Info.bEquipped));
	ParamAdd(param,"price",string(Info.Price));
	ParamAdd(param,"reserved",string(Info.Reserved));
	ParamAdd(param,"defaultPrice",string(Info.DefaultPrice));
	ParamAdd(param,"refineryOp1",string(Info.RefineryOp1));
	ParamAdd(param,"refineryOp2",string(Info.RefineryOp2));
	ParamAdd(param,"currentDurability",string(Info.CurrentDurability));
	ParamAdd(param,"weight",string(Info.Weight));
	ParamAdd(param,"materialType",string(Info.MaterialType));
	ParamAdd(param,"weaponType",string(Info.WeaponType));
	ParamAdd(param,"physicalDamage",string(Info.PhysicalDamage));
	ParamAdd(param,"magicalDamage",string(Info.MagicalDamage));
	ParamAdd(param,"shieldDefense",string(Info.ShieldDefense));
	ParamAdd(param,"shieldDefenseRate",string(Info.ShieldDefenseRate));
	ParamAdd(param,"durability",string(Info.Durability));
	ParamAdd(param,"crystalType",string(Info.CrystalType));
	ParamAdd(param,"randomDamage",string(Info.RandomDamage));
	ParamAdd(param,"critical",string(Info.Critical));
	ParamAdd(param,"hitModify",string(Info.HitModify));
	ParamAdd(param,"attackSpeed",string(Info.AttackSpeed));
	ParamAdd(param,"mpConsume",string(Info.MpConsume));
	ParamAdd(param,"avoidModify",string(Info.AvoidModify));
	ParamAdd(param,"soulshotCount",string(Info.SoulshotCount));
	ParamAdd(param,"spiritshotCount",string(Info.SpiritshotCount));
	ParamAdd(param,"armorType",string(Info.ArmorType));
	ParamAdd(param,"physicalDefense",string(Info.PhysicalDefense));
	ParamAdd(param,"magicalDefense",string(Info.MagicalDefense));
	ParamAdd(param,"mpBonus",string(Info.MpBonus));
	ParamAdd(param,"consumeType",string(Info.ConsumeType));
	ParamAdd(param,"ItemSubType",string(Info.ItemSubType));
	ParamAdd(param,"iconNameEx1",Info.IconNameEx1);
	ParamAdd(param,"iconNameEx2",Info.IconNameEx2);
	ParamAdd(param,"iconNameEx3",Info.IconNameEx3);
	ParamAdd(param,"iconNameEx4",Info.IconNameEx4);
	ParamAdd(param,"arrow",string(Info.bArrow));
	ParamAdd(param,"recipe",string(Info.bRecipe));
}




function Color xxGetColorito(string val)
{
	local Color colit;
	colit.A = 255;

	switch(val)
	{
		case "Goldlite":
			colit.R = 240;
			colit.G = 227;
			colit.B = 200;
			break;
		case "BlueLite":
			colit.R = 0;
			colit.G = 242;
			colit.B = 255;
			break;
		case "RedLite":
			colit.R = 255;
			colit.G = 80;
			colit.B = 80;
			break;
		case "Grey":
			colit.R = 180;
			colit.G = 180;
			colit.B = 180;
			break;
		case "GreyLight":
			colit.R = 220;
			colit.G = 220;
			colit.B = 220;
			break;
		case "GreyDark":
			colit.R = 100;
			colit.G = 100;
			colit.B = 100;
			break;
		case "Yellow":
			colit.R = 255;
			colit.G = 255;
			colit.B = 0;
			break;
		case "Red":
			colit.R = 255;
			colit.G = 0;
			colit.B = 0;
			break;
		case "Blue":
			colit.R = 0;
			colit.G = 0;
			colit.B = 255;
			break;
		case "Green":
			colit.R = 0;
			colit.G = 255;
			colit.B = 0;
			break;
		case "Orange":
			colit.R = 230;
			colit.G = 153;
			colit.B = 77;
			break;
		case "System":
			colit.R = 176;
			colit.G = 155;
			colit.B = 121;
			break;
		case "Amber":
			colit.R = 218;
			colit.G = 165;
			colit.B = 32;
			break;
		case "White":
			colit.R = 255;
			colit.G = 255;
			colit.B = 255;
			break;
		case "Dim":
			colit.R = 177;
			colit.G = 173;
			colit.B = 172;
			break;
		case "Magenta":
			colit.R = 255;
			colit.G = 0;
			colit.B = 255;
			break;
		case "Brown":
			colit.R = 176;
			colit.G = 155;
			colit.B = 121;
			break;
		case "Black":
			colit.R = 0;
			colit.G = 0;
			colit.B = 0;
			break;
		default:
			colit.R = 255;
			colit.G = 255;
			colit.B = 255;
			break;
	}

	return colit;
}

function SysDebug (string Str, optional bool Clear)
{
	local TextListBoxHandle Debug;

	Debug = TextListBoxHandle(GetHandle("ConsoleDebug.debug"));
	if ( !(IsShowWindow("ConsoleDebug")) )
	{
		ShowWindow("ConsoleDebug");
	}
	if ( Clear )
	{
		Debug.Clear();
	}
	Debug.AddString(Str,xxgetInstanceL2Util().Red);
}

function float xxmultiplicorato(float zzd, float zzsw)
{
	return zzd * zzsw;

}

function float xxdividorazo(float zzd, float zzsw)
{
	return zzd / zzsw;

}

function bool xxIsValidItemID(ItemInfo Id)
{
    // End:0x24
	if( (Id.ClassID < 1) && Id.ServerID < 1 )
	{
		return False;
	}
	return True;

}


function Color GetNumColor(string strCommaAdena)
{
	local Color ResultColor;
	local int L;

    // Inicializa los componentes de ResultColor con valores predeterminados.
	ResultColor.R = 220;
	ResultColor.G = 220;
	ResultColor.B = 220;
	ResultColor.A = 255;

    // Obtiene la longitud de la cadena strCommaAdena.
	L = Len(strCommaAdena);

    // Si la cadena contiene una coma, realiza una accion desconocida y almacena el resultado en comma_num.
	if ( InStr(strCommaAdena, ",") != -1 )
	{
        // Realiza una accion desconocida para obtener el valor de comma_num.
        // UnknownFunction163(comma_num);
	}

    // Si la longitud de la cadena es 5, devuelve ResultColor sin hacer mas calculos.
	if ( L == 5 )
	{
		return ResultColor;
	}

    // Ajusta la longitud a 5 para que se pueda utilizar en el siguiente switch.
	L = Clamp(L, 0, 5);

    // Asigna diferentes valores de color a ResultColor segun el valor de L.
	switch (L)
	{
		case 0:
			ResultColor.R = 105;
			ResultColor.G = 255;
			ResultColor.B = 255;
			break;

		case 1:
			ResultColor.R = 255;
			ResultColor.G = 128;
			ResultColor.B = 255;
			break;

		case 2:
			ResultColor.R = 255;
			ResultColor.G = 255;
			ResultColor.B = 0;
			break;

		case 3:
			ResultColor.R = 0;
			ResultColor.G = 255;
			ResultColor.B = 0;
			break;

		case 4:
			ResultColor.R = 255;
			ResultColor.G = 140;
			ResultColor.B = 0;
			break;

		case 5:
			ResultColor.R = 0;
			ResultColor.G = 110;
			ResultColor.B = 255;
			break;

		default:
            // Manejar otros casos, si es necesario.
			break;
	}

    // Devuelve ResultColor con los componentes actualizados.
	return ResultColor;
}


function bool isScrollID(int ScrollID)
{
    // IDs de los scrolls a verificar
	switch (ScrollID)
	{
		case 10000:
		case 11000:
		case 10001:
		case 11001:
		case 955:
		case 6575:
		case 957:
		case 951:
		case 6573:
		case 953:
		case 947:
		case 6571:
		case 949:
		case 729:
		case 6569:
		case 731:
		case 959:
		case 6577:
		case 961:
		case 956:
		case 6576:
		case 958:
		case 952:
		case 6574:
		case 954:
		case 948:
		case 6572:
		case 950:
		case 730:
		case 6570:
		case 732:
		case 960:
		case 6578:
		case 962:
		case 9329:
		case 9330:
		case 9506:
		case 9507:
			return True;
		default:
			return False;
	}
}



function int xxscrolltype(int zzScrollID)
{
	switch (zzScrollID)
	{
		case 10000:
		case 11000:
		case 10001:
		case 11001:
		case 955:
		case 6575:
		case 957:
		case 951:
		case 6573:
		case 953:
		case 947:
		case 6571:
		case 949:
		case 729:
		case 6569:
		case 731:
		case 959:
		case 6577:
		case 9329:
		case 9506:
		case 961:
			return 1;
		case 956:
		case 6576:
		case 958:
		case 952:
		case 6574:
		case 954:
		case 948:
		case 6572:
		case 950:
		case 730:
		case 6570:
		case 732:
		case 960:
		case 6578:
		case 962:
		case 9330:
		case 9507:
			return 2;


	}
}



function bool scrolls(ItemInfo infItem, int ScrollID)
{
	switch (ScrollID)
	{
		case 10000:
		case 11000:
			return (infItem.ItemType == 0) && (infItem.CrystalType >= 1);

		case 10001:
		case 11001:
			return (infItem.ItemType == 1 || infItem.ItemType == 2) || (infItem.CrystalType > 1);

		case 955:
		case 6575:
		case 957:
			return (infItem.ItemType == 0) && (infItem.CrystalType == 1);

		case 951:
		case 6573:
		case 953:
			return (infItem.ItemType == 0) && (infItem.CrystalType == 2);

		case 947:
		case 6571:
		case 949:
			return (infItem.ItemType == 0) && (infItem.CrystalType == 3);

		case 729:
		case 6569:
		case 731:
			return (infItem.ItemType == 0) && (infItem.CrystalType == 4);

		case 959:
		case 6577:
		case 9329:
		case 9506:
		case 961:
			return (infItem.ItemType == 0) && (infItem.CrystalType > 4);

		case 956:
		case 6576:
		case 958:
			return (infItem.ItemType > 0 && infItem.ItemType <= 2) && (infItem.CrystalType == 1);

		case 952:
		case 6574:
		case 954:
			return (infItem.ItemType > 0 && infItem.ItemType <= 2) && (infItem.CrystalType == 2);

		case 948:
		case 6572:
		case 950:
			return (infItem.ItemType > 0 && infItem.ItemType <= 2) && (infItem.CrystalType == 3);

		case 730:
		case 6570:
		case 732:
			return (infItem.ItemType > 0 && infItem.ItemType <= 2) && (infItem.CrystalType == 4);

		case 960:
		case 6578:
		case 962:
		case 9330:
		case 9507:
			return (infItem.ItemType > 0 && infItem.ItemType <= 2) && (infItem.CrystalType > 4);

		default:
			return False;
	}
}


function bool xxisConsumable(int Id)
{
	local bool isCons;

	switch(Id)
	{
        // End:0x0F
		case 1835:
        // End:0x17
		case 1463:
        // End:0x1F
		case 1464:
        // End:0x27
		case 1465:
        // End:0x2F
		case 1466:
        // End:0x37
		case 1467:
        // End:0x3F
		case 3947:
        // End:0x47
		case 3948:
        // End:0x4F
		case 3949:
        // End:0x57
		case 3950:
        // End:0x5F
		case 3951:
        // End:0x67
		case 3952:
        // End:0x6F
		case 2509:
        // End:0x77
		case 2510:
        // End:0x7F
		case 2511:
        // End:0x87
		case 2512:
        // End:0x8F
		case 2513:
        // End:0x97
		case 2514:
        // End:0x9F
		case 6645:
        // End:0xA7
		case 6646:
        // End:0xBA
		case 6647:
			isCons = True;
            // End:0xBD
			break;
        // End:0xFFFF
		default:
			break;
	}
	return isCons;

}

function string tpgm(string seg)
{
	return seg;
}

function EditBoxHandle EditBoxHandle (string WindowName)
{
	local EditBoxHandle Handle;

	Handle = EditBoxHandle(GetHandle(WindowName));
	return Handle;
}


function TreeClear (string Str)
{
	class'UIAPI_TREECTRL'.static.Clear(Str);
}

function string getxml( string val, string val2, XMLTreeNodeInfo xml)
{
	return Class'UIAPI_TREECTRL'.static.InsertNode(val,val2,xml);
}


function xxstx2k23( string zzTreeName, string zzNodeName, string zzTextureName, int zzTextureWidth, int zzTextureHeight, optional int zzoffsetX, optional int zzoffsetY, optional bool zzOneLine, optional bool zzbLineBreak, optional int zzVAL, optional int zzVAL2, optional string VALSTR)
{
	local XMLTreeNodeItemInfo zzinfNode;

	zzinfNode.eType = XTNITEM_TEXTURE;
	zzinfNode.t_bDrawOneLine = zzOneLine;
	zzinfNode.bLineBreak = zzbLineBreak;
	zzinfNode.nOffSetX = zzoffsetX;
	zzinfNode.nOffSetY = zzoffsetY;
	zzinfNode.u_nTextureWidth = zzTextureWidth;
	zzinfNode.u_nTextureHeight = zzTextureHeight;

	zzinfNode.u_nTextureUWidth = zzVAL;
	zzinfNode.u_nTextureUHeight = zzVAL2;
	zzinfNode.u_strTexture = zzTextureName;


	getinsertnodeitem(zzTreeName,zzNodeName,zzinfNode);
}


function xxStxXml(string zzTreeName, string zzNodeName, string zzItemName, optional int zzoffsetX, optional int zzoffsetY, optional int E, optional bool zzOneLine, optional bool zzbLineBreak)
{
	local XMLTreeNodeItemInfo zzinfNodeItem;

    // Aseg??rate de que el nombre del nodo sea ??nico
	zzinfNodeItem.eType = XTNITEM_TEXT;
	zzinfNodeItem.t_strText = zzItemName;
	zzinfNodeItem.t_bDrawOneLine = zzOneLine;
	zzinfNodeItem.bLineBreak = zzbLineBreak;
	zzinfNodeItem.nOffSetX = zzoffsetX;
	zzinfNodeItem.nOffSetY = zzoffsetY;
	zzinfNodeItem = Virtual(E, zzinfNodeItem);
	class'UIAPI_TREECTRL'.static.InsertNodeItem(zzTreeName, zzNodeName, zzinfNodeItem);
}


function getinsertnodeitem ( string val, string val2 , XMLTreeNodeItemInfo val3 )
{
	class'UIAPI_TREECTRL'.static.InsertNodeItem(val,val2,val3);
}



function XMLTreeNodeItemInfo Virtual(int E, XMLTreeNodeItemInfo infNodeItem)
{
	switch (E)
	{
		case 0:
			infNodeItem.t_color.R = 255;
			infNodeItem.t_color.G = 255;
			infNodeItem.t_color.B = 255;
			infNodeItem.t_color.A = 255;
			break;
		case 1:
			infNodeItem.t_color.R = 163;
			infNodeItem.t_color.G = 163;
			infNodeItem.t_color.B = 163;
			infNodeItem.t_color.A = 255;
			break;
		case 2:
			infNodeItem.t_color.R = 176;
			infNodeItem.t_color.G = 155;
			infNodeItem.t_color.B = 121;
			infNodeItem.t_color.A = 255;
			break;
		case 3:
			infNodeItem.t_color.R = 250;
			infNodeItem.t_color.G = 50;
			infNodeItem.t_color.B = 0;
			infNodeItem.t_color.A = 255;
			break;
		case 4:
			infNodeItem.t_color.R = 240;
			infNodeItem.t_color.G = 214;
			infNodeItem.t_color.B = 54;
			infNodeItem.t_color.A = 255;
			break;
		case 5:
			infNodeItem.t_color.R = 175;
			infNodeItem.t_color.G = 185;
			infNodeItem.t_color.B = 205;
			infNodeItem.t_color.A = 255;
			break;
		case 6:
			infNodeItem.t_color.R = 102;
			infNodeItem.t_color.G = 150;
			infNodeItem.t_color.B = 253;
			infNodeItem.t_color.A = 255;
			break;
		case 7:
			infNodeItem.t_color.R = 85;
			infNodeItem.t_color.G = 170;
			infNodeItem.t_color.B = 255;
			infNodeItem.t_color.A = 255;
			break;
		case 8:
			infNodeItem.t_color.R = 211;
			infNodeItem.t_color.G = 192;
			infNodeItem.t_color.B = 82;
			infNodeItem.t_color.A = 255;
			break;
		case 9:
			infNodeItem.t_color.R = 170;
			infNodeItem.t_color.G = 152;
			infNodeItem.t_color.B = 120;
			infNodeItem.t_color.A = 255;
			break;
		case 10:
			infNodeItem.t_color.R = 168;
			infNodeItem.t_color.G = 103;
			infNodeItem.t_color.B = 53;
			infNodeItem.t_color.A = 255;
			break;
		case 11:
			infNodeItem.t_color.R = 175;
			infNodeItem.t_color.G = 42;
			infNodeItem.t_color.B = 39;
			infNodeItem.t_color.A = 255;
			break;
		case 12:
			infNodeItem.t_color.R = 255;
			infNodeItem.t_color.G = 204;
			infNodeItem.t_color.B = 0;
			infNodeItem.t_color.A = 255;
			break;
		case 13:
			infNodeItem.t_color.R = 170;
			infNodeItem.t_color.G = 110;
			infNodeItem.t_color.B = 230;
			infNodeItem.t_color.A = 255;
			break;
		default:
	}
	return infNodeItem;
}

function getrechandle(string oaran, out int i, out int o)
{
	local Rect rectaxa;

	rectaxa = GetHandle(oaran).GetRect();
	i = rectaxa.nX;
	o = rectaxa.nY;
	return;
}

function ComboBoxHandle xxGetComboBoxHandle( string WindowName )
{
	local ComboBoxHandle Handle;

	Handle = ComboBoxHandle(GetHandle(WindowName));
	return Handle;
}


function TreeInsertRootNode(string TreeName, string NodeName, string ParentName, optional int offsetX, optional int offsetY)
{
	local XMLTreeNodeInfo infNode;

    // Aseg??rate de que el nombre del nodo sea ??nico
	infNode.strName = NodeName;
	infNode.nOffSetX = offsetX;
	infNode.nOffSetY = offsetY;
	class'UIAPI_TREECTRL'.static.InsertNode(TreeName, ParentName, infNode);
}

function ListCtrlHandle ListCtrlHandle (string WindowName)
{
	local ListCtrlHandle Handle;

	Handle = ListCtrlHandle(GetHandle(WindowName));
	return Handle;
}

function insNodeItem(string strTreeName, string strNodeName, XMLTreeNodeItemInfo infNodeItem)
{
	class'UIAPI_TREECTRL'.static.InsertNodeItem(strTreeName, strNodeName, infNodeItem);
}


function TreeInsertNodeItemColor(string TreeName, string NodeName, string ItemName, optional int offsetX, optional int offsetY, optional Color nodeColor, optional bool bOutline, optional bool bLineBreak)
{
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = ItemName;
	infNodeItem.t_bDrawOneLine = bOutline;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = offsetX;
	infNodeItem.nOffSetY = offsetY;
	infNodeItem.t_color = nodeColor;

	insNodeItem(TreeName, NodeName, infNodeItem);
}

function OMG(string Msg)
{
	local ChatWindowHandle NormalChat;
	local Color iColor;

	NormalChat = ChatWindowHandle(GetHandle("ChatWnd.NormalChat"));
	iColor.R = 255;
	iColor.G = 0;
	iColor.B = 255;
	iColor.A = 255;
	NormalChat.AddString(("LotusInfo: "$Msg),iColor);
}


function string setItemTier(string strIndex, string strCompare)
{
	local int i, j;

	j = Len(strCompare);
	i = InStr(strIndex, strCompare);
	if( i > -1 )
	{
		return Mid(strIndex, i + j, 1);
	}
	return "";
}


function DrawItemInfo xxDrawBlank(int Height)
{
	local DrawItemInfo Info;

	Info.eType = DIT_BLANK;
	Info.b_nHeight = Height;
	return Info;
}


function DrawItemInfo DrawTex(string Tex, int Width, int Height, int UWidth, int UHeight, int nOffSetX, int nOffSetY, bool bDrawOneLine, bool bLineBreak)
{
	local DrawItemInfo Info;

	Info.eType = DIT_TEXTURE;
	Info.t_bDrawOneLine = bDrawOneLine;
	Info.bLineBreak = bLineBreak;
	Info.u_nTextureWidth = Width;
	Info.u_nTextureHeight = Height;
	Info.u_nTextureUWidth = UWidth;
	Info.u_nTextureUHeight = UHeight;
	Info.nOffSetX = nOffSetX;
	Info.nOffSetY = nOffSetY;
	Info.u_strTexture = Tex;
	return Info;
}

function Color SetCustomColor ( string Colors)
{
	local Color RGB;

	RGB.A = 255;
	switch (Colors)
	{
		case "Goldlite":
			RGB.R = 230;
			RGB.G = 213;
			RGB.B = 164;
			break;
		case "Grey":
			RGB.R = 180;
			RGB.G = 180;
			RGB.B = 180;
			break;
		case "GreyLight":
			RGB.R = 220;
			RGB.G = 220;
			RGB.B = 220;
			break;
		case "GreyDark":
			RGB.R = 100;
			RGB.G = 100;
			RGB.B = 100;
			break;
		case "Yellow":
			RGB.R = 255;
			RGB.G = 255;
			RGB.B = 0;
			break;
		case "Red":
			RGB.R = 255;
			RGB.G = 0;
			RGB.B = 0;
			break;
		case "Blue":
			RGB.R = 0;
			RGB.G = 0;
			RGB.B = 255;
			break;
		case "Green":
			RGB.R = 0;
			RGB.G = 255;
			RGB.B = 0;
			break;
		case "Orange":
			RGB.R = 230;
			RGB.G = 153;
			RGB.B = 77;
			break;
		case "System":
			RGB.R = 176;
			RGB.G = 155;
			RGB.B = 121;
			break;
		case "Amber":
			RGB.R = 218;
			RGB.G = 165;
			RGB.B = 32;
			break;
		case "White":
			RGB.R = 255;
			RGB.G = 255;
			RGB.B = 255;
			break;
		case "Dim":
			RGB.R = 177;
			RGB.G = 173;
			RGB.B = 172;
			break;
		case "Magenta":
			RGB.R = 255;
			RGB.G = 0;
			RGB.B = 255;
			break;
		case "Brown":
			RGB.R = 176;
			RGB.G = 155;
			RGB.B = 121;
			break;
		case "Black":
			RGB.R = 0;
			RGB.G = 0;
			RGB.B = 0;
			break;
		case "LightPink":
			RGB.R = 191;
			RGB.G = 168;
			RGB.B = 211;
			break;
		case "LightBlue":
			RGB.R = 0;
			RGB.G = 168;
			RGB.B = 211;
			break;
		default:
			RGB.R = 255;
			RGB.G = 255;
			RGB.B = 255;
			break;
	}
	return RGB;
}


function Color getAColor (int R, int G, int B, int A)
{
	local Color tColor;

	tColor.R = R;
	tColor.G = G;
	tColor.B = B;
	tColor.A = A;
	return tColor;
}


function bool getItemInveCompare(int SlotBitType, out ItemWindowHandle hItemWnd)
{
	local ItemInfo ItemSlot;

	switch(SlotBitType)
	{
		case 2:
		case 4:
		case 6:
			if( !xxGetItemWindowHandle("InventoryWnd.EquipItem_REar").GetItem(0, ItemSlot) )
			{
				hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_REar");
			}
			else
			{
				hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_LEar");
			}
			return True;
			break;

		case 16:
		case 32:
		case 48:
			if( !xxGetItemWindowHandle("InventoryWnd.EquipItem_RFinger").GetItem(0, ItemSlot) )
			{
				hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_RFinger");
			}
			else
			{
				hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_LFinger");
			}
			return True;
			break;

		case 8:
			hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_Neck");
			return True;
			break;

		case 64:
			hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_Head");
			return True;
			break;

		case 1024:
		case 32768:
			hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_Chest");
			return True;
			break;

		case 2048:
			hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_Legs");
			return True;
			break;

		case 512:
			hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_Gloves");
			return True;
			break;

		case 4096:
			hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_Feet");
			return True;
			break;

		case 256:
			hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_LHand");
			return True;
			break;

		case 16384:
		case 128:
			hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_RHand");
			return True;
			break;

		default:
			return False;
			break;
	}
}


function int EnchantCalculateWeapon (ItemInfo item)
{
	local UserInfo myInfo;

	if ( GetPlayerInfo(myInfo) )
	{
		if ( !(isMage(myInfo.nSubClass)) )
		{
			if ( item.PhysicalDamage != 0 )
			{
				return (GetPhysicalDamage(item.WeaponType, item.SlotBitType, item.CrystalType, item.Enchanted, item.PhysicalDamage) + item.PhysicalDamage) / 2;

			}
		} 
	
		else 
	
		{
			if ( item.MagicalDamage != 0 )
			{
				return (GetMagicalDamage(item.WeaponType, item.SlotBitType, item.CrystalType, item.Enchanted, item.MagicalDamage) + item.MagicalDamage) / 2;

			}
		}
	}
}



function int EnchantCalculateArmor (ItemInfo item)
{
	if ( (item.ShieldDefense != 0) && (item.SlotBitType == 256) || (item.SlotBitType == 128) )
	{
		return (GetShieldDefense(item.CrystalType, item.Enchanted, item.ShieldDefense) + item.ShieldDefense);

	}
	if ( item.PhysicalDefense != 0 )
	{
		return (GetPhysicalDefense(item.CrystalType, item.Enchanted, item.PhysicalDefense) + item.PhysicalDefense);

	}
}

function int EnchantCalculateJewel (ItemInfo item)
{
	if ( item.MagicalDefense != 0 )
	{
		return (GetMagicalDefense(item.CrystalType, item.Enchanted, item.MagicalDefense) + item.MagicalDefense);

	}
}

function bool isMage (int SubClassID)
{
	switch (SubClassID)
	{
		case 0:
			return False;
		case 1:
			return False;
		case 4:
			return False;
		case 7:
			return False;
		case 2:
			return False;
		case 88:
			return False;
		case 3:
			return False;
		case 89:
			return False;
		case 5:
			return False;
		case 90:
			return False;
		case 6:
			return False;
		case 91:
			return False;
		case 8:
			return False;
		case 93:
			return False;
		case 9:
			return False;
		case 92:
			return False;
		case 10:
			return True;
		case 11:
			return True;
		case 15:
			return True;
		case 12:
			return True;
		case 94:
			return True;
		case 13:
			return True;
		case 95:
			return True;
		case 14:
			return True;
		case 96:
			return True;
		case 16:
			return True;
		case 97:
			return True;
		case 17:
			return True;
		case 98:
			return True;
		case 18:
			return False;
		case 19:
			return False;
		case 22:
			return False;
		case 20:
			return False;
		case 99:
			return False;
		case 21:
			return False;
		case 100:
			return False;
		case 23:
			return False;
		case 101:
			return False;
		case 24:
			return False;
		case 102:
			return False;
		case 25:
			return True;
		case 26:
			return True;
		case 29:
			return True;
		case 27:
			return True;
		case 103:
			return True;
		case 28:
			return True;
		case 104:
			return True;
		case 30:
			return True;
		case 105:
			return True;
		case 31:
			return False;
		case 32:
			return False;
		case 35:
			return False;
		case 33:
			return False;
		case 106:
			return False;
		case 34:
			return False;
		case 107:
			return False;
		case 36:
			return False;
		case 108:
			return False;
		case 37:
			return False;
		case 109:
			return False;
		case 38:
			return True;
		case 39:
			return True;
		case 42:
			return True;
		case 40:
			return True;
		case 110:
			return True;
		case 41:
			return True;
		case 111:
			return True;
		case 43:
			return True;
		case 112:
			return True;
		case 44:
			return False;
		case 45:
			return False;
		case 56:
			return False;
		case 46:
			return False;
		case 113:
			return False;
		case 48:
			return False;
		case 114:
			return False;
		case 49:
			return True;
		case 50:
			return True;
		case 51:
			return True;
		case 115:
			return True;
		case 52:
			return True;
		case 116:
			return True;
		case 53:
			return False;
		case 56:
			return False;
		case 54:
			return False;
		case 57:
			return False;
		case 118:
			return False;
		case 55:
			return False;
		case 117:
			return False;
		default:
	}
}

function bool bTooltipItem(out string outStrIndex)
{
	local array< string> strIndex;
	local int i, j;
	local bool bShow;

	strIndex = setItemStages();
	i = 0;
J0x13:
	if( i < strIndex.Length )
	{
		j = InStr(outStrIndex, strIndex[i]);
		if( j == -1 )
		{
			goto J0xD3;
		}
		if( Right(strIndex[i], 1) == "{" )
		{
			outStrIndex = ReplaceText(outStrIndex, Mid(outStrIndex, j, InStr(outStrIndex, "}") + 3), "");
			bShow = False;
			goto J0xD3;
		}
		outStrIndex = ReplaceText(outStrIndex, Mid(outStrIndex, j, Len(strIndex[i]) + 3), "");
		bShow = True;
	J0xD3:
		i++;
		goto J0x13;
	}
	return bShow;
}

function array<string> setItemStages()
{
	local array< string> strIndex;

	strIndex[strIndex.Length] = "WeaponStage:";
	strIndex[strIndex.Length] = "WeaponStatus:";
	strIndex[strIndex.Length] = "Tier:";
	strIndex[strIndex.Length] = "ArmorStatus:";
	strIndex[strIndex.Length] = "JewelStage:";
	strIndex[strIndex.Length] = "Acquire:{";

	return strIndex;
}


function string setItemDecWidth(string strIndex, int intIndex)
{
	local int i;
	local string lineJump, outStr, compareStr;
	local array< string> writeStr;

	if( InStr(strIndex, "\\n") > -1 )
	{
		return strIndex;
	}
	outStr = "";
	compareStr = "";
	intIndex -= 6;
	lineJump = "";
	writeStr = getStringItems(strIndex, " ");
	i = 0;
J0x59:
	if( i < writeStr.Length )
	{
		if( ((GetTextWidth(compareStr)) + (GetTextWidth(writeStr[i]))) <= intIndex )
		{
			if( i == writeStr.Length )
			{
				compareStr = compareStr$writeStr[i];
			}
			else
			{
				compareStr = (compareStr$writeStr[i])$" ";
			}
			goto J0x10B;
		}
		outStr = (outStr$compareStr)$lineJump;
		compareStr = writeStr[i]$" ";
	J0x10B:
		i++;
		goto J0x59;
	}
	outStr = outStr$compareStr;
	return outStr;
}

function array<string> getStringItems(string strIndex, string strBlank)
{
	local string percStr;
	local array< string> strSize;
	local int i;

	percStr = strIndex;
J0x0B:
	if( percStr != "" )
	{
		i = InStr(percStr, strBlank);
		if( i == -1 )
		{
			strSize[strSize.Length] = percStr;
			percStr = "";
		}
		else
		{
			strSize[strSize.Length] = Left(percStr, i);
			percStr = Mid(percStr, i + Len(strBlank));
		}
		goto J0x0B;
	}
	return strSize;
}

function int setAcquireItem(string filter, string Description)
{
	local int i;
	local string strTmp, strValue;

	strTmp = Description;
	i = InStr(strTmp, filter);
	if( i != -1 )
	{
		if( filter != "Acquire:{" )
		{
			strValue = Mid(strTmp, i + Len(filter), 1);
		}
		else
		{
			return i + Len(filter);
		}
		return int(strValue);
	}
}

function int setShopItemID(string strIndex)
{
	local int outIndex, inCount, i;

	outIndex = 0;
	inCount = Len(strIndex);
	i = 0;
J0x1B:
	if( i < inCount )
	{
		outIndex = (outIndex * 31) + Asc(Mid(strIndex, i, 1));
		i++;
		goto J0x1B;
	}
	return outIndex;
}

function XMLTreeNodeItemInfo setTreeTextColor (int E, XMLTreeNodeItemInfo infNodeItem)
{
	switch (E)
	{
		case 0:
			infNodeItem.t_color.R = 255;
			infNodeItem.t_color.G = 255;
			infNodeItem.t_color.B = 255;
			infNodeItem.t_color.A = 255;
			break;
		case 1:
			infNodeItem.t_color.R = 163;
			infNodeItem.t_color.G = 163;
			infNodeItem.t_color.B = 163;
			infNodeItem.t_color.A = 255;
			break;
		case 2:
			infNodeItem.t_color.R = 176;
			infNodeItem.t_color.G = 155;
			infNodeItem.t_color.B = 121;
			infNodeItem.t_color.A = 255;
			break;
		case 3:
			infNodeItem.t_color.R = 250;
			infNodeItem.t_color.G = 50;
			infNodeItem.t_color.B = 0;
			infNodeItem.t_color.A = 255;
			break;
		case 4:
			infNodeItem.t_color.R = 240;
			infNodeItem.t_color.G = 214;
			infNodeItem.t_color.B = 54;
			infNodeItem.t_color.A = 255;
			break;
		case 5:
			infNodeItem.t_color.R = 175;
			infNodeItem.t_color.G = 185;
			infNodeItem.t_color.B = 205;
			infNodeItem.t_color.A = 255;
			break;
		case 6:
			infNodeItem.t_color.R = 102;
			infNodeItem.t_color.G = 150;
			infNodeItem.t_color.B = 253;
			infNodeItem.t_color.A = 255;
			break;
		case 7:
			infNodeItem.t_color.R = 85;
			infNodeItem.t_color.G = 170;
			infNodeItem.t_color.B = 255;
			infNodeItem.t_color.A = 255;
			break;
		case 8:
			infNodeItem.t_color.R = 211;
			infNodeItem.t_color.G = 192;
			infNodeItem.t_color.B = 82;
			infNodeItem.t_color.A = 255;
			break;
		case 9:
			infNodeItem.t_color.R = 170;
			infNodeItem.t_color.G = 152;
			infNodeItem.t_color.B = 120;
			infNodeItem.t_color.A = 255;
			break;
		case 10:
			infNodeItem.t_color.R = 168;
			infNodeItem.t_color.G = 103;
			infNodeItem.t_color.B = 53;
			infNodeItem.t_color.A = 255;
			break;
		case 11:
			infNodeItem.t_color.R = 175;
			infNodeItem.t_color.G = 42;
			infNodeItem.t_color.B = 39;
			infNodeItem.t_color.A = 255;
			break;
		case 12:
			infNodeItem.t_color.R = 255;
			infNodeItem.t_color.G = 204;
			infNodeItem.t_color.B = 0;
			infNodeItem.t_color.A = 255;
			break;
		case 13:
			infNodeItem.t_color.R = 170;
			infNodeItem.t_color.G = 110;
			infNodeItem.t_color.B = 230;
			infNodeItem.t_color.A = 255;
			break;
		default:
	}
	return infNodeItem;
}



function bool isalgo(string v, out ItemInfo info)
{
	local ItemWindowHandle me;

	me = xxGetItemWindowHandle("InventoryWnd.InventoryItem");
    // End:0x42
	if( function200(me, v, info) )
	{
		return True;
	}
	me = xxGetItemWindowHandle("InventoryWnd.QuestItem");
    // End:0x8D
	if( function200(me, v, info) )
	{
		info.bShowCount = True;
		return True;
	}
	return False;

}


function bool finditemconid(int valonmano, out ItemInfo info)
{
	local int supradurpa, conchapu;
	local ItemWindowHandle Mex;
	local InventoryWnd scripts;

	Mex = xxGetItemWindowHandle("InventoryWnd.InventoryItem");
	conchapu = tucarronax22(Mex, valonmano);
    // End:0x11F
	if( conchapu <= -1 )
	{
		Mex = xxGetItemWindowHandle("InventoryWnd.QuestItem");
		conchapu = tucarronax22(Mex, valonmano);
        // End:0x11F
		if( conchapu <= -1 )
		{
			scripts = InventoryWnd(GetScript("InventoryWnd"));
			supradurpa = 0;
		J0xBC:

            // End:0x11F [Loop If]
			if( supradurpa < 15 )
			{
				conchapu = tucarronax22(scripts.zzm_equipItem[supradurpa], valonmano);
                // End:0x115
				if( conchapu >= 0 )
				{
					Mex = scripts.zzm_equipItem[supradurpa];
                    // [Explicit Break]
					goto J0x11F;
				}
				supradurpa++;
                // [Loop Continue]
				goto J0xBC;
			}
		}
	}
J0x11F:

    // End:0x13D
	if( Mex.GetItem(conchapu, info) )
	{
		return True;
	}
	return False;

}

function int tucarronax22(ItemWindowHandle mondak, int i)
{
	local int colagusano;

    // End:0x2C
	if( i < 100000000 )
	{
		colagusano = mondak.FindItemWithClassID(i);
	}
	else
	{
		colagusano = mondak.FindItemWithServerID(i);
	}
	return colagusano;

}



function Color getcottt(string j)
{
	local Color getc;

	getc.A = byte(255);
	switch(j)
	{
        // End:0x4D
		case "Goldlite":
			getc.R = 230;
			getc.G = 213;
			getc.B = 164;
            // End:0x418
			break;
        // End:0x80
		case "Grey":
			getc.R = 180;
			getc.G = 180;
			getc.B = 180;
            // End:0x418
			break;
        // End:0xB8
		case "GreyLight":
			getc.R = 220;
			getc.G = 220;
			getc.B = 220;
            // End:0x418
			break;
        // End:0xEF
		case "GreyDark":
			getc.R = 100;
			getc.G = 100;
			getc.B = 100;
            // End:0x418
			break;
        // End:0x128
		case "Yellow":
			getc.R = byte(255);
			getc.G = byte(255);
			getc.B = 0;
            // End:0x418
			break;
        // End:0x15C
		case "Red":
			getc.R = byte(255);
			getc.G = 0;
			getc.B = 0;
            // End:0x418
			break;
        // End:0x191
		case "Blue":
			getc.R = 0;
			getc.G = 0;
			getc.B = byte(255);
            // End:0x418
			break;
        // End:0x1C7
		case "Green":
			getc.R = 0;
			getc.G = byte(255);
			getc.B = 0;
            // End:0x418
			break;
        // End:0x1FC
		case "Orange":
			getc.R = 230;
			getc.G = 153;
			getc.B = 77;
            // End:0x418
			break;
        // End:0x231
		case "System":
			getc.R = 176;
			getc.G = 155;
			getc.B = 121;
            // End:0x418
			break;
        // End:0x265
		case "Amber":
			getc.R = 218;
			getc.G = 165;
			getc.B = 32;
            // End:0x418
			break;
        // End:0x29F
		case "White":
			getc.R = byte(255);
			getc.G = byte(255);
			getc.B = byte(255);
            // End:0x418
			break;
        // End:0x2D1
		case "Dim":
			getc.R = 177;
			getc.G = 173;
			getc.B = 172;
            // End:0x418
			break;
        // End:0x30B
		case "Magenta":
			getc.R = byte(255);
			getc.G = 0;
			getc.B = byte(255);
            // End:0x418
			break;
        // End:0x33F
		case "Brown":
			getc.R = 176;
			getc.G = 155;
			getc.B = 121;
            // End:0x418
			break;
        // End:0x373
		case "Black":
			getc.R = 0;
			getc.G = 0;
			getc.B = 0;
            // End:0x418
			break;
        // End:0x3AB
		case "LightPink":
			getc.R = 191;
			getc.G = 168;
			getc.B = 211;
            // End:0x418
			break;
        // End:0x3E5
		case "LightBlue":
			getc.R = 128;
			getc.G = 153;
			getc.B = byte(255);
            // End:0x418
			break;
        // End:0xFFFF
		default:
			getc.R = byte(255);
			getc.G = byte(255);
			getc.B = byte(255);
            // End:0x418
			break;
			break;
	}
	return getc;
}



function string xxgetcoasun2a(int id)
{
	local string parametroas2;

	parametroas2 = "";
	switch(id)
	{
        // End:0x30
		case 1:
			parametroas2 = "L2UI_CH3.texCount1";
            // End:0xAFB
			break;
        // End:0x52
		case 2:
			parametroas2 = "L2UI_CH3.texCount2";
            // End:0xAFB
			break;
        // End:0x74
		case 3:
			parametroas2 = "L2UI_CH3.texCount3";
            // End:0xAFB
			break;
        // End:0x96
		case 4:
			parametroas2 = "L2UI_CH3.texCount4";
            // End:0xAFB
			break;
        // End:0xB8
		case 5:
			parametroas2 = "L2UI_CH3.texCount5";
            // End:0xAFB
			break;
        // End:0xDA
		case 6:
			parametroas2 = "L2UI_CH3.texCount6";
            // End:0xAFB
			break;
        // End:0xFC
		case 7:
			parametroas2 = "L2UI_CH3.texCount7";
            // End:0xAFB
			break;
        // End:0x11E
		case 8:
			parametroas2 = "L2UI_CH3.texCount8";
            // End:0xAFB
			break;
        // End:0x140
		case 9:
			parametroas2 = "L2UI_CH3.texCount9";
            // End:0xAFB
			break;
        // End:0x163
		case 10:
			parametroas2 = "L2UI_CH3.texCount10";
            // End:0xAFB
			break;
        // End:0x186
		case 11:
			parametroas2 = "L2UI_CH3.texCount11";
            // End:0xAFB
			break;
        // End:0x1A9
		case 12:
			parametroas2 = "L2UI_CH3.texCount12";
            // End:0xAFB
			break;
        // End:0x1CC
		case 13:
			parametroas2 = "L2UI_CH3.texCount13";
            // End:0xAFB
			break;
        // End:0x1EF
		case 14:
			parametroas2 = "L2UI_CH3.texCount14";
            // End:0xAFB
			break;
        // End:0x212
		case 15:
			parametroas2 = "L2UI_CH3.texCount15";
            // End:0xAFB
			break;
        // End:0x235
		case 16:
			parametroas2 = "L2UI_CH3.texCount16";
            // End:0xAFB
			break;
        // End:0x258
		case 17:
			parametroas2 = "L2UI_CH3.texCount17";
            // End:0xAFB
			break;
        // End:0x27B
		case 18:
			parametroas2 = "L2UI_CH3.texCount18";
            // End:0xAFB
			break;
        // End:0x29E
		case 19:
			parametroas2 = "L2UI_CH3.texCount19";
            // End:0xAFB
			break;
        // End:0x2C1
		case 20:
			parametroas2 = "L2UI_CH3.texCount20";
            // End:0xAFB
			break;
        // End:0x2E4
		case 21:
			parametroas2 = "L2UI_CH3.texCount21";
            // End:0xAFB
			break;
        // End:0x307
		case 22:
			parametroas2 = "L2UI_CH3.texCount22";
            // End:0xAFB
			break;
        // End:0x32A
		case 23:
			parametroas2 = "L2UI_CH3.texCount23";
            // End:0xAFB
			break;
        // End:0x34D
		case 24:
			parametroas2 = "L2UI_CH3.texCount24";
            // End:0xAFB
			break;
        // End:0x370
		case 25:
			parametroas2 = "L2UI_CH3.texCount25";
            // End:0xAFB
			break;
        // End:0x393
		case 26:
			parametroas2 = "L2UI_CH3.texCount26";
            // End:0xAFB
			break;
        // End:0x3B6
		case 27:
			parametroas2 = "L2UI_CH3.texCount27";
            // End:0xAFB
			break;
        // End:0x3D9
		case 28:
			parametroas2 = "L2UI_CH3.texCount28";
            // End:0xAFB
			break;
        // End:0x3FC
		case 29:
			parametroas2 = "L2UI_CH3.texCount29";
            // End:0xAFB
			break;
        // End:0x41F
		case 30:
			parametroas2 = "L2UI_CH3.texCount30";
            // End:0xAFB
			break;
        // End:0x442
		case 31:
			parametroas2 = "L2UI_CH3.texCount31";
            // End:0xAFB
			break;
        // End:0x465
		case 32:
			parametroas2 = "L2UI_CH3.texCount32";
            // End:0xAFB
			break;
        // End:0x488
		case 33:
			parametroas2 = "L2UI_CH3.texCount33";
            // End:0xAFB
			break;
        // End:0x4AB
		case 34:
			parametroas2 = "L2UI_CH3.texCount34";
            // End:0xAFB
			break;
        // End:0x4CE
		case 35:
			parametroas2 = "L2UI_CH3.texCount35";
            // End:0xAFB
			break;
        // End:0x4F1
		case 36:
			parametroas2 = "L2UI_CH3.texCount36";
            // End:0xAFB
			break;
        // End:0x514
		case 37:
			parametroas2 = "L2UI_CH3.texCount37";
            // End:0xAFB
			break;
        // End:0x537
		case 38:
			parametroas2 = "L2UI_CH3.texCount38";
            // End:0xAFB
			break;
        // End:0x55A
		case 39:
			parametroas2 = "L2UI_CH3.texCount39";
            // End:0xAFB
			break;
        // End:0x57D
		case 40:
			parametroas2 = "L2UI_CH3.texCount40";
            // End:0xAFB
			break;
        // End:0x5A0
		case 41:
			parametroas2 = "L2UI_CH3.texCount41";
            // End:0xAFB
			break;
        // End:0x5C3
		case 42:
			parametroas2 = "L2UI_CH3.texCount42";
            // End:0xAFB
			break;
        // End:0x5E6
		case 43:
			parametroas2 = "L2UI_CH3.texCount43";
            // End:0xAFB
			break;
        // End:0x609
		case 44:
			parametroas2 = "L2UI_CH3.texCount44";
            // End:0xAFB
			break;
        // End:0x62C
		case 45:
			parametroas2 = "L2UI_CH3.texCount45";
            // End:0xAFB
			break;
        // End:0x64F
		case 46:
			parametroas2 = "L2UI_CH3.texCount46";
            // End:0xAFB
			break;
        // End:0x672
		case 47:
			parametroas2 = "L2UI_CH3.texCount47";
            // End:0xAFB
			break;
        // End:0x695
		case 48:
			parametroas2 = "L2UI_CH3.texCount48";
            // End:0xAFB
			break;
        // End:0x6B8
		case 49:
			parametroas2 = "L2UI_CH3.texCount49";
            // End:0xAFB
			break;
        // End:0x6DB
		case 50:
			parametroas2 = "L2UI_CH3.texCount50";
            // End:0xAFB
			break;
        // End:0x6FE
		case 51:
			parametroas2 = "L2UI_CH3.texCount51";
            // End:0xAFB
			break;
        // End:0x721
		case 52:
			parametroas2 = "L2UI_CH3.texCount52";
            // End:0xAFB
			break;
        // End:0x744
		case 53:
			parametroas2 = "L2UI_CH3.texCount53";
            // End:0xAFB
			break;
        // End:0x767
		case 54:
			parametroas2 = "L2UI_CH3.texCount54";
            // End:0xAFB
			break;
        // End:0x78A
		case 55:
			parametroas2 = "L2UI_CH3.texCount55";
            // End:0xAFB
			break;
        // End:0x7AD
		case 56:
			parametroas2 = "L2UI_CH3.texCount56";
            // End:0xAFB
			break;
        // End:0x7D0
		case 57:
			parametroas2 = "L2UI_CH3.texCount57";
            // End:0xAFB
			break;
        // End:0x7F3
		case 58:
			parametroas2 = "L2UI_CH3.texCount58";
            // End:0xAFB
			break;
        // End:0x816
		case 59:
			parametroas2 = "L2UI_CH3.texCount59";
            // End:0xAFB
			break;
        // End:0x839
		case 60:
			parametroas2 = "L2UI_CH3.texCount60";
            // End:0xAFB
			break;
        // End:0x85C
		case 61:
			parametroas2 = "L2UI_CH3.texCount61";
            // End:0xAFB
			break;
        // End:0x87F
		case 62:
			parametroas2 = "L2UI_CH3.texCount62";
            // End:0xAFB
			break;
        // End:0x8A2
		case 63:
			parametroas2 = "L2UI_CH3.texCount63";
            // End:0xAFB
			break;
        // End:0x8C5
		case 64:
			parametroas2 = "L2UI_CH3.texCount64";
            // End:0xAFB
			break;
        // End:0x8E8
		case 65:
			parametroas2 = "L2UI_CH3.texCount65";
            // End:0xAFB
			break;
        // End:0x90B
		case 66:
			parametroas2 = "L2UI_CH3.texCount66";
            // End:0xAFB
			break;
        // End:0x92E
		case 67:
			parametroas2 = "L2UI_CH3.texCount67";
            // End:0xAFB
			break;
        // End:0x951
		case 68:
			parametroas2 = "L2UI_CH3.texCount68";
            // End:0xAFB
			break;
        // End:0x974
		case 69:
			parametroas2 = "L2UI_CH3.texCount69";
            // End:0xAFB
			break;
        // End:0x997
		case 70:
			parametroas2 = "L2UI_CH3.texCount70";
            // End:0xAFB
			break;
        // End:0x9BA
		case 71:
			parametroas2 = "L2UI_CH3.texCount71";
            // End:0xAFB
			break;
        // End:0x9DD
		case 72:
			parametroas2 = "L2UI_CH3.texCount72";
            // End:0xAFB
			break;
        // End:0xA00
		case 73:
			parametroas2 = "L2UI_CH3.texCount73";
            // End:0xAFB
			break;
        // End:0xA23
		case 74:
			parametroas2 = "L2UI_CH3.texCount74";
            // End:0xAFB
			break;
        // End:0xA46
		case 75:
			parametroas2 = "L2UI_CH3.texCount75";
            // End:0xAFB
			break;
        // End:0xA69
		case 76:
			parametroas2 = "L2UI_CH3.texCount76";
            // End:0xAFB
			break;
        // End:0xA8C
		case 77:
			parametroas2 = "L2UI_CH3.texCount77";
            // End:0xAFB
			break;
        // End:0xAAF
		case 78:
			parametroas2 = "L2UI_CH3.texCount78";
            // End:0xAFB
			break;
        // End:0xAD2
		case 79:
			parametroas2 = "L2UI_CH3.texCount79";
            // End:0xAFB
			break;
        // End:0xAF5
		case 80:
			parametroas2 = "L2UI_CH3.texCount80";
            // End:0xAFB
			break;
        // End:0xFFFF
		default:
            // End:0xAFB
			break;
			break;
	}
	return parametroas2;

}



function string xxgetcosaku211a(int ClassID)
{
	local string pasmua2a1;

	pasmua2a1 = "";
	switch(ClassID)
	{
        // End:0x38
		case 0:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_1";
            // End:0xE8E
			break;
        // End:0x61
		case 1:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_1";
            // End:0xE8E
			break;
        // End:0x8B
		case 2:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_1";
            // End:0xE8E
			break;
        // End:0xB5
		case 3:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_1";
            // End:0xE8E
			break;
        // End:0xDF
		case 4:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_1";
            // End:0xE8E
			break;
        // End:0x109
		case 5:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_3";
            // End:0xE8E
			break;
        // End:0x133
		case 6:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_3";
            // End:0xE8E
			break;
        // End:0x15D
		case 7:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_1";
            // End:0xE8E
			break;
        // End:0x187
		case 8:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_1";
            // End:0xE8E
			break;
        // End:0x1B1
		case 9:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_2";
            // End:0xE8E
			break;
        // End:0x1DB
		case 10:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_2";
            // End:0xE8E
			break;
        // End:0x205
		case 11:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_2";
            // End:0xE8E
			break;
        // End:0x22F
		case 12:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_5";
            // End:0xE8E
			break;
        // End:0x259
		case 13:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_5";
            // End:0xE8E
			break;
        // End:0x283
		case 14:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_7";
            // End:0xE8E
			break;
        // End:0x2AD
		case 15:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_2";
            // End:0xE8E
			break;
        // End:0x2D7
		case 16:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_6";
            // End:0xE8E
			break;
        // End:0x301
		case 17:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_6";
            // End:0xE8E
			break;
        // End:0x32B
		case 18:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_1";
            // End:0xE8E
			break;
        // End:0x355
		case 19:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_2";
            // End:0xE8E
			break;
        // End:0x37F
		case 20:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_3";
            // End:0xE8E
			break;
        // End:0x3A9
		case 21:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_4";
            // End:0xE8E
			break;
        // End:0x3D3
		case 22:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_1";
            // End:0xE8E
			break;
        // End:0x3FD
		case 23:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_1";
            // End:0xE8E
			break;
        // End:0x427
		case 24:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_2";
            // End:0xE8E
			break;
        // End:0x451
		case 25:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_2";
            // End:0xE8E
			break;
        // End:0x47B
		case 26:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_2";
            // End:0xE8E
			break;
        // End:0x4A5
		case 27:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_5";
            // End:0xE8E
			break;
        // End:0x4CF
		case 28:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_7";
            // End:0xE8E
			break;
        // End:0x4F9
		case 29:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_2";
            // End:0xE8E
			break;
        // End:0x523
		case 30:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_6";
            // End:0xE8E
			break;
        // End:0x54D
		case 31:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_1";
            // End:0xE8E
			break;
        // End:0x577
		case 32:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_1";
            // End:0xE8E
			break;
        // End:0x5A1
		case 33:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_3";
            // End:0xE8E
			break;
        // End:0x5CB
		case 34:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_4";
            // End:0xE8E
			break;
        // End:0x5F5
		case 35:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_1";
            // End:0xE8E
			break;
        // End:0x61F
		case 36:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_1";
            // End:0xE8E
			break;
        // End:0x649
		case 37:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_2";
            // End:0xE8E
			break;
        // End:0x673
		case 38:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_2";
            // End:0xE8E
			break;
        // End:0x69D
		case 39:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_2";
            // End:0xE8E
			break;
        // End:0x6C7
		case 40:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_5";
            // End:0xE8E
			break;
        // End:0x6F1
		case 41:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_7";
            // End:0xE8E
			break;
        // End:0x71B
		case 42:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_2";
            // End:0xE8E
			break;
        // End:0x745
		case 43:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_6";
            // End:0xE8E
			break;
        // End:0x76F
		case 44:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_1";
            // End:0xE8E
			break;
        // End:0x799
		case 45:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_1";
            // End:0xE8E
			break;
        // End:0x7C3
		case 46:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_1";
            // End:0xE8E
			break;
        // End:0x7ED
		case 47:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_1";
            // End:0xE8E
			break;
        // End:0x817
		case 48:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_1";
            // End:0xE8E
			break;
        // End:0x841
		case 49:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_2";
            // End:0xE8E
			break;
        // End:0x86B
		case 50:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_2";
            // End:0xE8E
			break;
        // End:0x895
		case 51:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_4";
            // End:0xE8E
			break;
        // End:0x8BF
		case 52:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_4";
            // End:0xE8E
			break;
        // End:0x8E9
		case 53:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_1";
            // End:0xE8E
			break;
        // End:0x913
		case 54:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_1";
            // End:0xE8E
			break;
        // End:0x93D
		case 55:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_1";
            // End:0xE8E
			break;
        // End:0x967
		case 56:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Brown_1";
            // End:0xE8E
			break;
        // End:0x991
		case 57:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Green_1";
            // End:0xE8E
			break;
        // End:0x9BA
		case 88:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_8";
            // End:0xE8E
			break;
        // End:0x9E3
		case 89:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_1";
            // End:0xE8E
			break;
        // End:0xA0C
		case 90:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_3";
            // End:0xE8E
			break;
        // End:0xA35
		case 91:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_3";
            // End:0xE8E
			break;
        // End:0xA5E
		case 92:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_2";
            // End:0xE8E
			break;
        // End:0xA87
		case 93:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_1";
            // End:0xE8E
			break;

		case 94:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_5";

			break;

		case 95:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_5";

			break;

		case 96:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_7";

			break;

		case 97:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_6";

			break;

		case 98:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_6";

			break;

		case 99:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_3";

			break;

		case 100:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_4";
            // End:0xE8E
			break;
        // End:0xBCF
		case 101:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_1";
            // End:0xE8E
			break;
        // End:0xBF8
		case 102:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_2";
            // End:0xE8E
			break;
        // End:0xC21
		case 103:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_5";
            // End:0xE8E
			break;
        // End:0xC4A
		case 104:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_7";
            // End:0xE8E
			break;
        // End:0xC73
		case 105:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_6";
            // End:0xE8E
			break;
        // End:0xC9C
		case 106:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_3";
            // End:0xE8E
			break;
        // End:0xCC5
		case 107:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_4";
            // End:0xE8E
			break;
        // End:0xCEE
		case 108:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_1";
            // End:0xE8E
			break;
        // End:0xD17
		case 109:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_2";
            // End:0xE8E
			break;
        // End:0xD40
		case 110:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_5";
            // End:0xE8E
			break;
        // End:0xD69
		case 111:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_7";
            // End:0xE8E
			break;
        // End:0xD92
		case 112:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_6";
            // End:0xE8E
			break;
        // End:0xDBB
		case 113:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_1";
            // End:0xE8E
			break;
        // End:0xDE4
		case 114:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_1";
            // End:0xE8E
			break;
        // End:0xE0D
		case 115:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_4";
            // End:0xE8E
			break;
        // End:0xE36
		case 116:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_4";
            // End:0xE8E
			break;
        // End:0xE5F
		case 117:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_1";
            // End:0xE8E
			break;
        // End:0xE88
		case 118:
			pasmua2a1 = "L2UI_CH3.StyleIcon_Blue_1";
            // End:0xE8E
			break;
        // End:0xFFFF
		default:
            // End:0xE8E
			break;
			break;
	}
	return pasmua2a1;

}

function xxlotus2k(string param, Color Color)
{
	class'UIAPI_TEXTLISTBOX'.static.AddString("SystemMsgWnd.SystemMsgList", param, Color);
	class'UIAPI_TEXTLISTBOX'.static.AddString("ChatWnd.NormalChat", param, Color);
	class'UIAPI_TEXTLISTBOX'.static.AddString("ChatWnd.PartyChat", param, Color);
	class'UIAPI_TEXTLISTBOX'.static.AddString("ChatWnd.ClanChat", param, Color);
	class'UIAPI_TEXTLISTBOX'.static.AddString("ChatWnd.TradeChat", param, Color);
	class'UIAPI_TEXTLISTBOX'.static.AddString("ChatWnd.AllyChat", param, Color);
	return;
}


function Color GetColortool (int R, int G, int B, int A)
{
	local Color tColor;

	tColor.R = R;
	tColor.G = G;
	tColor.B = B;
	tColor.A = A;
	return tColor;
}


function bool getkjksadju2113(int id)
{
	local bool chsadk23;

	chsadk23 = False;
	switch(id)
	{
        // End:0x17
		case 2039:
        // End:0x1F
		case 2150:
        // End:0x27
		case 2151:
        // End:0x2F
		case 2152:
        // End:0x37
		case 2153:
        // End:0x3F
		case 2154:
        // End:0x47
		case 2047:
        // End:0x4F
		case 2155:
        // End:0x57
		case 2156:
        // End:0x5F
		case 2157:
        // End:0x67
		case 2158:
        // End:0x6F
		case 2159:
        // End:0x77
		case 2061:
        // End:0x7F
		case 2160:
        // End:0x87
		case 2161:
        // End:0x8F
		case 2162:
        // End:0x97
		case 2163:
        // End:0x9F
		case 2164:
        // End:0xA7
		case 26060:
        // End:0xAF
		case 26061:
        // End:0xB7
		case 26062:
        // End:0xBF
		case 26063:
        // End:0xC7
		case 26064:
        // End:0xCF
		case 22036:
        // End:0xD7
		case 22037:
        // End:0xDF
		case 22038:
        // End:0xE7
		case 2033:
        // End:0xEF
		case 2008:
        // End:0xF7
		case 2009:
        // End:0xFF
		case 26050:
        // End:0x107
		case 26051:
        // End:0x10F
		case 26052:
        // End:0x117
		case 26053:
        // End:0x11F
		case 26054:
        // End:0x127
		case 26055:
        // End:0x12F
		case 26056:
        // End:0x137
		case 26057:
        // End:0x13F
		case 26058:
        // End:0x147
		case 26059:
        // End:0x14F
		case 22369:
        // End:0x157
		case 728:
        // End:0x15F
		case 2240:
        // End:0x167
		case 2498:
        // End:0x16F
		case 2499:
        // End:0x177
		case 2359:
        // End:0x17F
		case 2166:
        // End:0x187
		case 2034:
        // End:0x18F
		case 2037:
        // End:0x197
		case 2035:
        // End:0x19F
		case 2036:
        // End:0x1A7
		case 2011:
        // End:0x1AF
		case 2032:
        // End:0x1B7
		case 2864:
        // End:0x1BF
		case 2398:
        // End:0x1C7
		case 2402:
        // End:0x1CF
		case 2403:
        // End:0x1D7
		case 2395:
        // End:0x1DF
		case 2401:
        // End:0x1E7
		case 2169:
        // End:0x1EF
		case 2397:
        // End:0x1F7
		case 2396:
        // End:0x1FF
		case 2012:
        // End:0x207
		case 2074:
        // End:0x20F
		case 2077:
        // End:0x217
		case 2592:
        // End:0x21F
		case 2038:
        // End:0x227
		case 2627:
        // End:0x22F
		case 2289:
        // End:0x237
		case 2287:
        // End:0x23F
		case 2288:
        // End:0x247
		case 2169:
        // End:0x24F
		case 2076:
        // End:0x257
		case 22042:
        // End:0x25F
		case 2903:
        // End:0x267
		case 2901:
        // End:0x26F
		case 2900:
        // End:0x277
		case 2902:
        // End:0x27F
		case 2897:
        // End:0x287
		case 22029:
        // End:0x28F
		case 2899:
        // End:0x297
		case 22031:
        // End:0x29F
		case 22164:
        // End:0x2A7
		case 2898:
        // End:0x2AF
		case 22030:
        // End:0x2B7
		case 22163:
        // End:0x2BF
		case 22162:
        // End:0x2C7
		case 22158:
        // End:0x2CF
		case 2282:
        // End:0x2D7
		case 2283:
        // End:0x2DF
		case 2284:
        // End:0x2E7
		case 2514:
        // End:0x2EF
		case 2513:
        // End:0x2F7
		case 2244:
        // End:0x2FF
		case 2278:
        // End:0x307
		case 2485:
        // End:0x30F
		case 2247:
        // End:0x317
		case 2281:
        // End:0x31F
		case 2486:
        // End:0x327
		case 2245:
        // End:0x32F
		case 2279:
        // End:0x337
		case 2246:
        // End:0x33F
		case 2280:
        // End:0x347
		case 2285:
        // End:0x34F
		case 2512:
        // End:0x362
		case 2580:
			chsadk23 = True;
            // End:0x365
			break;
        // End:0xFFFF
		default:
			break;
	}
	return chsadk23;

}




function bool xxcalculateheadershot(WindowHandle zzHandle, optional int zztargetID, optional int zzoffsetX, optional int zzoffsetY, optional bool zzisDamage)
{
	local Vector zzCameraLocation;
	local Rotator zzCameraRotation;
	local Vector zzcameraDirection, zzcamerazzRight, zzcameraUp;
	local int zzScreenWidth, zzScreenHeight;
	local float zzFOV, zznear, zzfar, zzaspect, zztop, zzbottom,
	zzRight, zzLeft;

	local Matrix zzprojMat, zzviewMat, zzmvpMat;
	local Plane zzposHomog, zzposMvp;
	local UserInfo zzInfo;
	local Actor zzActor;
	local Pawn zzPawn;
	local LineagePlayerController zzController;
	local Vector zzHeadCoords;
	local float zzscreenX, zzscreenY, zzpercentX, zzpercentY, zzcalibrate, zzframeMultiply,
	zzManualOffset;

    // End:0x12
	if( !GetTargetInfo(zzInfo) )
	{
		return False;
	}
    // End:0x33
	if( (zzInfo.nID != zztargetID) && zzisDamage )
	{
		return False;
	}
    // End:0x45
	if( !GetPlayerActor(zzActor) )
	{
		return False;
	}
    // End:0x57
	if( !GetPlayerController(zzController) )
	{
		return False;
	}
    // End:0x70
	if( zzInfo.bNpc )
	{
		zzManualOffset = -3.5;
	}
	zzController.PlayerCalcView(zzActor, zzCameraLocation, zzCameraRotation);
	GetCurrentResolution(zzScreenWidth, zzScreenHeight);
	GetAxes(zzCameraRotation, zzcameraDirection, zzcamerazzRight, zzcameraUp);
    // End:0x151
	foreach zzActor.CollidingActors(Class'Pawn', zzPawn, 50, zzInfo.Loc)
	{
        // End:0x150
		if( zzInfo.nID == zzPawn.CreatureID )
		{
			zzHeadCoords = zzInfo.Loc;
			zzManualOffset = zzManualOffset + zzPawn.NameOffset;
			zzHeadCoords.Z = (zzHeadCoords.Z + zzPawn.CollisionHeight) + zzManualOffset;
		}
	}
	zzFOV = 60;
	zznear = 0.1;
	zzfar = 1000;
	zzframeMultiply = 1000;
	zzaspect = float(zzScreenWidth) / float(zzScreenHeight);
	zztop = Tan(zzFOV / float(2)) * zznear;
	zzbottom = -zztop;
	zzRight = zztop * zzaspect;
	zzLeft = -zzRight;
	zzprojMat.XPlane = GetPlane((2 * zznear) / (zzRight - zzLeft), 0, 0, 0);
	zzprojMat.YPlane = GetPlane(0, (2 * zznear) / (zztop - zzbottom), 0, 0);
	zzprojMat.ZPlane = GetPlane((zzRight + zzLeft) / (zzRight - zzLeft), (zztop + zzbottom) / (zztop - zzbottom), ((-1 * zzfar) - zznear) / (zzfar - zznear), -1);
	zzprojMat.WPlane = GetPlane(0, 0, ((-2 * zzfar) * zznear) / (zzfar - zznear), 0);
	zzviewMat.XPlane = GetPlane(zzcamerazzRight.X, zzcameraUp.X, -zzcameraDirection.X, 0);
	zzviewMat.YPlane = GetPlane(zzcamerazzRight.Y, zzcameraUp.Y, -zzcameraDirection.Y, 0);
	zzviewMat.ZPlane = GetPlane(zzcamerazzRight.Z, zzcameraUp.Z, -zzcameraDirection.Z, 0);
	zzviewMat.WPlane = GetPlane(-1 * (Dot (zzcamerazzRight, zzCameraLocation)), -1 * (Dot (zzcameraUp, zzCameraLocation)), Dot (zzcameraDirection, zzCameraLocation), 1);
	zzmvpMat = multiplyMatrices(zzprojMat, zzviewMat);
	zzposHomog = GetPlane(zzHeadCoords.X, zzHeadCoords.Y, zzHeadCoords.Z, 1);
	zzposMvp = multiplyMatrixVector(zzmvpMat, zzposHomog);
	zzposMvp.X = zzposMvp.X / (zzposMvp.W / zzframeMultiply);
	zzposMvp.Y = zzposMvp.Y / (zzposMvp.W / zzframeMultiply);
	zzposMvp.Z = zzposMvp.Z / (zzposMvp.W / zzframeMultiply);
	zzcalibrate = (27.5 * (float(zzScreenWidth) / float(zzScreenHeight))) / zzframeMultiply;
	zzpercentX = ((((zzposMvp.X * 0.5) * float(zzScreenWidth)) + (float(zzScreenWidth) / zzcalibrate)) / ((float(zzScreenWidth) / zzcalibrate) * float(2))) * 100;
	zzpercentY = ((((zzposMvp.Y * 0.5) * float(zzScreenHeight)) + (float(zzScreenHeight) / zzcalibrate)) / ((float(zzScreenHeight) / zzcalibrate) * float(2))) * 100;
	zzscreenX = ((100 - zzpercentX) * float(zzScreenWidth)) / 100;
	zzscreenY = (zzpercentY * float(zzScreenHeight)) / 100;
    // End:0x5F4
	if( ((zzHeadCoords - zzCameraLocation) Dot zzcameraDirection) < float(0) )
	{
		zzHandle.MoveTo(-100, -100);
		return False;
	}
    // End:0x637
	if( (zzscreenX < float(-100)) || zzscreenX > float(zzScreenWidth + 100) )
	{
		zzHandle.MoveTo(-100, -100);
		return False;
	}
    // End:0x67A
	if( (zzscreenY < float(-100)) || zzscreenY > float(zzScreenHeight + 100) )
	{
		zzHandle.MoveTo(-100, -100);
		return False;
	}
    // End:0x6CF
	if( zzisDamage )
	{
		zzHandle.MoveTo(int(zzscreenX - float(zzScreenWidth / 2)) + zzoffsetX, (int(zzscreenY - float(50)) - (zzScreenHeight / 2)) + zzoffsetY);
	}
	else
	{
		zzHandle.MoveTo(int(zzscreenX - float(40)), int(zzscreenY));
	}
	return True;

}


function Color GetItemNameWithoutTag (out string iName)
{
	local Color tmp;
	local int Color;


	if ( Mid(iName, Len(iName) - 3, 1) == "[" && Mid(iName, Len(iName) - 1, 1) == "]" )

	{
		Color = int(Mid(iName, Len(iName) - 2, 1));

		switch (Color)
		{
			case 1:
				tmp.R = 255;
				tmp.G = 0;
				tmp.B = 255;
				tmp.A = 255;
				break;
			case 2:
				tmp.R = 152;
				tmp.G = 83;
				tmp.B = 179;
				tmp.A = 230;
				break;
			case 3:
				tmp.R = 33;
				tmp.G = 164;
				tmp.B = 255;
				tmp.A = 255;
				break;
			case 4:
				tmp.R = 138;
				tmp.G = 255;
				tmp.B = 0;
				tmp.A = 255;
				break;
			case 5:
				tmp.R = 255;
				tmp.G = 251;
				tmp.B = 4;
				tmp.A = 255;
				break;
			case 6:
				tmp.R = 240;
				tmp.G = 68;
				tmp.B = 68;
				tmp.A = 255;
				break;
			default:
		}
		iName = Left(iName, Len(iName) - 3);

	}
	return tmp;
}



function array<string> xxtypesitem()
{
	local private array<string> zzpirama;

	zzpirama[zzpirama.Length] = "WeaponStage:";
	zzpirama[zzpirama.Length] = "WeaponStatus:";
	zzpirama[zzpirama.Length] = "Tier:";
	zzpirama[zzpirama.Length] = "ArmorStatus:";
	zzpirama[zzpirama.Length] = "JewelStage:";
	zzpirama[zzpirama.Length] = "Acquire:{";
	return zzpirama;

}

function int xxdescar(string zzpamras, string Description)
{
	local int zzdweaaas;
	local string zzdreasa, zzadwaewwa;

	zzdreasa = Description;
	zzdweaaas = InStr(zzdreasa, zzpamras);
    // End:0x77
	if( zzdweaaas != -1 )
	{
        // End:0x60
		if( zzpamras != "Acquire:{" )
		{
			zzadwaewwa = Mid(zzdreasa, zzdweaaas + Len(zzpamras), 1);            
		}
		else
		{
			return zzdweaaas + Len(zzpamras);
		}
		return int(zzadwaewwa);
	}

}


function string xxtierlist(string zzparam, string zzmikua)
{
	local private int zzinta, zzkula;

	zzkula = Len(zzmikua);
	zzinta = InStr(zzparam, zzmikua);
    // End:0x43
	if( zzinta > -1 )
	{
		return Mid(zzparam, zzinta + zzkula, 1);
	}
	return "";

}

function bool compareUco (int SlotBitType, out ItemWindowHandle hItemWnd)
{
	local ItemInfo ItemSlot;

	switch (SlotBitType)
	{
		case 2:
		case 4:
		case 6:
			if ( !xxGetItemWindowHandle("InventoryWnd.EquipItem_REar").GetItem(0,ItemSlot) )

   // if (comptid("InventoryWnd.EquipItem_REar", ItemSlot.Description) != 0)
			{
				hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_REar");
			} 
	
			else 
	
			{

				hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_LEar");
			}
			return True;
		case 16:
		case 32:
		case 48:
			if ( !xxGetItemWindowHandle("InventoryWnd.EquipItem_RFinger").GetItem(0,ItemSlot) )
 //   if (comptid("InventoryWnd.EquipItem_REar", ItemSlot.Description) != 0)
			{
				hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_RFinger");
			} 
	
			else 
	
			{
				hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_LFinger");
			}
			return True;
		case 8:
			hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_Neck");
			return True;
		case 64:
			hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_Head");
			return True;
		case 1024:
		case 32768:
			hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_Chest");
			return True;
		case 2048:
			hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_Legs");
			return True;
		case 512:
			hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_Gloves");
			return True;
		case 4096:
			hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_Feet");
			return True;
		case 256:
			hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_LHand");
			return True;
		case 16384:
		case 128:
			hItemWnd = xxGetItemWindowHandle("InventoryWnd.EquipItem_RHand");
			return True;
		default:
	}
	return False;
}


function string GetCCClassccIcons(int ClassIDCustom)
{
	local string tempString;

	tempString = "";
	switch (ClassIDCustom)
	{
		case 0:
			tempString = "ccIcons.skill0141";
			break;
		case 1:
			tempString = "ccIcons.skill0078";
			break;
		case 2:
			tempString = "ccIcons.skill0008";
			break;
		case 3:
			tempString = "ccIcons.skill0286";
			break;
		case 4:
			tempString = "ccIcons.skill0110";
			break;
		case 5:
			tempString = "ccIcons.skill0406";
			break;
		case 6:
			tempString = "ccIcons.skill0283";
			break;
		case 7:
			tempString = "ccIcons.skill0111";
			break;
		case 8:
			tempString = "ccIcons.skill0263";
			break;
		case 9:
			tempString = "ccIcons.skill0313";
			break;
		case 10:
			tempString = "ccIcons.skill0146";
			break;
		case 11:
			tempString = "ccIcons.skill1220";
			break;
		case 12:
			tempString = "ccIcons.skill1289";
			break;
		case 13:
			tempString = "ccIcons.skill1263";
			break;
		case 14:
			tempString = "ccIcons.skill1331";
			break;
		case 15:
			tempString = "ccIcons.skill1016";
			break;
		case 16:
			tempString = "ccIcons.skill1307";
			break;
		case 17:
			tempString = "ccIcons.skill1062";
			break;
		case 18:
			tempString = "ccIcons.skill0141";
			break;
		case 19:
			tempString = "ccIcons.skill0110";
			break;
		case 20:
			tempString = "ccIcons.skill0067";
			break;
		case 21:
			tempString = "ccIcons.skill0098";
			break;
		case 22:
			tempString = "ccIcons.skill0111";
			break;
		case 23:
			tempString = "ccIcons.skill0321";
			break;
		case 24:
			tempString = "ccIcons.skill0416";
			break;
		case 25:
			tempString = "ccIcons.skill0146";
			break;
		case 26:
			tempString = "ccIcons.skill1175";
			break;
		case 27:
			tempString = "ccIcons.skill1290";
			break;
		case 28:
			tempString = "ccIcons.skill1332";
			break;
		case 29:
			tempString = "ccIcons.skill1013";
			break;
		case 30:
			tempString = "ccIcons.skill1430";
			break;
		case 31:
			tempString = "ccIcons.skill0141";
			break;
		case 32:
			tempString = "ccIcons.skill0110";
			break;
		case 33:
			tempString = "ccIcons.skill0022";
			break;
		case 34:
			tempString = "ccIcons.skill0408";
			break;
		case 35:
			tempString = "ccIcons.skill0111";
			break;
		case 36:
			tempString = "ccIcons.skill0321";
			break;
		case 37:
			tempString = "ccIcons.skill0314";
			break;
		case 38:
			tempString = "ccIcons.skill0141";
			break;
		case 39:
			tempString = "ccIcons.skill1178";
			break;
		case 40:
			tempString = "ccIcons.skill1291";
			break;
		case 41:
			tempString = "ccIcons.skill1333";
			break;
		case 42:
			tempString = "ccIcons.skill1059";
			break;
		case 43:
			tempString = "ccIcons.skill1430";
			break;
		case 44:
			tempString = "ccIcons.skill0146";
			break;
		case 45:
			tempString = "ccIcons.skill0176";
			break;
		case 46:
			tempString = "ccIcons.skill0176";
			break;
		case 47:
			tempString = "ccIcons.skill0050";
			break;
		case 48:
			tempString = "ccIcons.skill0222";
			break;
		case 49:
			tempString = "ccIcons.skill0141";
			break;
		case 50:
			tempString = "ccIcons.skill1090";
			break;
		case 51:
			tempString = "ccIcons.skill1283";
			break;
		case 52:
			tempString = "ccIcons.skill1001";
			break;
		case 53:
			tempString = "ccIcons.skill0146";
			break;
		case 54:
			tempString = "ccIcons.skill0254";
			break;
		case 55:
			tempString = "ccIcons.skill0302";
			break;
		case 56:
			tempString = "ccIcons.skill0025";
			break;
		case 57:
			tempString = "ccIcons.skill0301";
			break;
		case 88:
			tempString = "ccIcons.skill0442";
			break;
		case 89:
			tempString = "ccIcons.skill0361";
			break;
		case 90:
			tempString = "ccIcons.skill0341";
			break;
		case 91:
			tempString = "ccIcons.skill0342";
			break;
		case 92:
			tempString = "ccIcons.skill0131";
			break;
		case 93:
			tempString = "ccIcons.skill0445";
			break;
		case 94:
			tempString = "ccIcons.skill1339";
			break;
		case 95:
			tempString = "ccIcons.skill1343";
			break;
		case 96:
			tempString = "ccIcons.skill1406";
			break;
		case 97:
			tempString = "ccIcons.skill1335";
			break;
		case 98:
			tempString = "ccIcons.skill1356";
			break;
		case 99:
			tempString = "ccIcons.skill0341";
			break;
		case 100:
			tempString = "ccIcons.skill0437";
			break;
		case 101:
			tempString = "ccIcons.skill0355";
			break;
		case 102:
			tempString = "ccIcons.skill0413";
			break;
		case 103:
			tempString = "ccIcons.skill1342";
			break;
		case 104:
			tempString = "ccIcons.skill1407";
			break;
		case 105:
			tempString = "ccIcons.skill1355";
			break;
		case 106:
			tempString = "ccIcons.skill0342";
			break;
		case 107:
			tempString = "ccIcons.skill0367";
			break;
		case 108:
			tempString = "ccIcons.skill0355";
			break;
		case 109:
			tempString = "ccIcons.skill0414";
			break;
		case 110:
			tempString = "ccIcons.skill1341";
			break;
		case 111:
			tempString = "ccIcons.skill1408";
			break;
		case 112:
			tempString = "ccIcons.skill1357";
			break;
		case 113:
			tempString = "ccIcons.skill0094";
			break;
		case 114:
			tempString = "ccIcons.skill0443";
			break;
		case 115:
			tempString = "ccIcons.skill1416";
			break;
		case 116:
			tempString = "ccIcons.skill1413";
			break;
		case 117:
			tempString = "ccIcons.skill0348";
			break;
		case 118:
			tempString = "ccIcons.skill0013";
			break;
		default:
	}
	return tempString;
}





function bool FindItemByServerID (int ServerID, out ItemInfo item)
{
	local int i;
	local int pos;
	local ItemWindowHandle InvWnd;
	local InventoryWnd script;

	script = InventoryWnd(GetScript("InventoryWnd"));
	pos = script.m_invenItem.FindItemWithServerID(ServerID);
	if ( pos > -1 )
	{
		InvWnd = script.m_invenItem;
	}
	if ( pos < 0 )
	{
		i = 0;
		if ( i < 15 )
		{
			pos = script.zzm_equipItem[i].FindItemWithServerID(ServerID);
			if ( pos > -1 )
			{
				InvWnd = script.zzm_equipItem[i];
			} 
	  
	
			else 
	    
			{
				i++;

			}
		}
	}
	if ( InvWnd.GetItem(pos,item) )
	{
		return True;
	}
	return False;
}



function string Replace (string Text, string Replace, string With)
{
	local int i;
	local string Input;

	Input = Text;
	Text = "";
	i = InStr(Input,Replace);
	if ( i != -1 )
	{
		Text = (Text$Left(Input,i)$With);
		Input = Mid(Input, Len(Input) + i);
		i = InStr(Input,Replace);

	}
	return Text$Input;
}



static final function string xxloia(coerce string zzsdawea, coerce string zzdzsdwea, coerce string zzdwea2a)
{
	local int zzdweaaaq;
	local string zzweaaasa21;

	zzdweaaaq = InStr(zzsdawea, zzdzsdwea);
J0x12:

    // End:0x71 [Loop If]
	if( zzdweaaaq != -1 )
	{
		zzweaaasa21 = (zzweaaasa21$Left(zzsdawea, zzdweaaaq))$zzdwea2a;
		zzsdawea = Mid(zzsdawea, zzdweaaaq + Len(zzdzsdwea));
		zzdweaaaq = InStr(zzsdawea, zzdzsdwea);
        // [Loop Continue]
		goto J0x12;
	}
	zzweaaasa21 = zzweaaasa21$zzsdawea;
	return zzweaaasa21;

}


function bool xxlistkua2(out string zzarrid)
{
	local private array<string> zzsdwaa;
	local private int zzdswae, zzdweaa;
	local private bool bShow;

	zzsdwaa = xxtypesitem();
	zzdswae = 0;
J0x13:

    // End:0xDD [Loop If]
	if( zzdswae < zzsdwaa.Length )
	{
		zzdweaa = InStr(zzarrid, zzsdwaa[zzdswae]);
        // End:0x4D
		if( zzdweaa == -1 )
		{
            // [Explicit Continue]
			goto J0xD3;
		}
        // End:0x9B
		if( Right(zzsdwaa[zzdswae], 1) == "{" )
		{
			zzarrid = xxloia(zzarrid, Mid(zzarrid, zzdweaa, InStr(zzarrid, "}") + 3), "");
			bShow = False;
            // [Explicit Continue]
			goto J0xD3;
		}
		zzarrid = xxloia(zzarrid, Mid(zzarrid, zzdweaa, Len(zzsdwaa[zzdswae]) + 3), "");
		bShow = True;
	J0xD3:

		zzdswae++;
        // [Loop Continue]
		goto J0x13;
	}
	return bShow;

}




function xxnotinaca(string param)
{
	local string monim;

	ParamAdd(monim, "MsgType", string(1));
	ParamAdd(monim, "MsgNo", string(0));
	ParamAdd(monim, "WindowType", string(2));
	ParamAdd(monim, "FontSize", "20");
	ParamAdd(monim, "FontType", string(0));
	ParamAdd(monim, "MsgColor", "1");
	ParamAdd(monim, "MsgColorR", string(255));
	ParamAdd(monim, "MsgColorG", string(255));
	ParamAdd(monim, "MsgColorB", string(255));
	ParamAdd(monim, "ShadowType", "0");
	ParamAdd(monim, "BackgroundType", "0");
	ParamAdd(monim, "LifeTime", string(2500));
	ParamAdd(monim, "AnimationType", "1");
	ParamAdd(monim, "Msg", param);
	ExecuteEvent(140, monim);
	return;
}



function xxkeybindshortcut()
{
	local bool isanswer;

	isanswer = GetOptionBool("Game", "EnterChatting");
    // End:0x24A
	if( isanswer )
	{
		class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndHorizontal.keybinds", "L2UI_CH3.KeyBind.keybindF1F2");
		class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndVertical.keybinds_v", "L2UI_CH3.KeyBind.keybindF1F2_v");
		class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndHorizontal_1.keybinds", "L2UI_CH3.KeyBind.keybind12");
		class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndHorizontal_2.keybinds", "L2UI_CH3.KeyBind.keybindQW");
		class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndVertical_1.keybinds_v", "L2UI_CH3.KeyBind.keybind12_v");
		class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndVertical_2.keybinds_v", "L2UI_CH3.KeyBind.keybindQW_v");
	}
	else
	{
		class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndHorizontal.keybinds", "L2UI_CH3.KeyBind.keybindF1F2");
		class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndVertical.keybinds_v", "L2UI_CH3.KeyBind.keybindF1F2_v");
		class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndHorizontal_1.keybinds", "L2UI_CH3.Null");
		class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndHorizontal_2.keybinds", "L2UI_CH3.Null");
		class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndVertical_1.keybinds_v", "L2UI_CH3.Null");
		class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndVertical_2.keybinds_v", "L2UI_CH3.Null");
	}
	return;
}




// M??todo Replace para reemplazar todas las ocurrencias de 'search' con 'replace' en 'inputStr'
function string Replace2da(string inputStr, string search, string replace)
{
	local int index;

    // Buscar la primera ocurrencia de 'search'
	index = InStr(inputStr, search);

    // Reemplazar todas las ocurrencias mientras se encuentren
	while ( index != -1 )
	{
        // Reemplazar la ocurrencia actual
		inputStr = Left(inputStr, index - 1)$replace$Mid(inputStr, index + Len(search));

        // Buscar la siguiente ocurrencia de 'search'
		index = InStr(inputStr, search);
	}

    // Devolver la cadena modificada
	return inputStr;
}



function texCount(out ItemInfo Info)
{
	local int Count;
	Count = Info.ItemNum;

	if ( (Count > 99) )
	{
		Info.ForeTexture = "L2UI_CH3.ItemCount.texCount99+";
	}
	else
	{
		if ( (Count > 1) )
		{
			Info.ForeTexture = ("L2UI_CH3.ItemCount.texCount"$string(Count));
		}
		else
		{
			Info.ForeTexture = "L2UI_CH3.null";
		}
	}
}

function string TreeInsertItemTooltipSimpleNode (string TreeName, string NodeName, string ParentName, int nTexExpandedOffSetX, int nTexExpandedOffSetY, int nTexExpandedHeight, int nTexExpandedRightWidth, int nTexExpandedLeftUWidth, int nTexExpandedLeftUHeight, optional string TooltipSimpleText, optional string strTexExpandedLeft, optional int offsetX, optional int offsetY)
{
	local XMLTreeNodeInfo infNode;

	if ( TooltipSimpleText != "" )
	{
		infNode.ToolTip = xxMakeTooltipSimpleText(TooltipSimpleText);
	}
	if ( strTexExpandedLeft == "" )
	{
		strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
	}
	infNode.strName = NodeName;
	infNode.nOffSetX = offsetX;
	infNode.nOffSetY = offsetY;
	infNode.bFollowCursor = True;
	infNode.nTexExpandedOffSetX = nTexExpandedOffSetX;
	infNode.nTexExpandedOffSetY = nTexExpandedOffSetY;
	infNode.nTexExpandedHeight = nTexExpandedHeight;
	infNode.nTexExpandedRightWidth = nTexExpandedRightWidth;
	infNode.nTexExpandedLeftUWidth = nTexExpandedLeftUWidth;
	infNode.nTexExpandedLeftUHeight = nTexExpandedLeftUHeight;
	infNode.strTexExpandedLeft = strTexExpandedLeft;
	return Class'UIAPI_TREECTRL'.static.InsertNode(TreeName,ParentName,infNode);
}



















function bool function200(ItemWindowHandle me, string saaa, out ItemInfo info)
{
	local int i, j;

	i = me.GetItemNum();
	j = 0;
J0x1C:

    // End:0x67 [Loop If]
	if( j <= i )
	{
        // End:0x5D
		if( me.GetItem(j, info) )
		{
            // End:0x5D
			if( info.Name == saaa )
			{
				return True;
			}
		}
		j++;
        // [Loop Continue]
		goto J0x1C;
	}
	return False;

}





function EditBoxHandle xxGetEditBoxHandle (string WindowName)
{
	local EditBoxHandle Handle;

	Handle = EditBoxHandle(GetHandle(WindowName));
	return Handle;
}

function TabHandle xxGetTabHandle(string WindowName)
{
	local TabHandle Handle;

	Handle = TabHandle(GetHandle(WindowName));
	return Handle;
}

function ItemInfo SetItemTooltip(int Index)
{
	local ItemInfo outItem;

	class'UIDATA_ITEM'.static.GetItemInfo(Index, outItem);
	return outItem;
}




function TreeInsertTextNodeItem (string TreeName, string NodeName, string ItemName, optional int offsetX, optional int offsetY, optional int E, optional bool OneLine, optional bool bLineBreak, optional int reserved, optional int reserved2)
{
	local XMLTreeNodeItemInfo infNodeItem; //DC2

	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = ItemName;
	infNodeItem.t_bDrawOneLine = OneLine;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = offsetX;
	infNodeItem.nOffSetY = offsetY;
	infNodeItem = setTreeTextColor( E, infNodeItem );
	class'UIAPI_TREECTRL'.static.InsertNodeItem(TreeName,NodeName,infNodeItem);
}

function xDPatch (string Msg)
{
	local ChatWindowHandle NormalChat;
	local Color Color;

	NormalChat = ChatWindowHandle(GetHandle("ChatWnd.NormalChat"));
	Color.R = 153;
	Color.G = 51;
	Color.B = 0;
	Color.A = 255;
	NormalChat.AddString("xDPatch: "$Msg, Color);
}

function int findMatchString(string targetStr, string a_Param)
{
	local array<string> modifiedParamArr;
	local int i;
	local string delim;
	local string modifiedString;
	local int _inStr;
	local string strTemp1;
	local string strTemp2;

	modifiedString = targetStr;
	delim = " ";
	_inStr = InStr(a_Param, delim);
	if ( _inStr > -1 )
	{
		modifiedParamArr[modifiedParamArr.Length] = Left(a_Param, _inStr);
		a_Param = Mid(a_Param, _inStr + 1);
		_inStr = InStr(a_Param, delim);
	}
	modifiedParamArr[modifiedParamArr.Length] = a_Param;
	i = 0;
	while ( i < modifiedParamArr.Length )
	{
		strTemp1 = Caps(modifiedString);
		strTemp2 = Caps(modifiedParamArr[i]);
		if ( InStr(strTemp1, strTemp2) == -1 && modifiedParamArr[i] != " " )
		{
			return -1;
		}
		i++;
	}
	return 1;
}



static final function string ReplaceText (coerce string text, coerce string Replace, coerce string With)
{
	local int i;
	local string Output;

	i = InStr(text,Replace);
JL0012:
	if ( i != -1 )
	{
		Output = Output$Left(text,i)$With;
		text = Mid(text,i + Len(Replace));
		i = InStr(text,Replace);
		goto JL0012;
	}
	Output = Output$text;
	return Output;
}





function string setTooltipNameItem(string strIndex)
{
	local array< string> writeStr;
	local int i;

	writeStr = getItemRarity();
	i = 0;
J0x13:
	if( i < writeStr.Length )
	{
		if( InStr(strIndex, writeStr[i]) > 0 )
		{
			return Left(strIndex, InStr(strIndex, writeStr[i]));
		}
		i++;
		goto J0x13;
	}
	return strIndex;
}




function DrawItemInfo xxDrawText(string Text, Color c_Color, bool bDrawOneLine, bool bLineBreak, int nOffSetX, int nOffSetY)
{
	local DrawItemInfo Info;

	Info.eType = DIT_TEXT;
	Info.t_color = c_Color;
	Info.t_bDrawOneLine = bDrawOneLine;
	Info.bLineBreak = bLineBreak;
	Info.nOffSetX = nOffSetX;
	Info.nOffSetY = nOffSetY;
	Info.t_strText = Text;
	return Info;
}


function int GetTextWidth(string val)
{
	local int ent1;
	local int ent2;

	GetTextSize(val, ent1, ent2);
	return ent1;
}

function string GetItemGradeTextureName (int item)
{
	if ( item > 0 )
	{
		return ("L2UI_CH3.grade_"$string(item));
	} 
	else 
	{
		return "";
	}
}

function string makeShortStringByPixel (string targetString, int maxPixel, string dotString)
{
	local string fixedText;
	local string tempStr;
	local int textWidth;
	local int textHeight;
	local int dotWidth;
	local int dotHeight;
	local int i;

	GetTextSize(dotString,dotWidth,dotHeight);
	GetTextSize(targetString,textWidth,textHeight);
	if ( textWidth <= maxPixel )
	{
		fixedText = targetString;
	} 
	else 
	{
		fixedText = targetString;
		i = 0;
		if ( (i < Len(targetString)) )
		{
			tempStr = Mid(targetString,0,i);
			GetTextSize(tempStr,textWidth,textHeight);
			if ( (maxPixel < (textWidth + dotWidth)) )
			{
				fixedText = (tempStr$dotString);
			} 
	
			else 
	
			{
				i++;

			}
		}
	}
	return fixedText;
}

function TreeInsertTextureNode(string TreeName, string NodeName, string TextureName, int TextureWidth, int TextureHeight, optional int offsetX, optional int offsetY, optional bool bOutline, optional bool bBreakLine, optional int uTextureWidth, optional int uTextureHeight, optional string strMouseOver)
{
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.t_bDrawOneLine = bOutline;
	infNodeItem.bLineBreak = bBreakLine;
	infNodeItem.nOffSetX = offsetX;
	infNodeItem.nOffSetY = offsetY;
	infNodeItem.u_nTextureWidth = TextureWidth;
	infNodeItem.u_nTextureHeight = TextureHeight;
	infNodeItem.u_nTextureUWidth = uTextureWidth;
	infNodeItem.u_nTextureUHeight = uTextureHeight;
	infNodeItem.u_strTexture = TextureName;
	if( strMouseOver != "" )
	{
		infNodeItem.u_strTextureMouseOn = strMouseOver;
	}
	insNodeItem(TreeName, NodeName, infNodeItem);
}

function string GetItemNameAll (ItemInfo Info)
{
	local string FullName;
	local string addStr;

	if ( (Info.Enchanted > 0) )
	{
		FullName = ("+"$string(Info.Enchanted));
	}
	if ( (Len(FullName) > 0) )
	{
		FullName = ((FullName$" ")$Info.Name);
	} 
	else 
	{
		FullName = Info.Name;
	}
	if ( (Len(Info.AdditionalName) > 0) )
	{
		addStr = ((addStr$" ")$Info.AdditionalName);
	}
	FullName = (FullName$addStr);
	return FullName;
}



function array<string> getItemRarity()
{
	local array< string> writeStr;

	writeStr[writeStr.Length] = " - Common";
	writeStr[writeStr.Length] = " - Uncommon";
	writeStr[writeStr.Length] = " - Rare";
	writeStr[writeStr.Length] = " - Epic";
	writeStr[writeStr.Length] = " - Legendary";
	writeStr[writeStr.Length] = " - Supreme";

	return writeStr;
}

function int setTooltipNameColor(string strIndex)
{
	local array< string> writeStr;
	local int i;

	writeStr = getItemRarity();
	i = 0;
J0x13:
	if( i < writeStr.Length )
	{
		if( InStr(strIndex, writeStr[i]) > 0 )
		{
			return i;
		}
		i++;
		goto J0x13;
	}
	return -1;
}


function texCountNoStack (out ItemInfo Info)
{
	local int ItemNum;

	ItemNum = FindNoStackableItem(Info.ClassID);
	if ( (ItemNum > 1) )
	{
		if ( (ItemNum > 99) )
		{
			Info.ForeTexture = "L2UI_CH3.ItemCount.texCount99+";
		} 


		else 
	  
		{
			Info.ForeTexture = ("L2UI_CH3.ItemCount.texCount"$string(ItemNum));
		}
	}
}



function array<string> xxlista23(string val, string val2)
{
	local array<string> listastring;
	local int startPos;

	local string remaining;

	listastring.Length = 0;
	remaining = val;

	while ( remaining != "" )
	{

		startPos = InStr(remaining, val2);

		if ( startPos == -1 )
		{

			listastring[listastring.Length] = remaining;
			remaining = "";
		}
		else
		{

			listastring[listastring.Length] = Left(remaining, startPos);

			remaining = Mid(remaining, startPos + Len(val2));
		}
	}

	return listastring;
}

function SetItemTextLink (ItemInfo a_ID)
{
	local ChatWnd scriptChat;
	local string param;

	scriptChat = ChatWnd(GetScript("ChatWnd"));
	param = a_ID.Name;
	if ( (a_ID.Enchanted > 0) )
	{
		param = (((" +"$string(a_ID.Enchanted))$" ")$a_ID.Name);
	}
	if ( (a_ID.ItemNum > 1) )
	{
		param = (((a_ID.Name$"[")$string(a_ID.ItemNum))$"]");
	}
	scriptChat.HandleTextLinkLButtonClick(param);
}

function int FindNoStackableItem (int ClassID)
{
	local int i;
	local int itemCount;
	local int invenLimit;
	local ItemInfo item;
	local ItemWindowHandle InvWnd;

	InvWnd = ItemWindowHandle(GetHandle("InventoryWnd.InventoryItem"));
	invenLimit = InvWnd.GetItemNum();
	itemCount = 0;
	i = 0;
	if ( i < invenLimit )
	{
		InvWnd.GetItem(i,item);
		if ( item.ClassID == ClassID )
		{
			itemCount++;
		}
		i++;

	}
	return itemCount;
}


function string GetDetailedClassIconName (int ClassID, int iconType)
{
	local string iconSize;

	iconSize = "";
	if ( (iconType == 1) )
	{
		iconSize = "_Big";
	}
	if ( (iconType == 2) )
	{
		iconSize = "_Small";
	}
	switch (ClassID)
	{
		case 0:
		case 10:
			return ("L2UI_CH3.ClassMark.PlayerStatusWnd_ClassMark_human"$iconSize);
			break;
		case 18:
		case 25:
			return ("L2UI_CH3.ClassMark.PlayerStatusWnd_ClassMark_elf"$iconSize);
			break;
		case 31:
		case 38:
			return ("L2UI_CH3.ClassMark.PlayerStatusWnd_ClassMark_darkelf"$iconSize);
			break;
		case 44:
		case 49:
			return ("L2UI_CH3.ClassMark.PlayerStatusWnd_ClassMark_orc"$iconSize);
			break;
		case 53:
			return ("L2UI_CH3.ClassMark.PlayerStatusWnd_ClassMark_dwarf"$iconSize);
			break;
		default:
			return (("L2UI_CH3.ClassMark.PlayerStatusWnd_ClassMark_"$string(ClassID))$iconSize);
			break;
	}
}

function xxnotifyserverespecial(string zzsass)
{

	local SuperNotifWnd zznotif;
	local L2Util zzutilbar;
	local int zzancho;
	local int zzlargo;
	zzutilbar = L2Util(GetScript("L2Util"));
    GetINIInt("PatchSettings", "VentanaAnuncioWitdh", zzlargo, "PatchSettings");
    GetINIInt("PatchSettings", "VentanaAnuncioHeigh", zzancho, "PatchSettings");
		            // End:0x9D
	if( !Class'UIAPI_CHECKBOX'.static.IsChecked("OptionWnd.SuperNotific") )
	{
		return;
	}

	zznotif = SuperNotifWnd(GetScript("SuperNotifWnd"));
	zznotif.setNotification(zzlargo, zzancho, 7700, zzsass, zzutilbar.xxgetAD(), "htmlBtns.f_mp_reduce", xxgetInstanceL2Util().Red, xxgetInstanceL2Util().BrightWhite);
	return;
}





function CustomTooltip MakeTooltipSimpleText(string Text)
{
	local CustomTooltip Tooltip;
	local DrawItemInfo info;
	
	Tooltip.DrawList.Length = 1;
	info.eType = DIT_TEXT;
	info.t_bDrawOneLine = True;
	info.t_strText = Text;
	Tooltip.DrawList[0] = info;

	return Tooltip;
}
defaultproperties
{
}
