resource.AddFile( "resource/fonts/roboto_light.ttf" )
local files = file.Find( "materials/bhud/*.png", "GAME" ) -- Phone images
for k, v in pairs(files) do
	resource.AddFile("materials/bhud/"..v)
end