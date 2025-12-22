allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir = File(rootProject.projectDir.parentFile, "build")
rootProject.buildDir = newBuildDir

subprojects {
    val rootPrefix = rootProject.projectDir.absolutePath.substring(0, 1)
    val projectPrefix = project.projectDir.absolutePath.substring(0, 1)
    
    if (rootPrefix == projectPrefix) {
        project.buildDir = File(newBuildDir, project.name)
    } else {
        // If the subproject is on a different drive (e.g. Flutter plugin in pub cache),
        // we cannot use the unified build directory on the main drive because
        // AGP's GenerateTestConfig task fails to calculate relative paths across drives.
        // We fallback to the default build directory (inside the plugin's folder).
        // Alternatively, we could set it to a temp path on that drive, but default is safest 
        // if permissions allow.
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
