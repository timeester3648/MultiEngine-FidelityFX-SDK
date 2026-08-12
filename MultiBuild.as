void main(MultiBuild::Workspace& workspace) {
	auto project = workspace.create_project(".");
	auto properties = project.properties();

	project.name("FidelityFX-SDK");
	properties.binary_object_kind(MultiBuild::BinaryObjectKind::eSharedLib);
	project.license("./LICENSE.txt");

	project.include_own_required_includes(true);
	project.add_required_project_include({
		"./ffx-api/include"
	});

	{
		MultiBuild::ScopedFilter _(project, "config.platform:Windows");
		properties.pre_build_commands({
			"{:copy_file:} \"{:project.root}/PrebuiltSignedDLL/amd_fidelityfx_vk.lib\" \"{:project.target_dir}/amd_fidelityfx_vk.lib\"",
			"{:copy_file:} \"{:project.root}/PrebuiltSignedDLL/amd_fidelityfx_vk.dll\" \"{:project.target_dir}/amd_fidelityfx_vk.dll\""
		});
	}

	// {
	// 	MultiBuild::ScopedFilter _(project, "config.platform:Windows");
	// 	properties.files("./sdk/src/backends/dx12/**.cpp");

	// 	properties.pre_build_commands({
	// 		"{:copy_file:} \"{:project.root}/PrebuiltSignedDLL/amd_fidelityfx_dx12.lib\" \"{:project.target_dir}/amd_fidelityfx_dx12.lib\"",
	// 		"{:copy_file:} \"{:project.root}/PrebuiltSignedDLL/amd_fidelityfx_dx12.dll\" \"{:project.target_dir}/amd_fidelityfx_dx12.dll\""
	// 	});
	// }
}