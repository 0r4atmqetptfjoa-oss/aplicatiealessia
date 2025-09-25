allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Relocate the project build directory so that Flutter and Gradle play
// nicely together when run inside a modular environment.  Without this
// adjustment the build artifacts would end up in sibling directories.
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean") {
    delete(rootProject.layout.buildDirectory)
}