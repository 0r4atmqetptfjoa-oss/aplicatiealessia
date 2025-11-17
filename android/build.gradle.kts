subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Removed obsolete flutter_gl configuration.
    // The project no longer depends on the flutter_gl plugin; therefore,
    // we skip configuring a flatDir repository for it and avoid setting
    // a namespace for a non-existent subproject. Keeping these lines
    // would cause a build error because the ':flutter_gl' project does
    // not exist.
}
