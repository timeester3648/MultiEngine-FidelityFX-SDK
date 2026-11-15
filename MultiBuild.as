void main(MultiBuild::Workspace& workspace) {
	auto project = workspace.create_project(".");
	auto properties = project.properties();

	project.name("FidelityFX-SDK");
	properties.binary_object_kind(MultiBuild::BinaryObjectKind::eUtility);
	project.license("./docs/license.md");

	project.include_own_required_includes(true);
	project.add_required_project_include({
		"./Kits/FidelityFX/api/include",
		"./Kits/FidelityFX/denoisers/include",
		"./Kits/FidelityFX/framegeneration/include",
		"./Kits/FidelityFX/radiancecache/include",
		"./Kits/FidelityFX/upscalers/include"
	});

	{
		MultiBuild::ScopedFilter _(project, "config.platform:Windows");
		// Stage the matching SDK runtime and its dependencies here without renaming binaries.
		properties.pre_build_commands({
			"{:copy_directory:} \"{:project.root}Kits/FidelityFX/signedbin\" \"{:project.target_dir}\""
		});
	}

}