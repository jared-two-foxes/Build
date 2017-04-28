-- Format: { rootPath, 'buildSystem', libname (release), libname (debug)? } 

-- @todo: Add version support.
-- @todo: Add in dependencies for global projects

return {
  boost = {   
    name = 'boost',
    path = 'C:/Develop/Nebulous/Externals/boost',                 
    system = 'boost.build',
    dependencies = nil,
    debugLibrary = nil,
    releaseLibrary = nil,
  },

  jsoncpp = {  
    name = 'jsoncpp',
    path = 'C:/Develop/Nebulous/Externals/jsoncpp',      
    system = 'cmake',
    dependencies = nil,
    debugLibrary = 'jsoncpp.lib',
    releaseLibrary = 'jsoncppd.lib',
  },

   brofiler = {  
    name = 'brofiler',
    path = 'C:/Develop/Nebulous/Externals/Brofiler-1.1.1',             
    system = nil,
    dependencies = nil,
    debugLibrary = 'ProfilerCore64.lib',
    releaseLibrary = 'ProfilerCore64.lib',
  },

  zlib = {  
    name = 'zlib',
    path = 'C:/Develop/Nebulous/Externals/zlib',            
    system = 'cmake',
    dependencies = nil,
    debugLibrary = 'zlib.lib',
    releaseLibrary = 'zlibd.lib',
  },

  libpng = {  
    name = 'libpng',
    path = 'C:/Develop/Nebulous/Externals/libpng',
    system = 'cmake',
    dependencies = {'zlib'},
    debugLibrary = 'libpng16.lib',
    releaseLibrary = 'libpng16d.lib',
  },

  freetype = {  
    name = 'freetype', 
    path = 'C:/Develop/Nebulous/Externals/freetype2',        
    system = 'cmake',
    dependencies = nil,
    debugLibrary = 'freetype.lib',
    releaseLibrary = 'freetyped.lib',
  },

  utf8 = {     
    name = 'utf8',
    path = 'C:/Develop/Nebulous/Externals/utf8',                              
    system = nil,
    dependencies = nil,
    debugLibrary = nil,
    releaseLibrary = nil 
  },

  lua = {    
    name = 'lua',
    path = 'C:/Develop/Nebulous/Externals/luaDist',  
    system = 'cmake',             
    dependencies = nil,
    debugLibrary = 'lua.lib',
    releaseLibrary = 'luad.lib',
  },

  libogg = {    
    name = 'libogg',
    path = 'C:/Develop/Nebulous/Externals/libogg',   
    system = 'cmake', 
    dependencies = nil,            
    debugLibrary = 'ogg.lib',
    releaseLibrary = 'oggd.lib',
  },

  libvorbis = {    
    name = 'libvorbis',
    path = 'C:/Develop/Nebulous/Externals/libvorbis',   
    system = 'cmake',             
    dependencies = {'libogg'},
    debugLibrary = 'vorbis.lib;vorbisenc.lib;vorbisfile.lib',
    releaseLibrary = 'vorbisd.lib;vorbisencd.lib;vorbisfiled.lib',
  },

  openal = {    
    name = 'openal',
    path = 'C:/Develop/Nebulous/Externals/openal-soft',
    system = 'cmake',
    dependencies = {'libogg','libvorbis'},            
    debugLibrary = 'OpenAL32.lib',
    releaseLibrary = 'OpenAL32d.lib',
  },
}