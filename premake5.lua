include "../../premake/common_premake_defines.lua"
include "premake_shader_util.lua"

local SHADER_BASE_INPUT_DIR = "%{wks.location}/dependencies/FidelityFX-SDK/sdk/src/backends/vk/"
local FIDELITYFX_SDK_SC = "%{wks.location}/dependencies/FidelityFX-SDK/sdk/tools/binary_store/FidelityFX_SC.exe"
local SHADER_BASE_OUTPUT_DIR = "%{wks.location}/dependencies/FidelityFX-SDK/sdk/src/backends/shared/blob_accessors/shaders"

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
		"./sdk/src/components/**.cpp",
		"./sdk/src/backends/shared/**.cpp",
	}

	defines {
		"FFX_ALL"
	}

	includedirs {
		"./sdk/src/shared",
		"./sdk/src/components",
		SHADER_BASE_OUTPUT_DIR,

		"%{IncludeDir.fidelityfx_sdk}"
	}

	-- TODO: for other platforms when supported
	filter "system:windows"
		prebuildcommands {
			"rmdir /s /q \"" .. SHADER_BASE_OUTPUT_DIR .. "\"",
			"mkdir \"" .. SHADER_BASE_OUTPUT_DIR .. "\"",

			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersBLUR.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR, SHADER_BASE_INPUT_DIR),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersCACAO.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR, SHADER_BASE_INPUT_DIR),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersCas.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR, SHADER_BASE_INPUT_DIR),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersClassifier.txt",
							FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR, SHADER_BASE_INPUT_DIR),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersDenoiser.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR, SHADER_BASE_INPUT_DIR),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersDOF.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR, SHADER_BASE_INPUT_DIR),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersFSR1.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR, SHADER_BASE_INPUT_DIR),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersFSR2.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR, SHADER_BASE_INPUT_DIR),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersLENS.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR, SHADER_BASE_INPUT_DIR),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersLPM.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR, SHADER_BASE_INPUT_DIR),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersParallelSort.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR, SHADER_BASE_INPUT_DIR),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersSPD.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR, SHADER_BASE_INPUT_DIR),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersSSSR.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR, SHADER_BASE_INPUT_DIR),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersVRS.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR, SHADER_BASE_INPUT_DIR)
		}