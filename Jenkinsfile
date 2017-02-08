node ('master'){
  
  stage ('Clone repository') {
    	git url: 'https://github.com/AVShutov/devops_training.git', branch: 'task3'
  }
  stage ('Build') {
      sh ('chmod +x gradlew && ./gradlew build -Dhttp.proxyHost=10.4.252.10 -Dhttp.proxyPort=3128 -Dhttps.proxyHost=10.4.252.10 -Dhttps.proxyPort=3128')
  }
  stage ('Push changes on github') {
      withCredentials([usernameColonPassword(credentialsId: '90d738ad-cfac-41fd-ab73-368dcacd77ff', variable: 'GIT_CREDENTIALS')]) {
      sh ('git config --global http.proxy http://10.4.252.10:3128')
      sh ('git config --global https.proxy https://10.4.252.10:3128')
      sh "git config user.email 'shutoff.alexey@gmail.com'"
      sh "git config user.name 'AVShutov'"
      sh 'git config push.default simple'
      sh 'git add gradle.properties'
      sh "git commit -m 'increment build version'"
      sh "git push https://${GIT_CREDENTIALS}@github.com/AVShutov/devops_training.git task3"
    }
  }

  stage ('Upload to nexus') {
	
	withCredentials([usernameColonPassword(credentialsId: '64b138ef-9d2e-4d94-bf84-45336c0a941e', variable: 'NEXUS_CREDENTIALS')]) {
      def props = readProperties  file: './gradle.properties'
      def VER = props['MajorVersion']
      def BUI = props['BuildNumber']
      sh "curl -X PUT -u ${NEXUS_CREDENTIALS} -T ./build/libs/task3.war http://192.168.20.13:8081/nexus/content/repositories/training/task3/${VER}.${BUI}/"
	  version(VER, BUI)
	  }
    }
  }
  def version(VER, BUI) {
  node('node_tomcat1') {
  stage ('Deploy to tomcat1') {

      withCredentials([usernamePassword(credentialsId: '41df2464-e228-44e7-81c2-7877017a3825', passwordVariable: 'TOMCAT_PASSWD', usernameVariable: 'TOMCAT_USER')]) {
      println("Stopping LoadBalancing for tomcat1")
      httpRequest httpMode: 'POST', url: "http://192.168.20.10/jk-status?cmd=update&from=list&w=lb&sw=tomcat1&vwa=1"
      sh "wget -O - -q http://$TOMCAT_USER:$TOMCAT_PASSWD@192.168.20.11:8080/manager/text/undeploy?path=/new/task3"
      sh "curl 'http://192.168.20.13:8081/nexus/content/repositories/training/task3/${VER}.${BUI}/task3.war' | curl -T - -u $TOMCAT_USER:$TOMCAT_PASSWD 'http://192.168.20.11:8080/manager/text/deploy?path=/new/task3&update=true'"
	  sleep 30
      httpRequest httpMode: 'POST', url: "http://192.168.20.10/jk-status?cmd=update&from=list&w=lb&sw=tomcat1&vwa=0"
    }
  }
}
  node('node_tomcat2') {
  stage ('Deploy to tomcat2') {
  
      withCredentials([usernamePassword(credentialsId: '41df2464-e228-44e7-81c2-7877017a3825', passwordVariable: 'TOMCAT_PASSWD', usernameVariable: 'TOMCAT_USER')]) {
      println("Stopping LoadBalancing for tomcat2")
      httpRequest httpMode: 'POST', url: "http://192.168.20.10/jk-status?cmd=update&from=list&w=lb&sw=tomcat2&vwa=1"
      sh "wget -O - -q http://$TOMCAT_USER:$TOMCAT_PASSWD@192.168.20.12:8080/manager/text/undeploy?path=/new/task3"
      sh "curl 'http://192.168.20.13:8081/nexus/content/repositories/training/task3/${VER}.${BUI}/task3.war' | curl -T - -u $TOMCAT_USER:$TOMCAT_PASSWD 'http://192.168.20.12:8080/manager/text/deploy?path=/new/task3&update=true'"
	  sleep 30
      httpRequest httpMode: 'POST', url: "http://192.168.20.10/jk-status?cmd=update&from=list&w=lb&sw=tomcat2&vwa=0"
  }
}
}
}