local SHADER_PREFIX_DIR = "sdk/src/backends/vk/"

local function compile_shaders(EXECUTABLE, BASE_ARGS, VK_BASE_ARGS, PERMUTATION_ARGS, INCLUDES_ARGS,
							   SHADER_FILES, PERMUTATION_OUTPUTS, INPUT_DIR_PREFIX)
	local result = {}

	for _, SHADER_PATH in ipairs(SHADER_FILES) do
		local all_files = {}
		if string.find(SHADER_PATH, "*") then
			all_files = os.matchfiles(SHADER_PREFIX_DIR .. SHADER_PATH)

			for i, value in ipairs(all_files) do
				if string.sub(value, 1, #SHADER_PREFIX_DIR) == SHADER_PREFIX_DIR then
					all_files[i] = string.sub(value, #SHADER_PREFIX_DIR + 1)
				end
			end
		else
			table.insert(all_files, SHADER_PATH)
		end

		for _, PASS_SHADER in ipairs(all_files) do
			local PASS_SHADER_FILENAME = path.getbasename(PASS_SHADER)
			local PASS_SHADER_TARGET = path.getbasename(PASS_SHADER, ".*")

			local sc_args = string.format("%s %s %s", BASE_ARGS, VK_BASE_ARGS, PERMUTATION_ARGS)

			local executable_call = EXECUTABLE
			local full_input = INPUT_DIR_PREFIX .. PASS_SHADER

			local wave32_command = string.format('%s %s -name="%s" -DFFX_HALF=0 %s -output="%s" "%s"', 
												executable_call, sc_args, PASS_SHADER_FILENAME, INCLUDES_ARGS, PERMUTATION_OUTPUTS, full_input)
			local wave64_command = string.format('%s %s -name="%s_wave64" -DFFX_HALF=0 %s -output="%s" "%s"', 
												executable_call, sc_args, PASS_SHADER_FILENAME, INCLUDES_ARGS, PERMUTATION_OUTPUTS, full_input)
			local wave32_16bit_command = string.format('%s %s -name="%s_16bit" -DFFX_HALF=1 %s -output="%s" "%s"', 
													executable_call, sc_args, PASS_SHADER_FILENAME, INCLUDES_ARGS, PERMUTATION_OUTPUTS, full_input)
			local wave64_16bit_command = string.format('%s %s -name="%s_wave64_16bit" -DFFX_HALF=1 %s -output="%s" "%s"', 
													executable_call, sc_args, PASS_SHADER_FILENAME, INCLUDES_ARGS, PERMUTATION_OUTPUTS, full_input)

			table.insert(result, wave32_command)
			table.insert(result, wave64_command)
			table.insert(result, wave32_16bit_command)
			table.insert(result, wave64_16bit_command)
		end
	end

	return result
end

local FFX_GPU_PATH = "./sdk/include/FidelityFX/gpu"

function parse_cmake_file(cmake_file, ffx_sc_executable, output_directory, input_dir_prefix)
	local cmakeCode = io.open(cmake_file, "r"):read("*all")

	function parse_cmake_string(inputString, variableName, commandType)
		local pattern = commandType .. "%s*(" .. variableName .. "%s*.-)%s*%)\n?"
		local result = inputString:match(pattern)
		
		if result then
			result = result:gsub("\n", "") -- Remove newlines
			result = result:gsub("%s+", " ") -- Replace multiple whitespace characters with a single space

			local var_pattern = "^%s*" .. variableName .. "%s+"
			result = result:gsub(var_pattern, "")
			result = result:gsub("${FFX_GPU_PATH}", FFX_GPU_PATH)
			return result
		end
		
		return nil -- If no match is found
	end
	
	local function extract_set_variable_value(variable)
		return parse_cmake_string(cmakeCode, variable, "set%(")
	end

	local function extract_file_variable_value(variable)
		return parse_cmake_string(cmakeCode, variable, "file%(GLOB")
	end

	local variablePrefix = nil

	-- Extract variable prefix from the CMake code
	for variable in string.gmatch(cmakeCode, "set%((.-)\n") do
		local prefix = string.match(variable, "^(.-)_")
		if prefix then
			variablePrefix = prefix
			break
		end
	end

	if not variablePrefix then
		print("Variable prefix not found in CMake code")
		return
	end

	local function generate_variable_name(name)
		return variablePrefix .. "_" .. name
	end

	local function generate_includes(pathList)
		local paths = {}

		-- Extract paths by splitting the input string
		for path in pathList:gmatch("\"(.-)\"") do
			table.insert(paths, "-I\"" .. path .. "\"")
		end

		-- Concatenate the modified paths into a single string
		return table.concat(paths, " ")
	end

	local function separate_shaders(pathList)
		local paths = {}

		for path in pathList:gmatch("\"(.-)\"") do
			table.insert(paths, path)
		end

		return paths
	end

	local BASE_ARGS = extract_set_variable_value(generate_variable_name("BASE_ARGS"))
	local VK_BASE_ARGS = extract_set_variable_value(generate_variable_name("VK_BASE_ARGS"))
	local PERMUTATION_ARGS = extract_set_variable_value(generate_variable_name("PERMUTATION_ARGS"))
	local INCLUDE_ARGS = extract_set_variable_value(generate_variable_name("INCLUDE_ARGS"))
	local SHADER_FILES = extract_file_variable_value(generate_variable_name("SHADERS"))

	-- TODO: better way: parse name from compile_shaders call
	if not VK_BASE_ARGS then
		VK_BASE_ARGS = extract_set_variable_value(generate_variable_name("GLSL_BASE_ARGS"))
	end

	if not SHADER_FILES then
		SHADER_FILES = extract_file_variable_value(generate_variable_name("SHADERS_GLSL"))
	end
	
	return compile_shaders(ffx_sc_executable,
						   BASE_ARGS or "",
						   VK_BASE_ARGS or "",
						   PERMUTATION_ARGS or "",
						   generate_includes(INCLUDE_ARGS or ""),
						   separate_shaders(SHADER_FILES),
						   output_directory,
						   input_dir_prefix)
end