-- ML_Icon_Colorer_Support
-- Author: yiboy
-- DateCreated: 9/28/2024 12:59:14 AM
--------------------------------------------------------------

function TableIncludeValue(ttable, vvalue)
	for k, v in pairs(ttable) do
		if v == vvalue then 
			return true;
		end
	end
	return false;
end
-- ===========================================================================
function FindKeyForCertainValue(ttable, vvalue)
	for k, v in pairs(ttable) do
		if v == vvalue then 
			return k
		end
	end
end
-- ===========================================================================
function ChangeRGBAToHex(n)
    local t = {}
    for i=7,0,-1 do
        t[#t+1] = math.floor(n / 2^i)
        n = n % 2^i
    end
    return table.concat(t)
end
-- ===========================================================================
