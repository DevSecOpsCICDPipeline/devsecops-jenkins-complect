import jenkins.model.*
import hudson.model.*
import hudson.tasks.Maven
import hudson.tools.*

def jenkins = Jenkins.get()

// Define the Maven installer (auto-download version 3.9.6)
def mavenInstaller = new InstallSourceProperty([
    new Maven.MavenInstaller("3.9.6")
])

// Create Maven tool entry with empty home (auto-install)
def mavenInstall = new Maven.MavenInstallation(
    "Maven_3.9.6", // tool name shown in Jenkins UI
    "",            // leave home path empty for auto-install
    [mavenInstaller]
)

def desc = jenkins.getDescriptorByType(Maven.DescriptorImpl.class)
desc.setInstallations(mavenInstall)
desc.save()
jenkins.save()

println "✅ Maven 3.9.6 will be auto-installed by Jenkins"