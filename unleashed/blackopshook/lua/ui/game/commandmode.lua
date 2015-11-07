--------------------------------------------------------------------
--                                                                --
-- Hook into File : /lua/ui/game/commandmode.lua                  --
-- Author         : Magic Power                                   --
--                                                                --
-- Summary  : Makes a shadow copy of a subset of all given orders --
--                                                                --
--------------------------------------------------------------------

do
  local oldOnCommandIssued = OnCommandIssued

  function OnCommandIssued(command)
    oldOnCommandIssued(command)
    import('/lua/spreadattack.lua').MakeShadowCopyOrders(command)
  end
end
