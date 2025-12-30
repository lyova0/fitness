import org.gradle.api.file.Directory

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

/**
 * Новый buildDir для всего проекта
 */
val sharedBuildDir: Directory =
    layout.buildDirectory.dir("../../build").get()

/**
 * Применяем его ко всем subprojects
 */
subprojects {
    layout.buildDirectory.set(sharedBuildDir.dir(name))
    evaluationDependsOn(":app")
}

/**
 * Clean task
 */
tasks.register<Delete>("clean") {
    delete(sharedBuildDir)
}

plugins {
    id("com.google.gms.google-services") version "4.4.4" apply false
}
