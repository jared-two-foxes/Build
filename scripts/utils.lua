

local path = require 'pl.path'

local utils = {}

local function endsWith(s, suffix)
  return #s >= #suffix and s:find(suffix, #s - #suffix + 1, true)
end

local function splitPathName(path)
  local nameStart, _, name = path:find('([^/\\]+)[/\\]?$')
  local dir = path:sub(0, nameStart - 2)
  return dir, name
end                                  

local function splitExt(path)
  local extStart, _, ext = path:find('[^/\\.][.]([^/\\.]*)$')
  if extStart ~= nil then
    local name = path:sub(0, extStart)
    return name, ext
  else
    return path, nil
  end
end

function utils.unpackLibPlatformInfo( libsRootPath, libPlatformInfo )
  local rootPath, projectPath, buildEngine, libNameRelease, libNameDebug = unpack( libPlatformInfo )

  if rootPath ~= nil and not path.isabs( rootPath ) then 
    rootPath = libsRootPath .. '/' .. rootPath 
  end

  if projectPath ~= nil and not path.isabs( projectPath ) then 
    projectPath = libsRootPath .. '/' .. projectPath 
  end
  
  if includePath ~= nil then
    -- could be a list of objects, split on ';', and recombine
    parts = string.explode( includePath, ';' ) 
    includePath = ""
    for _,v in pairs(parts) do
      if not path.isabs( v ) then 
        v = libsRootPath .. '/' .. v
      end
      includePath = includePath .. v .. ';'
    end
  end
  
  if libPath ~= nil and not path.isabs( libPath ) then 
    libPath = libsRootPath .. '/' .. libPath 
  end

  return rootPath, projectPath, buildEngine, libNameRelease, libNameDebug
end


return utils