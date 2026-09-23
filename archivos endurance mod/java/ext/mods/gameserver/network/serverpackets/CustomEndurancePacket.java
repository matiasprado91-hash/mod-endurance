package ext.mods.gameserver.network.serverpackets;

public class CustomEndurancePacket extends L2GameServerPacket
{
	private static final int OPCODE_TUTORIAL_SHOW_HTML = 0xA0;
	private static final String HEADER = "ENDURANCE_UPDATE";

	private final int _objectId;
	private final int _endurance;

	public CustomEndurancePacket(int objectId, int endurance)
	{
		_objectId = objectId;
		_endurance = endurance;
	}

	@Override
	protected void writeImpl()
	{
		writeC(OPCODE_TUTORIAL_SHOW_HTML);
		writeS(HEADER + "|ObjectID=" + _objectId + "|Endurance=" + _endurance);
	}
}
