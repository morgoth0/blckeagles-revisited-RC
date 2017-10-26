//////////////////////////////////////////////////////
// Returns an array of all players on the server
/*

	By Ghostrider-DBD-
	Copyright 2016
	Last Modified 8/16/17
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
/////////////////////////////////////////////////////

private ["_result"];

_result = [];
{
	if (isPlayer _x && alive _x) then { _result pushback _x };
} forEach playableUnits;

//_result = allPlayers;

_result