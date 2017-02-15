def NEXUS = 'http://192.168.20.13:8081/nexus/content/repositories/training/'
def TOMCAT = 'http://192.168.20.11:8082/task4/'
def TASK = 'task4'
def VERSION
def deploy_valid(addr, cversion) {
    def check = httpRequest "${addr}"
    return check.content.contains(cversion)
	if(check.contains(cversion)){
            echo "Deploy validation success"
        }
        else {
            echo "Deploy validation failed"
       }
	}
node ('master'){
  
  stage ('Clone repository') {
    	git url: 'https://github.com/AVShutov/devops_training.git', branch: "${TASK}"
  }
  stage ('Build') {
      sh ('chmod +x gradlew && ./gradlew increment_version && ./gradlew build -Dhttp.proxyHost=10.4.252.10 -Dhttp.proxyPort=3128 -Dhttps.proxyHost=10.4.252.10 -Dhttps.proxyPort=3128')
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
      sh "git push https://${GIT_CREDENTIALS}@github.com/AVShutov/devops_training.git ${TASK}"
    }
  }

  stage ('Upload to nexus') {
	
	withCredentials([usernameColonPassword(credentialsId: '64b138ef-9d2e-4d94-bf84-45336c0a941e', variable: 'NEXUS_CREDENTIALS')]) {
      def props = readProperties  file: './gradle.properties'
      def VER = props['MajorVersion']
      def BUI = props['BuildNumber']
	  VERSION = VER + '.' + BUI
      sh "curl -X PUT -u ${NEXUS_CREDENTIALS} -T ./build/libs/${TASK}.war ${NEXUS}${TASK}/${VER}.${BUI}/"
	  }
    }
  

    stage ('Build image') {
        sh "docker build --build-arg VERSION=${VERSION} -t localhost:5000/task4:${VERSION} ."
		sh "docker push localhost:5000/task4:${VERSION}"
    }
}
  node('node_remote') {
  stage ('Run on remote machine') {
        sh "docker pull 192.168.20.11:5000/task4:${VERSION}"
        sh "docker run -d -p 8082:8080 --name=task4c 192.168.20.11:5000/task4:${VERSION}"
        sleep (10)
	    deploy_valid(TOMCAT,VERSION)
	    sh "docker stop task4c"
        sh "docker rm task4c"
  }
}