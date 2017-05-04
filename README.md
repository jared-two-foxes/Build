# Nebulous.Build #

Personal Project generation and Dependency management solution.  

Attempts to work with a variety of different solution/project generation tools as much as possible, currently will work with cmake, premake & boost.build.  Note that all generators "work" in so much as they seem to work in the limited test cases that I'm currently using, theres bound to be lots that it doesnt do well.

## Build ##

Unfortunately currently we are not able to eat our own cat food so to speak, or atleast I havent pushed it that far in that direction so your going to need a copy of the premake binary, fortunately there is one in the Bin folder.

premake5 {toolset}
make (or whatever alternative you want to use)


