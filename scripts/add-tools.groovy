import jenkins.model.*
import hudson.tools.*
import hudson.tasks.Maven
import jenkins.plugins.nodejs.tools.*
import org.jenkinsci.plugins.DependencyCheck.tools.*
import hudson.plugins.sonar.*
import hudson.plugins.sonar.SonarRunnerInstallation
import hudson.tools.InstallSourceProperty
import hudson.tools.ToolProperty
import hudson.plugins.sonar.SonarRunnerInstaller

// Get Jenkins instance
def jenkins = Jenkins.get()

// --- Maven Auto-Install ---
def mavenInstaller = new InstallSourceProperty([
    new Maven.MavenInstaller("3.9.6") // Replace with desired version
])
def mavenTool = new Maven.MavenInstallation("Maven_3.9.6", "", [mavenInstaller])
jenkins.getDescriptorByType(Maven.DescriptorImpl.class).setInstallations(mavenTool)
println "✅ Maven 3.9.6 tool added"

// // --- NodeJS Auto-Install ---
// def nodeInstaller = new NodeJSInstaller("20.11.1", null, null) // Replace with desired Node version
// def nodeTool = new NodeJSInstallation("Node_20", "", [new InstallSourceProperty([nodeInstaller])])
// jenkins.getDescriptorByType(NodeJSInstallation.DescriptorImpl.class).setInstallations(nodeTool)
// println "✅ NodeJS 20.11.1 tool added"


// === DEPENDENCY-CHECK ===
def dcInstaller = new DependencyCheckInstaller("10.0.3")
def dcTool = new DependencyCheckInstallation("DC_9", "", [new InstallSourceProperty([dcInstaller])])
jenkins.getDescriptorByType(DependencyCheckInstallation.DescriptorImpl.class).setInstallations(dcTool)
println "✅ OWASP Dependency-Check 9.0.10 added"

def sonarInstaller = new SonarRunnerInstaller("5.0.1.3006")
def installSource = new InstallSourceProperty([sonarInstaller])
def sonarInstallation = new SonarRunnerInstallation("sonar-scanner-5.0", "", [installSource])
def sonarDesc = instance.getDescriptor(SonarRunnerInstallation.class)
sonarDesc.setInstallations(sonarInstallation)
sonarDesc.save()

jenkins.save()

