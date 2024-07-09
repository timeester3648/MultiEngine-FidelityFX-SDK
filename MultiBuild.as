void main(MultiBuild::Workspace& workspace) {
	const MultiEngine::String shader_base_output_dir = "{:project.root}/sdk/src/backends/shared/blob_accessors/shaders/{:config.build_config}";

	auto project = workspace.create_project(".");
	auto properties = project.properties();

	project.name("FidelityFX-SDK");
	properties.binary_object_kind(MultiBuild::BinaryObjectKind::eStaticLib);
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
		"./sdk/src/backends/shared/**.cpp"
	});

	properties.defines("FFX_ALL");
	properties.include_directories({
		"./sdk/src/shared",
		"./sdk/src/components",

		shader_base_output_dir
	});

	{
		MultiBuild::ScopedFilter _(project, "config.platform:Windows");

		const MultiEngine::String shader_base_input_dir = "{:project.root}/sdk/src/backends/vk/";
		const MultiEngine::String fidelityfx_sdk_sc = "{:project.root}/sdk/tools/binary_store/FidelityFX_SC.exe";

		properties.pre_build_commands(MultiEngine::format("{{:create_directory:}} \"{}\"", shader_base_output_dir));
		
		MultiBuild::FidelityFxSdk::shader_pre_build_commands(project,
															 "./sdk/src/backends/vk/CMakeShadersBLUR.txt",
															 fidelityfx_sdk_sc, shader_base_output_dir, shader_base_input_dir);
		MultiBuild::FidelityFxSdk::shader_pre_build_commands(project,
															 "./sdk/src/backends/vk/CMakeShadersCACAO.txt",
															 fidelityfx_sdk_sc, shader_base_output_dir, shader_base_input_dir);
		MultiBuild::FidelityFxSdk::shader_pre_build_commands(project,
															 "./sdk/src/backends/vk/CMakeShadersCas.txt",
															 fidelityfx_sdk_sc, shader_base_output_dir, shader_base_input_dir);
		MultiBuild::FidelityFxSdk::shader_pre_build_commands(project,
															 "./sdk/src/backends/vk/CMakeShadersClassifier.txt",
															 fidelityfx_sdk_sc, shader_base_output_dir, shader_base_input_dir);
		MultiBuild::FidelityFxSdk::shader_pre_build_commands(project,
															 "./sdk/src/backends/vk/CMakeShadersDenoiser.txt",
															 fidelityfx_sdk_sc, shader_base_output_dir, shader_base_input_dir);
		MultiBuild::FidelityFxSdk::shader_pre_build_commands(project,
															 "./sdk/src/backends/vk/CMakeShadersDOF.txt",
															 fidelityfx_sdk_sc, shader_base_output_dir, shader_base_input_dir);
		MultiBuild::FidelityFxSdk::shader_pre_build_commands(project,
															 "./sdk/src/backends/vk/CMakeShadersFSR1.txt",
															 fidelityfx_sdk_sc, shader_base_output_dir, shader_base_input_dir);
		MultiBuild::FidelityFxSdk::shader_pre_build_commands(project,
															 "./sdk/src/backends/vk/CMakeShadersFSR2.txt",
															 fidelityfx_sdk_sc, shader_base_output_dir, shader_base_input_dir);
		MultiBuild::FidelityFxSdk::shader_pre_build_commands(project,
															 "./sdk/src/backends/vk/CMakeShadersLENS.txt",
															 fidelityfx_sdk_sc, shader_base_output_dir, shader_base_input_dir);
		MultiBuild::FidelityFxSdk::shader_pre_build_commands(project,
															 "./sdk/src/backends/vk/CMakeShadersLPM.txt",
															 fidelityfx_sdk_sc, shader_base_output_dir, shader_base_input_dir);
		MultiBuild::FidelityFxSdk::shader_pre_build_commands(project,
															 "./sdk/src/backends/vk/CMakeShadersParallelSort.txt",
															 fidelityfx_sdk_sc, shader_base_output_dir, shader_base_input_dir);
		MultiBuild::FidelityFxSdk::shader_pre_build_commands(project,
															 "./sdk/src/backends/vk/CMakeShadersSPD.txt",
															 fidelityfx_sdk_sc, shader_base_output_dir, shader_base_input_dir);
		MultiBuild::FidelityFxSdk::shader_pre_build_commands(project,
															 "./sdk/src/backends/vk/CMakeShadersSSSR.txt",
															 fidelityfx_sdk_sc, shader_base_output_dir, shader_base_input_dir);
		MultiBuild::FidelityFxSdk::shader_pre_build_commands(project,
															 "./sdk/src/backends/vk/CMakeShadersVRS.txt",
															 fidelityfx_sdk_sc, shader_base_output_dir, shader_base_input_dir);
	}
}