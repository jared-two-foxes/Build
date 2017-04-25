-- Format: { rootPath, projectPath, 'buildSystem', libname (release), libname (debug)? } 

return {
  boost = {   
    'boost',    
    nil,                  
    'boost.build',
    nil,
    nil,
  },

  jsoncpp = {  
    'jsoncpp',
    nil,            
    'cmake',
    'jsoncpp.lib',
    'jsoncppd.lib',
  },

   brofiler = {
    'Brofiler-1.1.1',       
    nil,             
    nil,
    'ProfilerCore64.lib',
    'ProfilerCore64.lib',
  },

  zlib = {
    'zlib',  
    nil,                
    'cmake',
    'zlib.lib',
    'zlibd.lib',
  },

  libpng = {
    'libpng',  
    nil,
    'cmake',
    'libpng16.lib',
    'libpng16d.lib',
  },

  freetype = {   
    'freetype2',  
    nil,            
    'cmake',
    'freetype.lib',
    'freetyped.lib',
  },

  utf8 = {   
    'utf8',                    
    nil,                                
    nil,
    nil,
    nil 
  },

  lua = {  
    'luaDist',   
    nil,   
    'cmake',             
    'lua.lib',
    'luad.lib',
  },

  libogg = {  
    'libogg',   
    nil,  
    'cmake',             
    'ogg.lib',
    'oggd.lib',
  },

  libvorbis = {  
    'libvorbis',   
    nil,
    'cmake',             
    'vorbis.lib;vorbisenc.lib;vorbisfile.lib',
    'vorbisd.lib;vorbisencd.lib;vorbisfiled.lib',
  },

  openal = {  
    'openal-soft',   
    nil,  
    'cmake',             
    'OpenAL32.lib',
    'OpenAL32d.lib',
  },
}