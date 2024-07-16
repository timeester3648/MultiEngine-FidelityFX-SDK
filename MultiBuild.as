void main(MultiBuild::Workspace& workspace) {
	const MultiEngine::String shader_base_output_dir = "{:project.root}/sdk/src/backends/shared/blob_accessors/shaders/{:config.build_config}";

	auto project = workspace.create_project(".");
	auto properties = project.properties();

	project.name("FidelityFX-SDK");
	properties.binary_object_kind(MultiBuild::BinaryObjectKind::eSharedLib);
	project.license("./LICENSE.txt");

	project.include_own_required_includes(true);
	project.add_required_project_include({
		"./sdk/include",
		"./sdk/src/backends/shared"
	});

	properties.files({
		"./sdk/src/*.h",
		"./sdk/src/*.cpp",
		"./sdk/src/shared/**.h",
		"./sdk/src/shared/**.cpp",
		"./sdk/src/components/**.h",
		"./sdk/src/components/**.cpp",
		"./sdk/src/backends/shared/*.h",
		"./sdk/src/backends/shared/**.cpp",

		"./sdk/src/backends/vk/**.cpp"
	});

	properties.project_includes("Vulkan-Headers");

	properties.defines({ 
		"FFX_ALL",
		"FFX_BUILD_AS_DLL"
	});

	properties.include_directories({
		"./sdk/src/shared",
		"./sdk/src/components",

		shader_base_output_dir
	});

	properties.library_links("{env:VULKAN_SDK:}/Lib/vulkan-1");

	{
		MultiBuild::ScopedFilter _(project, "config.platform:Windows");

		const MultiEngine::String shader_base_input_dir = "{:project.root}/sdk/src/backends/vk/";
		const MultiEngine::String fidelityfx_sdk_sc = "{:project.root}/sdk/tools/binary_store/FidelityFX_SC.exe";

		properties.pre_build_commands(MultiEngine::format("{{:create_directory:}} \"{}\"", shader_base_output_dir));
		
		MultiBuild::FidelityFxSdk::shader_pre_build_commands(project,
															 "./sdk/src/backends/vk/CMakeShaders*.txt",
															 "{:project.root}/sdk/tools/binary_store/FidelityFX_SC.exe", 
															 shader_base_output_dir,
															 "{:project.root}/sdk/src/backends/vk/");
	}

	{
		MultiBuild::ScopedFilter _(project, "project.compiler:VisualCpp");
		properties.disable_warnings({ "4244", "4267" });
	}

	// {
	// 	MultiBuild::ScopedFilter _(project, "config.platform:Windows");
	// 	properties.files("./sdk/src/backends/dx12/**.cpp");
	// }
}