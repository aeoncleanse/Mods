-------------------------------------------------------------------------
--                                                                     --
-- Hook into File : /lua/ui/game/commandmode.lua                       --
-- Author         : Magic Power                                        --
--                                                                     --
-- Summary  : Spreads the attack orders for each unit in the selection --
--                                                                     --
-------------------------------------------------------------------------

do
	local oldCreateUI = CreateUI

	function CreateUI(isReplay)
	    oldCreateUI(isReplay)
	    import('/lua/spreadattack.lua').Init()
	end
end
