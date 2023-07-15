include "../../premake/common_premake_defines.lua"

project "FidelityFX-SDK"
	kind "StaticLib"
	language "C++"
	cppdialect "C++latest"
	cdialect "C17"
	targetname "%{prj.name}"
	inlining "Auto"

	files {
		"./sdk/src/*.cpp",
		"./sdk/src/shared/**.cpp",
		"./sdk/src/components/**.cpp"
	}

	includedirs {
		"./sdk/src/shared",

		"%{IncludeDir.fidelityfx_sdk}"
	}