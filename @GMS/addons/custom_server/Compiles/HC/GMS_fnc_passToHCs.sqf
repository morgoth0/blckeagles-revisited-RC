
//diag_log format["_fnc_passToHCs:: function called at server time %1",diag_tickTime];
private["_numTransfered","_clientId","_allGroups","_groupsOwned","_idHC","_id","_swap","_rc"];
blck_connectedHCs = call blck_fnc_HC_getListConnected;
diag_log format["_fnc_passToHCs:: blck_connectedHCs = %1 | count _HCs = %2 | server FPS = %3",blck_connectedHCs,count blck_connectedHCs,diag_fps];
if ( (count blck_connectedHCs) > 0) then
{
	_idHC = [blck_connectedHCs] call blck_fnc_HC_leastBurdened;
	diag_log format["passToHCs: evaluating passTos for HC %1 || owner HC = %2",_idHC, owner _idHC];
	{
		// Pass the AI
		_numTransfered = 0;
		if (_x getVariable["blck_group",false]) then 
		{
			if ((leader _x) != vehicle (leader _x)) then
			{
				private _v = vehicle (leader _x);
				blck_monitoredVehicles = blck_monitoredVehicles - [_v];
				blck_HC_monitoredVehicles pushBack _v;
			};
			//diag_log format["group belongs to blckeagls mission system so time to transfer it"];
			if ((typeName _x) isEqualTo "GROUP") then
			{
				_id = groupOwner _x;
				//diag_log format["Owner of group %1 is %2",_x,_id];
				if (_id > 2) then 
				{
					//diag_log format["group %1 is already assigned to an HC with _id of %2",_x,_id];
					_swap = false;
				} else {
					//diag_log format["group %1 should be moved to HC %2 with _idHC %3",_x,_idHC];
					_x setVariable["owner",owner _idHC];				
					_rc = _x setGroupOwner (owner _idHC);
					[_x] remoteExec["blck_fnc_HC_XferGroup",_idHC];
					if ( _rc ) then 
					{
						_numTransfered = _numTransfered + 1;
						//diag_log format["group %1 transferred to %2",_x, groupOwner _x];
					} else {
						//diag_log format["something went wrong with the transfer of group %1",_x];
					};
				};
			};
		} else {
			//diag_log format["group %1 does not belong to blckeagls mission system",_x];
		};
	} forEach (allGroups);
	//diag_log format["_passToHCs:: %1 groups transferred to HC %2",_numTransfered,_idHC];
	_numTransfered = 0;
	// Note : the owner of a vehicle is the owner of the driver so vehicles are automatically transferred to the HC when the group to which the driver is assigned is transferred.

} else {
	#ifdef blck_debugMode
	if (blck_debugLevel > 2) then {diag_log "_fnc_passToHCs:: No headless clients connected"};
	#endif
};
