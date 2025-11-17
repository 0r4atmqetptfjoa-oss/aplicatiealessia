allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Fix for flutter_gl dependency resolution
    if (project.name == "app") {
        project.repositories {
            flatDir {
                dirs(rootProject.project(":flutter_gl").projectDir.resolve("libs"))
            }
        }
    }

    // Fix for flutter_gl namespace
    if (project.name == "flutter_gl") {
        afterEvaluate {
            project.extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
                namespace = "com.shepeliev.flutter_gl"
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
