include "../../premake/common_premake_defines.lua"
include "premake_shader_util.lua"

local FIDELITYFX_SDK_SC = "%{wks.location}/dependencies/FidelityFX-SDK/sdk/tools/binary_store/FidelityFX_SC.exe"
local SHADER_BASE_OUTPUT_DIR = "%{wks.location}/dependencies/FidelityFX-SDK/sdk/src/backends/shared/blob_accessors/"

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
		SHADER_BASE_OUTPUT_DIR .. "**",

		"%{IncludeDir.fidelityfx_sdk}"
	}

	-- TODO: for other platforms when supported
	filter "system:windows"
		prebuildcommands {
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersBLUR.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR .. "blur"),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersCACAO.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR .. "cacao"),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersCas.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR .. "cas"),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersClassifier.txt",
							FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR .. "classifier"),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersDenoiser.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR .. "denoiser"),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersDOF.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR .. "dof"),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersFSR1.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR .. "fsr1"),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersFSR2.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR .. "fsr2"),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersLENS.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR .. "lens"),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersLPM.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR .. "lpm"),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersParallelSort.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR .. "parallel_sort"),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersSPD.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR .. "spd"),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersSSSR.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR .. "sssr"),
			parse_cmake_file("./sdk/src/backends/vk/CMakeShadersVRS.txt",
							 FIDELITYFX_SDK_SC, SHADER_BASE_OUTPUT_DIR .. "vrs")
		}