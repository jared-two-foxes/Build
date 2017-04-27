-- Format: { rootPath, 'buildSystem', libname (release), libname (debug)? } 

-- @todo: Add version support.
-- @todo: Add in dependencies for global projects

return {
  boost = {   
    'D:/Develop/Nebulous/Externals/boost',                 
    'boost.build',
    nil,
    nil,
    nil,
  },

  jsoncpp = {  
    'D:/Develop/Nebulous/Externals/jsoncpp',      
    'cmake',
    nil,
    'jsoncpp.lib',
    'jsoncppd.lib',
  },

   brofiler = {
    'D:/Develop/Nebulous/Externals/Brofiler-1.1.1',             
    nil,
    nil,
    'ProfilerCore64.lib',
    'ProfilerCore64.lib',
  },

  zlib = {
    'D:/Develop/Nebulous/Externals/zlib',            
    'cmake',
    nil,
    'zlib.lib',
    'zlibd.lib',
  },

  libpng = {
    'D:/Develop/Nebulous/Externals/libpng',
    'cmake',
    'zlib',
    'libpng16.lib',
    'libpng16d.lib',
  },

  freetype = {   
    'D:/Develop/Nebulous/Externals/freetype2',        
    'cmake',
    nil,
    'freetype.lib',
    'freetyped.lib',
  },

  utf8 = {   
    'D:/Develop/Nebulous/Externals/utf8',                              
    nil,
    nil,
    nil,
    nil 
  },

  lua = {  
    'D:/Develop/Nebulous/Externals/luaDist',  
    'cmake',             
    nil,
    'lua.lib',
    'luad.lib',
  },

  libogg = {  
    'D:/Develop/Nebulous/Externals/libogg',   
    'cmake',             
    'ogg.lib',
    'oggd.lib',
  },

  libvorbis = {  
    'D:/Develop/Nebulous/Externals/libvorbis',   
    'cmake',             
    'libogg',
    'vorbis.lib;vorbisenc.lib;vorbisfile.lib',
    'vorbisd.lib;vorbisencd.lib;vorbisfiled.lib',
  },

  openal = {  
    'D:/Develop/Nebulous/Externals/openal-soft',
    'cmake',
    'libogg,libvorbis',             
    'OpenAL32.lib',
    'OpenAL32d.lib',
  },
}