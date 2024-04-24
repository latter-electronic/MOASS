pipeline {
    agent any

    stages {
        stage('Embedded Build') {
	        steps {
				dir('/var/jenkins_home/workspace/Moass/Embedded/electron-app') {
                    sh 'docker build -t embedded .'
                }
            }
        }
    }
}
