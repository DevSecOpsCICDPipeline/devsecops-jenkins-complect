#!groovy

import jenkins.model.*
import hudson.PluginWrapper
import hudson.model.UpdateCenter

def instance = Jenkins.instance
def pluginManager = instance.pluginManager
def updateCenter = instance.updateCenter

// List of required plugins
def plugins = [
  "git", 
  "workflow-aggregator",  // for pipelines
  "blueocean", 
  "credentials", 
  "job-dsl"
]

println "--> Checking Jenkins plugins..."

def installed = pluginManager.plugins.collect { it.shortName }
def notInstalled = plugins.findAll { !installed.contains(it) }

if (notInstalled) {
  println "--> Installing missing plugins: ${notInstalled}"
  notInstalled.each {
    def plugin = updateCenter.getPlugin(it)
    if (plugin) {
      plugin.deploy()
    } else {
      println "!! Plugin not found in update center: ${it}"
    }
  }
  instance.save()
}