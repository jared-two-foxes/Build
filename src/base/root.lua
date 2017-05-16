--
-- Build System root file.
-- v0.0.1
--

-----------------------------------------------------------------------------------------------------------------------------------------------------

local buildProjDir = 'C:/Develop/Build' 
package.path = package.path .. ";" .. buildProjDir .. "/src/?.lua;" .. os.getenv("userprofile") .. "/?.lua;"
package.cpath = package.cpath .. ";" .. buildProjDir .. "/Bin/?.dll" 


-----------------------------------------------------------------------------------------------------------------------------------------------------


--- assert that the given argument is in fact of the correct type.
-- @param n argument index
-- @param val the value
-- @param tp the type
-- @param verify an optional verification function
-- @param msg an optional custom message
-- @param lev optional stack position for trace, default 2
-- @raise if the argument n is not the correct type
-- @usage assert_arg(1,t,'table')
-- @usage assert_arg(n,val,'string',path.isdir,'not a directory')
function assert_arg (n,val,tp,verify,msg,lev)
    if type(val) ~= tp then
        error(("argument %d expected a '%s', got a '%s'"):format(n,tp,type(val)),lev or 2)
    end
    if verify and not verify(val) then
        error(("argument %d: '%s' %s"):format(n,val,msg),lev or 2)
    end
end

--- assert the common case that the argument is a string.
-- @param n argument index
-- @param val a value that must be a string
-- @raise val must be a string
function assert_string (n,val)
    assert_arg(n,val,'string',nil,nil,3)
end


--- write an arbitrary number of arguments to a file using a format.
-- @param f File handle to write to.
-- @param fmt The format (see string.format).
-- @param ... Extra arguments for format
function fprintf(f,fmt,...)
    assert_string(2,fmt)
    f:write(format(fmt,...))
end


--- print an arbitrary number of arguments using a format.
-- @param fmt The format (see string.format)
-- @param ... Extra arguments for format
function printf(fmt,...)
    assert_string(1,fmt)
    fprintf(stdout,fmt,...)
end


--- end this program gracefully.
-- @param code The exit code or a message to be printed
-- @param ... extra arguments for message's format'
-- @see utils.fprintf
function quit(code,...)
    if type(code) == 'string' then
        fprintf(io.stderr,code,...)
        code = -1
    else
        fprintf(io.stderr,...)
    end
    io.stderr:write('\n')
    os.exit(code)
end


--- used by Penlight functions to return errors.  Its global behaviour is controlled
-- by <code>utils.on_error</code>
-- @param err the error string.
-- @see utils.on_error
function raise (err)
    if err_mode == 'default' then return nil,err
    elseif err_mode == 'quit' then quit(err)
    else error(err,2)
    end
end


local err_mode = 'default'

--- control the error strategy used by Penlight.
-- Controls how <code>utils.raise</code> works; the default is for it
-- to return nil and the error string, but if the mode is 'error' then
-- it will throw an error. If mode is 'quit' it will immediately terminate
-- the program.
-- @param mode - either 'default', 'quit'  or 'error'
-- @see utils.raise
function on_error (mode)
    if ({['default'] = 1, ['quit'] = 2, ['error'] = 3})[mode] then
      err_mode = mode
    else
      -- fail loudly
      if err_mode == 'default' then err_mode = 'error' end
      raise("Bad argument expected string; 'default', 'quit', or 'error'. Got '"..tostring(mode).."'")
    end
end


--- split a string into a list of strings separated by a delimiter.
-- @param s The input string
-- @param re A Lua string pattern; defaults to '%s+'
-- @param plain don't use Lua patterns
-- @param n optional maximum number of splits
-- @return a list-like table
-- @raise error if s is not a string
function split(s,re,plain,n)
    assert_string(1,s)
    local find,sub,append = string.find, string.sub, table.insert
    local i1,ls = 1,{}
    if not re then re = '%s+' end
    if re == '' then return {s} end
    while true do
        local i2,i3 = find(s,re,i1,plain)
        if not i2 then
            local last = sub(s,i1)
            if last ~= '' then append(ls,last) end
            if #ls == 1 and ls[1] == '' then
                return {}
            else
                return ls
            end
        end
        append(ls,sub(s,i1,i2-1))
        if n and #ls == n then
            ls[#ls] = sub(s,i1)
            return ls
        end
        i1 = i3+1
    end
end


--- split a string into a number of values.
-- @param s the string
-- @param re the delimiter, default space
-- @return n values
-- @usage first,next = splitv('jane:doe',':')
-- @see split
function splitv (s,re)
    return unpack(split(s,re))
end


--- parse command-line arguments into flags and parameters.
-- Understands GNU-style command-line flags; short (`-f`) and long (`--flag`).
-- These may be given a value with either '=' or ':' (`-k:2`,`--alpha=3.2`,`-n2`);
-- note that a number value can be given without a space.
-- Multiple short args can be combined like so: ( `-abcd`).
-- @tparam {string} args an array of strings (default is the global `arg`)
-- @tab flags_with_values any flags that take values, e.g. `{out=true}`
-- @return a table of flags (flag=value pairs)
-- @return an array of parameters
-- @raise if args is nil, then the global `args` must be available!
function parse_args (args,flags_with_values)
    if not args then
        args = _G.arg
        if not args then error "Not in a main program: 'arg' not found" end
    end
    flags_with_values = flags_with_values or {}
    local _args = {}
    local flags = {}
    local i = 1
    while i <= #args do
        local a = args[i]
        local v = a:match('^-(.+)')
        local is_long
        if v then -- we have a flag
            if v:find '^-' then
                is_long = true
                v = v:sub(2)
            end
            if flags_with_values[v] then
                if i == #args or args[i+1]:find '^-' then
                    return raise ("no value for '"..v.."'")
                end
                flags[v] = args[i+1]
                i = i + 1
            else
                -- a value can also be indicated with = or :
                local var,val =  splitv (v,'[=:]')
                var = var or v
                val = val or true
                if not is_long then
                    if #var > 1 then
                        if var:find '.%d+' then -- short flag, number value
                            val = var:sub(2)
                            var = var:sub(1,1)
                        else -- multiple short flags
                            for i = 1,#var do
                                flags[var:sub(i,i)] = true
                            end
                            val = nil -- prevents use of var as a flag below
                        end
                    else  -- single short flag (can have value, defaults to true)
                        val = val or true
                    end
                end
                if val then
                    flags[var] = val
                end
            end
        else
            _args[#_args+1] = a
        end
        i = i + 1
    end
    return flags,_args
end



function _build_main()
   
  -- Process the arguments into an easy to use format.
  local flags, parameters = parse_args( _ARGV, {toolset=true, configuration=true} )

  local build   = require 'build'
  local project = require 'project'

  if not project.path then
    project.path = os.getcwd()
  end

  -- create the 'build' directory and enter it
  if not os.isdir( "Projects" ) then 
    os.mkdir( "Projects" )
  end

  os.chdir( "Projects" )

  local toolset = "msvc-14.1" -- Visual Studio 15 2017 
  if flags["toolset"] then
    toolset = flags["toolset"]
  elseif flags["t"] then
    toolset = flags["t"]
  end

  local configuration = "Release"
  if flags["configuration"] then
    configuration = flags["configuration"]
  elseif flags["c"] then
    configuration = flags["c"]
  end

  -- Recursively build all the dependencies for the project (some dependencies may have other dependencies etc, etc)
  build.build( project, toolset, configuration )

end
