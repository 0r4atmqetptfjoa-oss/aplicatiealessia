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

    // Defer the repository configuration for the 'app' project to ensure that the 'flutter_gl' project
    // has been resolved and its directory is available.
    if (project.name == "app") {
        afterEvaluate {
            project.repositories {
                flatDir {
                    dirs(rootProject.project(":flutter_gl").projectDir.resolve("libs"))
                }
            }
        }
    }

    // Defer the namespace configuration for 'flutter_gl' until after it has been evaluated.
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
