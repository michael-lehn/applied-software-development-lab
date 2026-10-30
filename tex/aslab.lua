-- aslab.lua -- helper functions for aslab.cls
-- Copyright (c) Michael Lehn. Licensed under CC BY-SA 4.0.

aslab = aslab or {}

local HLIST = node.id("hlist")
local VLIST = node.id("vlist")
local RULE  = node.id("rule")
local GLUE  = node.id("glue")
local KERN  = node.id("kern")

-- Distance (in sp) from the top of box register n to the baseline of the
-- first line (hbox or rule) it contains.  Glue is taken at its natural
-- size, which is what a box packed to its natural height uses.
function aslab.firstbaseline(n)
  local box = tex.box[n]
  if not box then return 0 end
  local acc = 0
  for item in node.traverse(box.list) do
    local id = item.id
    if id == HLIST or id == VLIST or id == RULE then
      return acc + item.height
    elseif id == GLUE then
      acc = acc + item.width
    elseif id == KERN then
      acc = acc + item.kern
    end
  end
  return 0
end
